//
//  TI_TableManager.h
//  TechnicalIndicators
//
//  Created by 许龙 on 2019/3/8.
//  Copyright © 2019 longxdragon. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TI_TableManager : NSObject

/** 是否是运算符 */
+ (BOOL)existOperator:(NSString *)name;

/** 是否是自定义函数 */
+ (BOOL)existFunc:(NSString *)name;

/** 运算符等级 */
+ (NSInteger)operatorPriority:(NSString *)name;

/** 运算符、函数的参数个数 */
+ (NSInteger)deminsionOfOperatorOrFunc:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
