//
//  TI_Compiler.m
//  TechnicalIndicators
//
//  Created by 许龙 on 2019/3/7.
//  Copyright © 2019 longxdragon. All rights reserved.
//

#import "TI_Compiler.h"
#import "TI_Scanner.h"
#import "TI_Parser.h"
#import "TI_TableManager.h"
#import "NSArray+ITBaseFunc.h"
#import "NSString+TIBaseFunc.h"

@interface TI_Compiler ()

@property (nonatomic, strong) NSMutableDictionary *varMappers;

@end

@implementation TI_Compiler

- (instancetype)init {
    self = [super init];
    if (self) {
        self.varMappers = [NSMutableDictionary new];
    }
    return self;
}

- (NSDictionary<NSString *, NSArray *> *)compileString:(NSString *)str datas:(NSArray<NSDictionary *> *)datas {
    // 词法解析
    TI_Scanner *scanner = [[TI_Scanner alloc] initWithInput:str];
    // 语法解析
    TI_Parser *parser = [[TI_Parser alloc] init];
    NSArray<TI_Statement *> *stms = [parser parse:scanner.tokens];
    // 语法树的计算
    NSDictionary *dic = [self computeStatements:stms datas:datas];
    return dic;
}

- (NSDictionary *)computeStatements:(NSArray<TI_Statement *> *)stms datas:(NSArray<NSDictionary *> *)datas {
    NSMutableDictionary *rt = [NSMutableDictionary new];
    for (TI_Statement *stm in stms) {
        if (!stm.tree.root) {
            return nil;
        }
        NSObject *val = [self computeSubTree:stm.tree.root datas:datas];
        if (val) {
            [self.varMappers setObject:val forKey:stm.var];
        }
        if (stm.type == TIStatementType_RETURN) {
            [rt setObject:val forKey:stm.var];
        }
    }
    return [rt copy];
}

- (NSObject *)computeSubTree:(TI_ASTreeNode *)root datas:(NSArray<NSDictionary *> *)datas {
    if (root == nil) {
        NSLog(@"-------- 空函数错误");
        return nil;
    }
    if (root.nodeType == TIASTreeNodeType_VALUE) {
        if ([self isNumber:root.name]) {
            return root.name;
        } else if ([self isString:root.name]) {
            return [root.name substringWithRange:NSMakeRange(1, root.name.length-2)];
        } else {
            NSObject *var = [self.varMappers objectForKey:root.name];
            if (var) {
                return var;
            } else {
                NSLog(@"-------- 未声明变量：%@", root.name);
                return nil;
            }
        }
    }
    NSArray<TI_ASTreeNode *> *child = root.child;
    if (child.count == 0) {
        if ([root.name isEqualToString:@"CLOSE"]) return [datas close];
        if ([root.name isEqualToString:@"OPEN"]) return [datas open];
        if ([root.name isEqualToString:@"HIGH"]) return [datas high];
        if ([root.name isEqualToString:@"LOW"]) return [datas low];
    }
    
    NSMutableArray *paramsVal = [NSMutableArray new];
    for (TI_ASTreeNode *node in child) {
        NSObject *val = [self computeSubTree:node datas:datas];
        if (val) {
            [paramsVal addObject:val];
        }
    }
    
    // 表达式计算
    if ([root.name isEqualToString:@"+"] ||
        [root.name isEqualToString:@"-"] ||
        [root.name isEqualToString:@"*"] ||
        [root.name isEqualToString:@"/"] ||
        [root.name isEqualToString:@">"] ||
        [root.name isEqualToString:@">="] ||
        [root.name isEqualToString:@"<"] ||
        [root.name isEqualToString:@"<="] ||
        [root.name isEqualToString:@"&&"] ||
        [root.name isEqualToString:@"||"]) {
        return [self combineParams:paramsVal expression:root.name];
    } else {
        return [self funcName:root.name params:paramsVal];
    }
}

#pragma mark - 函数映射

/**
 自定义函数调用
 */
