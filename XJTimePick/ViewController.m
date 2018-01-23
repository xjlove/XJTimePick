//
//  ViewController.m
//  XJTimePick
//
//  Created by xj_love on 2018/1/23.
//  Copyright © 2018年 xj_love. All rights reserved.
//

#import "ViewController.h"
#import "XJCalendarSelecteViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"XJ时间选择器";
    
    UIButton *btn = [[UIButton alloc] init];
    btn.backgroundColor = [UIColor redColor];
    [btn setTitle:@"点击进入" forState:UIControlStateNormal];
    btn.frame = CGRectMake(80, 200, 100, 44);
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

#pragma mark - 使用范例
- (void)btnClick{
    
    XJCalendarSelecteViewController *calendarVC = [[XJCalendarSelecteViewController alloc] init];
    [self.navigationController pushViewController:calendarVC animated:YES];
    calendarVC.userSelcetResultBlock = ^(NSMutableDictionary *resultDictM) {
        NSLog(@"%@",resultDictM);
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
