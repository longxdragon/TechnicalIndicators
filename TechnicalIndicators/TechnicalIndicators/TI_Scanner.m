//
//  TI_Scanner.m
//  TechnicalIndicators
//
//  Created by 许龙 on 2019/3/6.
//  Copyright © 2019 longxdragon. All rights reserved.
//

#import "TI_Scanner.h"
#import "TI_TableManager.h"


@implementation TI_Token

- (instancetype)initWithName:(NSString *)name type:(TITokenType)type {
    if (self = [super init]) {
        self.name = name;
        self.type = type;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@" { name: %@; type: %d }", self.name, (int)self.type];
}

@end



@implementation TI_Scanner

- (instancetype)initWithInput:(NSString *)input {
    if (self = [super init]) {
        [self scan:input];
    }
    return self;
}

- (void)scan:(NSString *)str {
    // 跳过空格、换行符
    str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (str.length == 0) {
        return;
    }
    
    NSInteger i = 0;
    NSMutableArray *tokens = [NSMutableArray new];
    while (i < str.length) {
        NSString *ch = [str substringWithRange:NSMakeRange(i++, 1)];
        unichar chr = [ch characterAtIndex:0];
        
        if ((chr >= 'a' && chr <= 'z') || (chr >= 'A' && chr <= 'Z') || chr == '_') {
            // 识别关键字 + 标识符
            NSMutableString *token = [[NSMutableString alloc] initWithString:ch];
            ch = [str substringWithRange:NSMakeRange(i++, 1)];
            chr = [ch characterAtIndex:0];
            
            while ((chr >= '0' && chr <= '9') || (chr >= 'a' && chr <= 'z') || (chr >= 'A' && chr <= 'Z') || chr == '_') {
                [token appendString:ch];
                ch = [str substringWithRange:NSMakeRange(i++, 1)];
                chr = [ch characterAtIndex:0];
            }
            i--;
            
            if ([TI_TableManager existFunc:token]) {
                [tokens addObject:[[TI_Token alloc] initWithName:token type:TITokenType_OPERATOR]];
            } else {
                [tokens addObject:[[TI_Token alloc] initWithName:token type:TITokenType_IDENTIFIER]];
            }
        }
        else if ((chr >= '0' && chr <= '9') || chr == '.') {
            // 识别数值
            NSMutableString *token = [[NSMutableString alloc] initWithString:ch];
            BOOL point = (chr == '.');
            ch = [str substringWithRange:NSMakeRange(i++, 1)];
            chr = [ch characterAtIndex:0];
            
            while ((chr >= '0' && chr <= '9') || (!point && chr == '.')) {
                [token appendString:ch];
                if (chr == '.') {
                    point = YES;
                }
                ch = [str substringWithRange:NSMakeRange(i++, 1)];
                chr = [ch characterAtIndex:0];
            }
            i--;
            
            [tokens addObject:[[TI_Token alloc] initWithName:token type:TITokenType_NUMBER]];
        }
        else if (chr == ':') {
            // 识别赋值符
            NSMutableString *token = [[NSMutableString alloc] initWithString:ch];
            ch = [str substringWithRange:NSMakeRange(i++, 1)];
            chr = [ch characterAtIndex:0];
            if (chr == '=') {
                [token appendString:ch];
                ch = [str substringWithRange:NSMakeRange(i++, 1)];
                chr = [ch characterAtIndex:0];
            }
            i--;
            
            [tokens addObject:[[TI_Token alloc] initWithName:token type:TITokenType_RETURN]];
        }
        else {
            // 识别赋值符 + 操作符 + 分隔符
            if (chr == '=') {
                [tokens addObject:[[TI_Token alloc] initWithName:ch type:TITokenType_EQUAL]];
            } else if (chr == '+' || chr == '-' || chr == '*' || chr == '/') {
                [tokens addObject:[[TI_Token alloc] initWithName:ch type:TITokenType_OPERATOR]];
            } else {
                [tokens addObject:[[TI_Token alloc] initWithName:ch type:TITokenType_SEPARATOR]];
            }
        }
    }
    
    self.tokens = [tokens copy];
}

@end
