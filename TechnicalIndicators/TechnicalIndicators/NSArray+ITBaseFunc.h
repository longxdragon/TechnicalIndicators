//
//  NSArray+ITBaseFunc.h
//  TechnicalIndicators
//
//  Created by 许龙 on 2019/3/1.
//  Copyright © 2019 longxdragon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TI_Define.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (ITBaseFunc)

- (NSArray *)calculateWithArray:(NSArray *)datas expressionType:(TIExpressionType)type;
- (NSArray *)calculateWithDouble:(double)num expressionType:(TIExpressionType)type;

- (NSArray *)high;
- (NSArray *)low;
- (NSArray *)open;
- (NSArray *)close;

- (NSArray *)ma:(NSInteger)n;
- (NSArray *)ema:(NSInteger)n;
- (NSArray *)sma:(NSInteger)n m:(NSInteger)m;
- (NSArray *)avedev:(NSInteger)n;
- (NSArray *)ref:(NSInteger)n;

@end

NS_ASSUME_NONNULL_END
