//
//  ViewController.m
//  TechnicalIndicators
//
//  Created by 许龙 on 2019/3/1.
//  Copyright © 2019 longxdragon. All rights reserved.
//

#import "ViewController.h"

#import "NSArray+ITBaseFunc.h"
#import "TechnicalIndicators/TI_Compiler.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
        
    NSMutableArray *list = [NSMutableArray new];
    for (NSInteger i = 0; i < 10; i++) {
        [list addObjectsFromArray:@[
                                    @{ @"h":@"20", @"l":@"10", @"c":@"14", @"o":@"16"},
                                    @{ @"h":@"22", @"l":@"11", @"c":@"12", @"o":@"10"},
                                    @{ @"h":@"23", @"l":@"12", @"c":@"11", @"o":@"18"},
                                    @{ @"h":@"22", @"l":@"9", @"c":@"11", @"o":@"12"},
                                    @{ @"h":@"20", @"l":@"7", @"c":@"10", @"o":@"9"}
                                    ]];
    }
    
    
//    NSString *bias = @"\
//    L1 = 6;\
//    L2 = 12;\
//    L3 = 24;\
//    BIAS1 := (CLOSE-MA(CLOSE,L1))/MA(CLOSE,L1)*100;\
//    BIAS2 := (CLOSE-MA(CLOSE,L2))/MA(CLOSE,L2)*100;\
//    BIAS3 := (CLOSE-MA(CLOSE,L3))/MA(CLOSE,L3)*100;\
//    ";
//    NSDate *date = [NSDate date];
//    NSDictionary *biasDic = [[TI_Compiler new] compileString:bias datas:list];
//    NSLog(@"%f", [[NSDate date] timeIntervalSinceDate:date]);
//    NSLog(@"%@", biasDic);
    
    
    
//    NSString *cci = @"\
//    N = 14;\
//    TYP = (CLOSE+HIGH+LOW)/3;\
//    CCI := (TYP-KMA(TYP,N))/(0.015*AVEDEV(TYP,N));\
//    ";
//    NSDate *date = [NSDate date];
//    NSDictionary *cciDic = [[TI_Compiler new] compileString:cci datas:list];
//    NSLog(@"%f", [[NSDate date] timeIntervalSinceDate:date]);
//    NSLog(@"%@", cciDic);
    
    
    
//    NSString *macd = @"\
//    L := 12;\
//    M := 9;\
//    H := 26;\
//    DIF : EMA(CLOSE, L) - EMA(CLOSE, H);\
//    DEA : EMA(DIF, M);\
//    MACD : (DIF - DEA)*2;\
//    ";
//    NSDate *date = [NSDate date];
//    NSDictionary *macdDic = [[TI_Compiler new] compileString:macd datas:list];
//    NSLog(@"%f", [[NSDate date] timeIntervalSinceDate:date]);
//    NSLog(@"%@", macdDic);
    
    
    
    NSString *cci = @"\
    HH := HHV(HIGH, 219);\
    LL := LLV(LOW, 219);\
    HH1 := BARSLAST((HH > REF(HH,1)));\
    LL1 := BARSLAST((LL < REF(LL,1)));\
    X : IF((HH1 < LL1), LL, HH);\
    Y : IF((HH1 > LL1), HH, LL);\
    DRAWTEXT(CROSS(HH1,LL1), HH, '空头');\
    DRAWTEXT(CROSS(LL1,HH1), LL, '多头');\
    \
    MA05 : MA(CLOSE,45);\
    MA10 : MA(CLOSE,13);\
    VAR1 : MA(CLOSE,55);\
    \
    M := 14;\
    TYP := (HIGH + LOW + CLOSE)/3;\
    CCI := (TYP-MA(TYP,M))/(0.015*AVEDEV(TYP,M));\
    \
    DRAWTEXT(HH1>LL1 && CLOSE<VAR1 && CCI>=100, HIGH+0.005, '卖');\
    DRAWTEXT(HH1<LL1 && CLOSE>VAR1 && CCI<=-100, LOW-0.005, '买');\
    \
    支撑位 : LLV(LOW,219);\
    压力位 : HHV(HIGH,219);\
    ";
    NSDate *date = [NSDate date];
    NSDictionary *cciDic = [[TI_Compiler new] compileString:cci datas:list];
    NSLog(@"%f", [[NSDate date] timeIntervalSinceDate:date]);
    NSLog(@"%@", cciDic);
    
    
    //    PARTLINE(VAR1>REF(VAR1,1), VAR1);\
    //    PARTLINE(VAR1<REF(VAR1,1), VAR1);\

}

@end
