//
//  NSString+TIBaseFunc.m
//  TechnicalIndicators
//
//  Created by 许龙 on 2019/3/5.
//  Copyright © 2019 longxdragon. All rights reserved.
//

#import "NSString+TIBaseFunc.h"

@implementation NSString (TIBaseFunc)

- (NSArray *)calculateWithArray:(NSArray *)datas expressionType:(TIExpressionType)type {
    NSMutableArray *rt = [NSMutableArray new];
    for (NSInteger i = 0; i < datas.count; i++) {
        switch (type) {
            case TIExpressionTypeAdd: [rt addObject:@([self doubleValue] + [datas[i] doubleValue])]; break;
            case TIExpressionTypeSubtract: [rt addObject:@([self doubleValue] - [datas[i] doubleValue])]; break;
            case TIExpressionTypeMultiply: [rt addObject:@([self doubleValue] * [datas[i] doubleValue])]; break;
            case TIExpressionTypeDivide: [rt addObject:@([self doubleValue] / [datas[i] doubleValue])]; break;
        }
    }
    return [rt copy];
}

@end
