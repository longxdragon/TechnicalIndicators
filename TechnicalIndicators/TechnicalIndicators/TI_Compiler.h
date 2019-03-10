//
//  TI_Compiler.h
//  TechnicalIndicators
//
//  Created by 许龙 on 2019/3/7.
//  Copyright © 2019 longxdragon. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 编译器
 */
@interface TI_Compiler : NSObject

- (NSDictionary<NSString *, NSArray *> *)compileString:(NSString *)str datas:(NSArray<NSDictionary *> *)datas;

@end

NS_ASSUME_NONNULL_END