- (NSObject *)funcName:(NSString *)func params:(NSArray *)params {
    NSObject *p1 = [params firstObject];
    if (![p1 isKindOfClass:[NSArray class]]) {
        NSLog(@"-------- 函数参数错误：%@", func);
        return nil;
    }
    
    NSArray *datas = (NSArray *)p1;
    if ([func isEqualToString:@"MA"] && params.count == 2) {
        return [datas ma:[params[1] integerValue]];
    } else if ([func isEqualToString:@"EMA"] && params.count == 2) {
        return [datas ema:[params[1] integerValue]];
    } else if ([func isEqualToString:@"SMA"] && params.count == 3) {
        return [datas sma:[params[1] integerValue] m:[params[2] integerValue]];
    } else if ([func isEqualToString:@"AVEDEV"] && params.count == 2) {
        return [datas avedev:[params[1] integerValue]];
    } else if ([func isEqualToString:@"REF"] && params.count == 2) {
        return [datas ref:[params[1] integerValue]];
    } else if ([func isEqualToString:@"HHV"] && params.count == 2) {
        return [datas hhv:[params[1] integerValue]];
    } else if ([func isEqualToString:@"LLV"] && params.count == 2) {
        return [datas llv:[params[1] integerValue]];
    } else if ([func isEqualToString:@"BARSLAST"] && params.count == 1) {
        return [datas barslast];
    } else if ([func isEqualToString:@"IF"] && params.count == 3) {
        return [datas eifByV1:params[1] v2:params[2]];
    } else if ([func isEqualToString:@"DRAWTEXT"] && params.count == 3) {
        return [datas drawText:params[1] text:[params[2] description]];
    } else if ([func isEqualToString:@"CROSS"] && params.count == 2) {
        return [datas cross:params[1]];
    } else if ([func isEqualToString:@"AND"] && params.count == 2) {
        return [datas andOperation:params[1]];
    }
    
    NSLog(@"-------- 调用了未定义的函数：%@", func);
    return nil;
}

/**
 通用符号计算
 */
- (NSObject *)combineParams:(NSArray *)params expression:(NSObject *)expression {
    // 运算符的容错
    if (![expression isKindOfClass:[NSString class]] || params.count != 2) {
        NSLog(@"-------- 函数参数错误：%@", expression);
        return nil;
    }
    
    NSObject *value1 = params[0];
    NSObject *value2 = params[1];
    NSString *exp = (NSString *)expression;
    TIExpressionType type = TIExpressionTypeAdd;
    if ([exp isEqualToString:@"-"]) {
        type = TIExpressionTypeSubtract;
    } else if ([exp isEqualToString:@"*"]) {
        type = TIExpressionTypeMultiply;
    } else if ([exp isEqualToString:@"/"]) {
        type = TIExpressionTypeDivide;
    } else if ([exp isEqualToString:@">"]) {
        type = TIExpressionTypeMore;
    } else if ([exp isEqualToString:@">="]) {
        type = TIExpressionTypeMoreEqual;
    } else if ([exp isEqualToString:@"<"]) {
        type = TIExpressionTypeLess;
    } else if ([exp isEqualToString:@"<="]) {
        type = TIExpressionTypeLessEqual;
    } else if ([exp isEqualToString:@"&&"]) {
        type = TIExpressionTypeAnd;
    } else if ([exp isEqualToString:@"||"]) {
        type = TIExpressionTypeOr;
    }
    
    // 常数 +-*/ 数组
    if ([value1 isKindOfClass:[NSString class]] && [value2 isKindOfClass:[NSArray class]]) {
        return [(NSString *)value1 calculateWithArray:(NSArray *)value2 expressionType:type];
    }
    // 常数 +-*/ 常数
    if ([value1 isKindOfClass:[NSString class]] && [value2 isKindOfClass:[NSString class]]) {
        return [NSString stringWithFormat:@"%f", [(NSString *)value1 doubleValue] + [(NSString *)value2 doubleValue]];
    }
    // 数组 +-*/ 常数
    if ([value1 isKindOfClass:[NSArray class]] && [value2 isKindOfClass:[NSString class]]) {
        return [(NSArray *)value1 calculateWithDouble:[(NSString *)value2 doubleValue] expressionType:type];
    }
    // 数组 +-*/ 数组
    if ([value1 isKindOfClass:[NSArray class]] && [value2 isKindOfClass:[NSArray class]]) {
        return [(NSArray *)value1 calculateWithArray:(NSArray *)value2 expressionType:type];
    }
    
    NSLog(@"-------- 函数参数错误：%@", expression);
    return nil;
}

- (BOOL)isNumber:(NSString *)str {
    if ([str rangeOfString:@"-"].location == 0) {
        str = [str substringFromIndex:1];
    }
    str = [str stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if (str.length == 0 || [str isEqualToString:@"."]) {
        return YES;
    }
    return NO;
}

- (BOOL)isString:(NSString *)str {
    if ([[str substringToIndex:1] isEqualToString:@"'"] && [[str substringFromIndex:(str.length-1)] isEqualToString:@"'"]) {
        return YES;
    }
    return NO;
}

@end
