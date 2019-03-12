//
//  TI_Scanner.h
//  TechnicalIndicators
//
//  Created by 许龙 on 2019/3/6.
//  Copyright © 2019 longxdragon. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TITokenType) {
    /** 标识符 */
    TITokenType_IDENTIFIER = 0,
    /** 操作符 +、-、*、/ */
    TITokenType_OPERATOR = 1,
    /** 数字 */
    TITokenType_NUMBER = 2,
    /** 字符串 */
    TITokenType_STRING = 3,
    /** 分隔符 (){},; */
    TITokenType_SEPARATOR = 4,
    /** 赋值符 = */
    TITokenType_EQUAL = 5,
    /** 赋值符 := */
    TITokenType_RETURN = 6,
    /** 函数关键字 */
    TITokenType_FUNC = 7,
    /** 函数变量 */
    TITokenType_FUNC_IDENTIFIER = 8,
};


/**
 单词 - 词法解释器分析后的最小单位
 */
@interface TI_Token : NSObject

- (instancetype)initWithName:(NSString *)name type:(TITokenType)type;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) TITokenType type;

@end


/**
 词法解释器
 Note:
 字符串 -> 单词(Token)
 */
@interface TI_Scanner : NSObject

- (instancetype)initWithInput:(NSString *)input;

@property (nonatomic, strong) NSArray<TI_Token *> *tokens;

@end

NS_ASSUME_NONNULL_END
