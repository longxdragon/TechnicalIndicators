//
//  TI_TableManager.m
//  TechnicalIndicators
//
//  Created by 许龙 on 2019/3/8.
//  Copyright © 2019 longxdragon. All rights reserved.
//

#import "TI_TableManager.h"

@interface TI_TableManager ()

@property (nonatomic, strong) NSMutableDictionary *operatorMapper;
@property (nonatomic, strong) NSMutableDictionary *funcIdentifyMapper;
@property (nonatomic, strong) NSMutableDictionary *funcMapper;
@property (nonatomic, strong) NSMutableDictionary *deminsionMapper;

@end

@implementation TI_TableManager

+ (instancetype)shareManager {
    static TI_TableManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[TI_TableManager alloc] init];
    });
    return manager;
}

+ (BOOL)existOperator:(NSString *)name {
    if ([[TI_TableManager shareManager].operatorMapper objectForKey:name]) {
        return YES;
    }
    return NO;
}

+ (BOOL)existFunc:(NSString *)name {
    if ([[TI_TableManager shareManager].funcMapper objectForKey:name]) {
        return YES;
    }
    return NO;
}

+ (BOOL)existFuncIdentify:(NSString *)name {
    if ([[TI_TableManager shareManager].funcIdentifyMapper objectForKey:name]) {
        return YES;
    }
    return NO;
}

+ (NSInteger)operatorPriority:(NSString *)name {
    return [[[TI_TableManager shareManager].operatorMapper objectForKey:name] integerValue];
}

+ (NSInteger)deminsionOfOperatorOrFunc:(NSString *)name {
    return [[[TI_TableManager shareManager].deminsionMapper objectForKey:name] integerValue];
}

- (NSMutableDictionary *)operatorMapper {
    if (!_operatorMapper) {
        _operatorMapper = [@{@"+" : @(2),
                             @"-" : @(2),
                             @"*" : @(3),
                             @"/" : @(3),
                             @">" : @(4),
                             @">=" : @(4),
                             @"<" : @(4),
                             @"<=" : @(4),
                             @"&&" : @(1),
                             @"||" : @(1),
                             @"(" : @(0),
                             } mutableCopy];
    }
    return _operatorMapper;
}

- (NSMutableDictionary *)funcMapper {
    if (!_funcMapper) {
        _funcMapper = [@{@"CLOSE" : @(YES),
                         @"OPEN" : @(YES),
                         @"HIGH" : @(YES),
                         @"LOW" : @(YES),
                         @"MA" : @(YES),
                         @"EMA" : @(YES),
                         @"SMA" : @(YES),
                         @"AVEDEV" : @(YES),
                         @"REF" : @(YES),
                         @"HHV" : @(YES),
                         @"LLV" : @(YES),
                         @"BARSLAST" : @(YES),
                         @"IF" : @(YES),
                         @"CROSS" : @(YES),
                         } mutableCopy];
    }
    return _funcMapper;
}

- (NSMutableDictionary *)funcIdentifyMapper {
    if (!_funcIdentifyMapper) {
        _funcIdentifyMapper = [@{@"DRAWTEXT" : @(YES)} mutableCopy];
    }
    return _funcIdentifyMapper;
}

- (NSMutableDictionary *)deminsionMapper {
    if (!_deminsionMapper) {
        _deminsionMapper = [@{@"+" : @(2),
                              @"-" : @(2),
                              @"*" : @(2),
                              @"/" : @(2),
                              @">" : @(2),
                              @">=" : @(2),
                              @"<" : @(2),
                              @"<=" : @(2),
                              @"&&" : @(2),
                              @"||" : @(2),
                              @"MA" : @(2),
                              @"EMA" : @(2),
                              @"SMA" : @(3),
                              @"AVEDEV" : @(2),
                              @"REF" : @(2),
                              @"CLOSE" : @(0),
                              @"OPEN" : @(0),
                              @"HIGH" : @(0),
                              @"LOW" : @(0),
                              @"HHV" : @(2),
                              @"LLV" : @(2),
                              @"BARSLAST" : @(1),
                              @"IF" : @(3),
                              @"DRAWTEXT" : @(3),
                              @"CROSS" : @(2),
                              } mutableCopy];
    }
    return _deminsionMapper;
}

@end
