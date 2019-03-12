//
//  TI_Define.h
//  TechnicalIndicators
//
//  Created by 许龙 on 2019/3/5.
//  Copyright © 2019 longxdragon. All rights reserved.
//

#ifndef TI_Define_h
#define TI_Define_h

typedef NS_ENUM(NSInteger, TIExpressionType) {
    TIExpressionTypeAdd = 0,
    TIExpressionTypeSubtract = 1,
    TIExpressionTypeMultiply = 2,
    TIExpressionTypeDivide = 3,
    TIExpressionTypeMore = 4,
    TIExpressionTypeMoreEqual = 5,
    TIExpressionTypeLess = 6,
    TIExpressionTypeLessEqual = 7,
    TIExpressionTypeAnd = 8,
    TIExpressionTypeOr = 9,
};


#endif /* TI_Define_h */
