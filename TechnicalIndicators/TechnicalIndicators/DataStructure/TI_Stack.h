//
//  TI_Stack.h
//  TechnicalIndicators
//
//  Created by 许龙 on 2019/3/5.
//  Copyright © 2019 longxdragon. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TI_Stack : NSObject

- (instancetype)initWithCapacity:(NSInteger)capacity;

- (BOOL)push:(NSObject *)obj;
- (NSObject *)pop;
- (NSObject *)peek;
- (NSInteger)size;

@end

NS_ASSUME_NONNULL_END
