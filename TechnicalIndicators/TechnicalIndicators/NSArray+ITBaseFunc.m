//
//  NSArray+ITBaseFunc.m
//  TechnicalIndicators
//
//  Created by 许龙 on 2019/3/1.
//  Copyright © 2019 longxdragon. All rights reserved.
//

#import "NSArray+ITBaseFunc.h"

@implementation NSArray (ITBaseFunc)

- (NSArray *)calculateWithArray:(NSArray *)datas expressionType:(TIExpressionType)type {
    if (self.count != datas.count) {
        return [NSArray new];
    }
    NSMutableArray *rt = [NSMutableArray arrayWithCapacity:self.count];
    for (NSInteger i = 0; i < self.count; i++) {
        switch (type) {
            case TIExpressionTypeAdd: [rt addObject:@([self[i] doubleValue] + [datas[i] doubleValue])]; break;
            case TIExpressionTypeSubtract: [rt addObject:@([self[i] doubleValue] - [datas[i] doubleValue])]; break;
            case TIExpressionTypeMultiply: [rt addObject:@([self[i] doubleValue] * [datas[i] doubleValue])]; break;
            case TIExpressionTypeDivide: [rt addObject:@([self[i] doubleValue] / [datas[i] doubleValue])]; break;
            case TIExpressionTypeMore: [rt addObject:@([self[i] doubleValue] > [datas[i] doubleValue])]; break;
            case TIExpressionTypeMoreEqual: [rt addObject:@([self[i] doubleValue] >= [datas[i] doubleValue])]; break;
            case TIExpressionTypeLess: [rt addObject:@([self[i] doubleValue] < [datas[i] doubleValue])]; break;
            case TIExpressionTypeLessEqual: [rt addObject:@([self[i] doubleValue] <= [datas[i] doubleValue])]; break;
            case TIExpressionTypeAnd: [rt addObject:@([self[i] boolValue] && [datas[i] boolValue])]; break;
            case TIExpressionTypeOr: [rt addObject:@([self[i] boolValue] || [datas[i] boolValue])]; break;
        }
    }
    return [rt copy];
}

- (NSArray *)calculateWithDouble:(double)num expressionType:(TIExpressionType)type {
    NSMutableArray *rt = [NSMutableArray new];
    for (NSInteger i = 0; i < self.count; i++) {
        switch (type) {
            case TIExpressionTypeAdd: [rt addObject:@([self[i] doubleValue] + num)]; break;
            case TIExpressionTypeSubtract: [rt addObject:@([self[i] doubleValue] - num)]; break;
            case TIExpressionTypeMultiply: [rt addObject:@([self[i] doubleValue] * num)]; break;
            case TIExpressionTypeDivide: [rt addObject:@([self[i] doubleValue] / num)]; break;
            case TIExpressionTypeMore: [rt addObject:@([self[i] doubleValue] > num)]; break;
            case TIExpressionTypeMoreEqual: [rt addObject:@([self[i] doubleValue] >= num)]; break;
            case TIExpressionTypeLess: [rt addObject:@([self[i] doubleValue] < num)]; break;
            case TIExpressionTypeLessEqual: [rt addObject:@([self[i] doubleValue] <= num)]; break;
            case TIExpressionTypeAnd: [rt addObject:@([self[i] boolValue] && num)]; break;
            case TIExpressionTypeOr: [rt addObject:@([self[i] boolValue] || num)]; break;
        }
    }
    return [rt copy];
}

#pragma mark - H L O C

- (NSArray *)high {
    NSMutableArray *rt = [NSMutableArray arrayWithCapacity:self.count];
    for (NSInteger i = 0; i < self.count; i++) {
        [rt addObject:@([[self[i] objectForKey:@"h"] doubleValue])];
    }
    return [rt copy];
}

- (NSArray *)low {
    NSMutableArray *rt = [NSMutableArray arrayWithCapacity:self.count];
    for (NSInteger i = 0; i < self.count; i++) {
        [rt addObject:@([[self[i] objectForKey:@"l"] doubleValue])];
    }
    return [rt copy];
}

- (NSArray *)open {
    NSMutableArray *rt = [NSMutableArray arrayWithCapacity:self.count];
    for (NSInteger i = 0; i < self.count; i++) {
        [rt addObject:@([[self[i] objectForKey:@"o"] doubleValue])];
    }
    return [rt copy];
}

- (NSArray *)close {
    NSMutableArray *rt = [NSMutableArray arrayWithCapacity:self.count];
    for (NSInteger i = 0; i < self.count; i++) {
        [rt addObject:@([[self[i] objectForKey:@"c"] doubleValue])];
    }
    return [rt copy];
}

#pragma mark - Technical

- (NSArray *)ma:(NSInteger)n {
    NSMutableArray *mas = [NSMutableArray new];
    NSInteger count = MIN((NSInteger)self.count, n);
    
    double total = 0;
    for (NSInteger i = 0, max = self.count; i < max; i++) {
        double ma = 0;
        if (i < count) {
            total += [self[i] doubleValue];
            ma = total/(i+1);
        } else {
            total += [self[i] doubleValue];
            total -= [self[i-count] doubleValue];
            ma = total/count;
        }
        [mas addObject:[NSString stringWithFormat:@"%f", ma]];
    }
    return [mas copy];
}

- (NSArray *)ema:(NSInteger)n {
    NSMutableArray *emas = [NSMutableArray new];
    
    double ema = 0;
    for (NSInteger i = 0, max = self.count; i < max; i++) {
        if (i == 0) {
            ema = [self[i] doubleValue];
        } else {
            ema = ema * (n-1.f)/(n+1.f) + [self[i] doubleValue] * 2.f/(n+1.f);
        }
        [emas addObject:[NSString stringWithFormat:@"%f", ema]];
    }
    return [emas copy];
}

