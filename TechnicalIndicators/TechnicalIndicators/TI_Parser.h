//
//  TI_Parser.h
//  TechnicalIndicators
//
//  Created by 许龙 on 2019/3/7.
//  Copyright © 2019 longxdragon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TI_Scanner.h"
#import "DataStructure/TI_Stack.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TIStatementType) {
    TIStatementType_DEFINE = 0, /** 声明表达式 */
    TIStatementType_VALUE = 1, /** 赋值表达式 */
    TIStatementType_RETURN = 2, /** 返回表达式 */
};

typedef NS_ENUM(NSInteger, TIASTreeNodeType) {
    TIASTreeNodeType_FUNC = 0,  /** 函数或者运算符 */
    TIASTreeNodeType_VALUE = 1, /** 变量或者数值 */
};




@interface TI_ASTreeNode : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) TIASTreeNodeType nodeType;
@property (nonatomic, strong) NSArray<TI_ASTreeNode *> *child;

@end

/**
 根据后缀表达式 -> AST语法抽象树
 */
@interface TI_ASTree : NSObject

- (instancetype)initWithPostExpressionStack:(TI_Stack *)expStack;

@property (nonatomic, strong) TI_ASTreeNode *root;

@end


/**
 语句对象
 */
@interface TI_Statement : NSObject

@property (nonatomic, strong) TI_Token *var;
@property (nonatomic, assign) TIStatementType type;
@property (nonatomic, copy) NSArray<TI_Token *> *expression;

@property (nonatomic, assign) BOOL isValied;
@property (nonatomic, strong) TI_ASTree *tree;

@end



/**
 语法+语义分析器：根据词法分析后的单词，进行语法分析
 
 Note:
 1、语法的正确性；
 2、确定是”声明表达式“还是”赋值表达式“
 3、构建语法抽象树(AST) -> 只有”赋值表达式“才需要
 */
@interface TI_Parser : NSObject

- (NSArray<TI_Statement *> *)parse:(NSArray<TI_Token *> *)tokens;

@end

NS_ASSUME_NONNULL_END
