//
//  TI_Stack.m
//  TechnicalIndicators
//
//  Created by 许龙 on 2019/3/5.
//  Copyright © 2019 longxdragon. All rights reserved.
//

#import "TI_Stack.h"

@interface TI_Stack ()

@property (nonatomic, assign) NSInteger capacity;
@property (nonatomic, strong) NSMutableArray *array;

@end

@implementation TI_Stack

- (instancetype)initWithCapacity:(NSInteger)capacity {
    if (self = [super init]) {
        self.capacity = capacity;
        self.array = [[NSMutableArray alloc] initWithCapacity:capacity];
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        self.capacity = NSIntegerMax;
        self.array = [NSMutableArray new];
    }
    return self;
}

- (BOOL)push:(NSObject *)obj {
    if (self.array.count >= self.capacity - 1 || obj == nil) {
        return NO;
    }
    [self.array addObject:obj];
    return YES;
}

- (NSObject *)pop {
    if (self.size == 0) {
        return nil;
    }
    NSObject *obj = [self.array lastObject];
    [self.array removeLastObject];
    return obj;
}

- (NSObject *)peek {
    if (self.size == 0) {
        return nil;
    }
    return [self.array lastObject];
}

- (NSInteger)size {
    return self.array.count;
}

@end
