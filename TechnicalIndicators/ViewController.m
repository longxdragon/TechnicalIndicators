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
    for (NSInteger i = 0; i < 1000; i++) {
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
    
    
    NSString *cci = @"\
    N = 14;\
    TYP = (CLOSE+HIGH+LOW)/3;\
    CCI := (TYP-MA(TYP,N))/(0.015*AVEDEV(TYP,N));\
    ";
    NSDictionary *cciDic = [[TI_Compiler new] compileString:cci datas:list];
    NSLog(@"%@", cciDic);
    
}

@end
