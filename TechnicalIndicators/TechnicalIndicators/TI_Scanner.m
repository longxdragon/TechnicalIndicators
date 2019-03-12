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
    NSInteger i = 0;
    NSMutableArray *tokens = [NSMutableArray new];
    while (i < str.length) {
        TITokenType type = ((TI_Token *)[tokens lastObject]).type;
        NSString *ch = [str substringWithRange:NSMakeRange(i++, 1)];
        unichar chr = [ch characterAtIndex:0];
        
        while ((chr == ' ' || chr == '\n') && i < str.length) {
            ch = [str substringWithRange:NSMakeRange(i++, 1)];
            chr = [ch characterAtIndex:0];
        }
        
        if ((chr >= 'a' && chr <= 'z') || (chr >= 'A' && chr <= 'Z') || chr == '_' || (chr >= 0x4e00 && chr <= 0x9fff)) {
            // 识别关键字 + 标识符 + 中英文
            NSMutableString *token = [[NSMutableString alloc] initWithString:ch];
            ch = [str substringWithRange:NSMakeRange(i++, 1)];
            chr = [ch characterAtIndex:0];
            
            while ((chr >= '0' && chr <= '9') || (chr >= 'a' && chr <= 'z') || (chr >= 'A' && chr <= 'Z') || chr == '_' || (chr >= 0x4e00 && chr <= 0x9fff)) {
                [token appendString:ch];
                ch = [str substringWithRange:NSMakeRange(i++, 1)];
                chr = [ch characterAtIndex:0];
            }
            i--;
            // 变量后面是不可以直接接“(”，只可能是函数
            if ([TI_TableManager existFunc:token]) {
                [tokens addObject:[[TI_Token alloc] initWithName:token type:TITokenType_FUNC]];
            } else if ([TI_TableManager existFuncIdentify:token]) {
                [tokens addObject:[[TI_Token alloc] initWithName:token type:TITokenType_FUNC_IDENTIFIER]];
            } else {
                [tokens addObject:[[TI_Token alloc] initWithName:token type:TITokenType_IDENTIFIER]];
            }
        }
        else if (chr >= '0' && chr <= '9') {
            // 识别数值
            NSMutableString *token = [[NSMutableString alloc] initWithString:ch];
            BOOL point = NO;
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
        else if (chr == '-' && type != TITokenType_IDENTIFIER && type != TITokenType_FUNC) {
            NSMutableString *token = [[NSMutableString alloc] initWithString:ch];
            ch = [str substringWithRange:NSMakeRange(i++, 1)];
            chr = [ch characterAtIndex:0];
            
            if (chr >= '0' && chr <= '9') {
                [token appendString:ch];
                BOOL point = NO;
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
                
            } else {
                [tokens addObject:[[TI_Token alloc] initWithName:ch type:TITokenType_OPERATOR]];
            }
        }
        else if (chr == '\'') {
            // 识别数值
            NSMutableString *token = [[NSMutableString alloc] initWithString:ch];
            ch = [str substringWithRange:NSMakeRange(i++, 1)];
            chr = [ch characterAtIndex:0];
            
            while (chr != '\'') {
                [token appendString:ch];
                ch = [str substringWithRange:NSMakeRange(i++, 1)];
                chr = [ch characterAtIndex:0];
            }
            
            [token appendString:@"'"];
            [tokens addObject:[[TI_Token alloc] initWithName:token type:TITokenType_STRING]];
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
                
                [tokens addObject:[[TI_Token alloc] initWithName:token type:TITokenType_EQUAL]];
            } else {
                [tokens addObject:[[TI_Token alloc] initWithName:token type:TITokenType_RETURN]];
            }
            i--;
        }
        else if (chr == '>' || chr == '<') {
            // 比较符
            NSMutableString *token = [[NSMutableString alloc] initWithString:ch];
            ch = [str substringWithRange:NSMakeRange(i++, 1)];
            chr = [ch characterAtIndex:0];
            if (chr == '=') {
                [token appendString:ch];
                ch = [str substringWithRange:NSMakeRange(i++, 1)];
                chr = [ch characterAtIndex:0];
            }
            i--;
            
            [tokens addObject:[[TI_Token alloc] initWithName:token type:TITokenType_OPERATOR]];
        }
        else if (chr == '&') {
            // 识别赋值符
            NSMutableString *token = [[NSMutableString alloc] initWithString:ch];
            ch = [str substringWithRange:NSMakeRange(i++, 1)];
            chr = [ch characterAtIndex:0];
            if (chr == '&') {
                [token appendString:ch];
                ch = [str substringWithRange:NSMakeRange(i++, 1)];
                chr = [ch characterAtIndex:0];
            }
            i--;
            
            [tokens addObject:[[TI_Token alloc] initWithName:token type:TITokenType_OPERATOR]];
        }
        else if (chr == '|') {
            // 识别赋值符
            NSMutableString *token = [[NSMutableString alloc] initWithString:ch];
            ch = [str substringWithRange:NSMakeRange(i++, 1)];
            chr = [ch characterAtIndex:0];
            if (chr == '|') {
                [token appendString:ch];
                ch = [str substringWithRange:NSMakeRange(i++, 1)];
                chr = [ch characterAtIndex:0];
            }
            i--;
            
            [tokens addObject:[[TI_Token alloc] initWithName:token type:TITokenType_OPERATOR]];
        }
        else if ([TI_TableManager existOperator:ch]) {
            [tokens addObject:[[TI_Token alloc] initWithName:ch type:TITokenType_OPERATOR]];
        }
        else if (chr == '(' || chr == ')' || chr == '{' || chr == '}' || chr == ',' || chr == ';') {
            [tokens addObject:[[TI_Token alloc] initWithName:ch type:TITokenType_SEPARATOR]];
        }
    }
    
    self.tokens = [tokens copy];
}

@end
