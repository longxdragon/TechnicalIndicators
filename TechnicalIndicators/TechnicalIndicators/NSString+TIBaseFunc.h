//
//  NSString+TIBaseFunc.h
//  TechnicalIndicators
//
//  Created by 许龙 on 2019/3/5.
//  Copyright © 2019 longxdragon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TI_Define.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSString (TIBaseFunc)

- (NSArray *)calculateWithArray:(NSArray *)datas expressionType:(TIExpressionType)type;

@end

NS_ASSUME_NONNULL_END
