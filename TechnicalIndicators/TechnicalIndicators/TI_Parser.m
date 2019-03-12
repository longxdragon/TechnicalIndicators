//
//  TI_Parser.m
//  TechnicalIndicators
//
//  Created by 许龙 on 2019/3/7.
//  Copyright © 2019 longxdragon. All rights reserved.
//

#import "TI_Parser.h"
#import "TI_TableManager.h"


@implementation TI_ASTreeNode

- (NSString *)description {
    return [NSString stringWithFormat:@"{ name : %@ }", self.name];
}

@end

@implementation TI_ASTree

/**
 创建语法抽象树
 */
- (instancetype)initWithPostExpressionStack:(TI_Stack *)expStack {
    if (self = [super init]) {
        // 翻转
        TI_Stack *newStack = [TI_Stack new];
        while (expStack.peek) {
            [newStack push:[expStack pop]];
        }
        TI_Stack *nodeStack = [TI_Stack new];
        
        while (newStack.peek) {
            TI_Token *token = (TI_Token *)[newStack pop];
            TI_ASTreeNode *node = [TI_ASTreeNode new];
            node.name = token.name;
            node.nodeType = TIASTreeNodeType_VALUE;
            
            if (token.type == TITokenType_FUNC || token.type == TITokenType_OPERATOR || token.type == TITokenType_FUNC_IDENTIFIER) {
                NSInteger deminsion = [TI_TableManager deminsionOfOperatorOrFunc:token.name];
                NSMutableArray<TI_ASTreeNode *> *child = [[NSMutableArray alloc] initWithCapacity:deminsion];
                for (NSInteger i = deminsion - 1; i >= 0; i--) {
                    [child insertObject:(TI_ASTreeNode *)[nodeStack pop] atIndex:0];
                }
                node.child = [child copy];
                node.nodeType = TIASTreeNodeType_FUNC;
            }
            [nodeStack push:node];
        }
        if ([nodeStack size] == 1) {
            self.root = (TI_ASTreeNode *)[nodeStack pop];
        }
    }
    return self;
}

@end



@interface TI_Statement ()

@end

@implementation TI_Statement

/**
 表达式验证
 
 Note:
 中缀表达式 -> 后缀表达式
 */
- (void)setExpression:(NSArray<TI_Token *> *)expression {
    _expression = expression;
    self.tree = [[TI_ASTree alloc] initWithPostExpressionStack:[self buildPostExpressionStack:expression]];
    if (!self.tree.root) {
        NSLog(@"-------- 语法错误：%@", expression);
    }
}

/**
 中缀表达式 -> 后缀表达式
 */
- (TI_Stack *)buildPostExpressionStack:(NSArray<TI_Token *> *)exps {
    TI_Stack *stack = [TI_Stack new];
    TI_Stack *retStack = [TI_Stack new];
    
    NSInteger i = 0;
    while (i < exps.count) {
        TI_Token *token = exps[i];
        
        if ([token.name isEqualToString:@"("]) {
            [stack push:token];
            
        } else if (token.type == TITokenType_OPERATOR) {
            // +、-、*、/
            TI_Token *lastToken = (TI_Token *)[stack peek];
            while ([TI_TableManager operatorPriority:lastToken.name] >= [TI_TableManager operatorPriority:token.name] || lastToken.type == TITokenType_FUNC || lastToken.type == TITokenType_FUNC_IDENTIFIER) {
                [retStack push:[stack pop]];
                lastToken = (TI_Token *)[stack peek];
            }
            [stack push:token];
            
        } else if (token.type == TITokenType_FUNC || token.type == TITokenType_FUNC_IDENTIFIER) {
            // MA、SMA、EMA 等自定义函数
            [stack push:token];
            
        } else if ([token.name isEqualToString:@","]) {
            // 自定义函数参数分隔符
            while (![((TI_Token *)[stack peek]).name isEqualToString:@"("]) {
                [retStack push:[stack pop]];
            }
        } else if ([token.name isEqualToString:@")"]) {
            while (![((TI_Token *)[stack peek]).name isEqualToString:@"("]) {
                [retStack push:[stack pop]];
            }
            [stack pop];
            
            TI_Token *lastToken = (TI_Token *)[stack peek];
            if (lastToken.type == TITokenType_FUNC || lastToken.type == TITokenType_FUNC_IDENTIFIER) {
                [retStack push:[stack pop]];
            }
        } else {
            [retStack push:token];
        }
        
        i++;
    }
    
    while ([stack peek]) {
        [retStack push:[stack pop]];
    }
    
    return retStack;
}

- (BOOL)isValied {
    return (self.tree != nil);
}

@end







@interface TI_Parser ()

@end

@implementation TI_Parser

- (NSArray<TI_Statement *> *)parse:(NSArray<TI_Token *> *)tokens {
    NSArray<TI_Statement *> *statements = [self validateTokens:tokens];
    if (!statements) {
        NSLog(@"-------- 语法错误");
    }
    return statements;
}

/**
 根据“单词序列”分析语法是否正确
 如果正确，则返回分析好的数组
 如果错误，则返回空数组
 
 Note: 拆分成对应的语句。
 */
- (NSArray *)validateTokens:(NSArray<TI_Token *> *)tokens {
    NSMutableArray *expressions = [NSMutableArray new];
    
    TI_Statement *exp = nil;
    NSMutableArray *exps = nil;
    NSInteger s = 0;

    for (NSInteger i = 0; i < tokens.count; i++) {
        TI_Token *token = tokens[i];
        TI_Token *next = nil;
        if (i + 1 < tokens.count) {
            next = tokens[i+1];
        }
        
        if (s == i) {
            if (token.type == TITokenType_IDENTIFIER && next && (next.type == TITokenType_EQUAL || next.type == TITokenType_RETURN)) {
                exp = [TI_Statement new];
                exp.var = token.name;
                exps = [NSMutableArray new];
            } else if (token.type == TITokenType_FUNC_IDENTIFIER) {
                exp = [TI_Statement new];
                exp.var = [NSString stringWithFormat:@"%@_%ld", token.name, (long)expressions.count];
                exps = [NSMutableArray arrayWithObject:token];
                exp.type = TIStatementType_RETURN;
            } else {
                return nil;
            }
        } else if (i == s + 1) {
            TI_Token *pre = tokens[i-1];
            if (pre.type == TITokenType_FUNC_IDENTIFIER) {
                [exps addObject:token];
            } else if (token.type == TITokenType_EQUAL) {
                continue;
            } else if (token.type == TITokenType_RETURN) {
                exp.type = TIStatementType_RETURN;
                continue;
            } else {
                return nil;
            }
        } else {
            if (token.type == TITokenType_SEPARATOR && [token.name isEqualToString:@";"]) {
                if (exps.count == 2) {
                    return nil;
                }
                if (exp.type != TIStatementType_RETURN) {
                    if (exps.count == 1) {
                        exp.type = TIStatementType_DEFINE;
                    } else if (exps.count >= 3) {
                        exp.type = TIStatementType_VALUE;
                    }
                }
                exp.expression = [exps copy];
                s = i + 1;
                
                [expressions addObject:exp];
            } else {
                [exps addObject:token];
            }
        }
    }
    
    return [expressions copy];
}

@end
