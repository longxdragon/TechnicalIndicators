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

@end