- (NSArray *)sma:(NSInteger)n m:(NSInteger)m {
    NSMutableArray *smas = [NSMutableArray new];
    
    double sma = 0;
    for (NSInteger i = 0, max = self.count; i < max; i++) {
        if (i == 0) {
            sma = [self[i] doubleValue];
        } else {
            sma = sma * (double)(n-m)/n + [self[i] doubleValue] * (double)m/n;
        }
        [smas addObject:[NSString stringWithFormat:@"%f", sma]];
    }
    return [smas copy];
}

- (NSArray *)avedev:(NSInteger)n {
    NSMutableArray *mds = [NSMutableArray new];
    NSInteger count = MIN(self.count, n);
    NSArray *mas = [self ma:n];
    
    for (NSInteger i = 0, max = self.count; i < max; i++) {
        double md, sum = 0;
        double ma = [mas[i] doubleValue];
        
        NSInteger min = MAX(i - count + 1, 0);
        NSInteger num = 0;
        for (NSInteger j = i; j >= min; j--) {
            double val = [self[i] doubleValue];
            sum += fabs(val - ma);
            num ++;
        }
        md = sum / num;
        
        [mds addObject:[NSString stringWithFormat:@"%f", md]];
    }
    return [mds copy];
}

- (NSArray *)ref:(NSInteger)n {
    NSMutableArray *refs = [NSMutableArray new];
    for (NSInteger i = 0, max = self.count; i < max; i++) {
        double ref = [self[i] doubleValue];
        if (i >= n) {
            ref = [self[i-n] doubleValue];
        }
        [refs addObject:[NSString stringWithFormat:@"%f", ref]];
    }
    return [refs copy];
}

- (NSArray *)hhv:(NSInteger)n {
    NSMutableArray *highs = [NSMutableArray new];
    NSMutableArray *deque = [NSMutableArray new];
    for (NSInteger i = 0; i < self.count; i++) {
        if (i >= n && [[deque firstObject] integerValue] <= i-n) {
            [deque removeObjectAtIndex:0];
        }
        
        double h = [self[i] doubleValue];
        while ([deque lastObject] && [self[[[deque lastObject] integerValue]] doubleValue] < h) {
            [deque removeLastObject];
        }
        [deque addObject:@(i)];
        
        NSInteger index = [[deque firstObject] integerValue];
        [highs addObject:[NSString stringWithFormat:@"%f", [self[index] doubleValue]]];
    }
    return [highs copy];
}

- (NSArray *)llv:(NSInteger)n {
    NSMutableArray *lows = [NSMutableArray new];
    NSMutableArray *deque = [NSMutableArray new];
    for (NSInteger i = 0; i < self.count; i++) {
        if (i >= n && [[deque firstObject] integerValue] <= i-n) {
            [deque removeObjectAtIndex:0];
        }
        
        double h = [self[i] doubleValue];
        while ([deque lastObject] && [self[[[deque lastObject] integerValue]] doubleValue] > h) {
            [deque removeLastObject];
        }
        [deque addObject:@(i)];
        
        [lows addObject:[NSString stringWithFormat:@"%f", [[deque firstObject] doubleValue]]];
    }
    return [lows copy];
}

- (NSArray *)barslast {
    NSMutableArray *barslasts = [NSMutableArray new];
    NSInteger num = -1;
    for (NSInteger i = 0; i < self.count; i++) {
        if ([self[i] boolValue]) {
            num = 0;
        } else {
            if (num >= 0) {
                num++;
            }
        }
        [barslasts addObject:@(num)];
    }
    return [barslasts copy];
}

- (NSArray *)eifByV1:(NSArray *)v1 v2:(NSArray *)v2 {
    if (self.count != v1.count || self.count != v2.count) {
        return nil;
    }
    NSMutableArray *eifs = [NSMutableArray new];
    for (NSInteger i = 0; i < self.count; i++) {
        if ([self[i] boolValue]) {
            [eifs addObject:v1[i]];
        } else {
            [eifs addObject:v2[i]];
        }
    }
    return [eifs copy];
}

- (NSArray *)drawText:(NSArray *)y text:(NSString *)text {
    if (self.count != y.count) {
        return nil;
    }
    NSMutableArray *rt = [NSMutableArray new];
    for (NSInteger i = 0; i < self.count; i++) {
        if ([self[i] boolValue]) {
            [rt addObject:@{ @"able" : @(YES), @"y" : y[i], @"txt" : text?:@"" }];
        } else {
            [rt addObject:@{ @"able" : @(NO), @"y" : y[i], @"txt" : @"" }];
        }
    }
    return [rt copy];
}

- (NSArray *)cross:(NSArray *)v {
    if (self.count != v.count) {
        return nil;
    }
    NSMutableArray *rt = [NSMutableArray new];
    for (NSInteger i = 0; i < self.count; i++) {
        if (i >= 1) {
            double ls = [self[i-1] doubleValue];
            double cs = [self[i] doubleValue];
            double lv = [v[i-1] doubleValue];
            double cv = [v[i] doubleValue];
            if (ls < lv && cs > cv) {
                [rt addObject:@(YES)];
            } else {
                [rt addObject:@(NO)];
            }
        } else {
            [rt addObject:@(NO)];
        }
    }
    return [rt copy];
}

- (NSArray *)andOperation:(NSArray *)v {
    if (self.count != v.count) {
        return nil;
    }
    NSMutableArray *rt = [NSMutableArray new];
    for (NSInteger i = 0; i < self.count; i++) {
        [rt addObject:@([self[i] boolValue] && [v[i] boolValue])];
    }
    return [rt copy];
}

@end
