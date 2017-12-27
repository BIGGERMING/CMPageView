//
//  ViewController.m
//  CMPageView
//
//  Created by 蔡明 on 2017/4/12.
//  Copyright © 2017年 com.baleijia. All rights reserved.
//

#import "ViewController.h"

#import "CMPageView.h"
#import "CMPageViewConfig.h"

#define CMNomalcolor(r ,g ,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

#define CMRandomColor CMNomalcolor(arc4random_uniform(256),arc4random_uniform(256),arc4random_uniform(256))

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 如果在导航控制器下 设置该属性
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 标题数组
    NSArray *titles = @[@"推荐", @"戏游戏", @"热门游戏", @"趣玩游玩玩",@"趣玩游",@"趣玩游",@"趣玩游",@"趣玩游",@"趣玩游",@"趣玩游",@"趣玩游"];
    
    // 控制器数组
    NSMutableArray<UIViewController *> *childVcs = [[NSMutableArray alloc] init];;
    
    for (int i = 0; i < titles.count; i++) {
        UIViewController *vc = [[UIViewController alloc] init];
        vc.view.backgroundColor = CMRandomColor;
        [childVcs addObject:vc];
    }

    NSLog(@"%ld",childVcs.count);
    
    // 基本UI配置
    CMPageViewConfig *config = [[CMPageViewConfig alloc] init];
    config.isScrollEnable = YES;
    config.titleHeight = 50;
    
    // 初始化传参
    CMPageView *pageView = [[CMPageView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64)
                                                      config:config
                                                  titleArray:titles
                                               chiledVcArray:childVcs parentVc:self];
    // 添加
    [self.view addSubview:pageView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
