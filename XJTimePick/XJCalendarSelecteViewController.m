//
//  CQTCalendarSelecteViewController.m
//
//  Created by xj_love on 2018/1/22.
//  Copyright © 2018年 xj_love. All rights reserved.
//

#import "XJCalendarSelecteViewController.h"
#import "XJTimePickView.h"

#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height
#define WS(weakSelf) __weak __typeof__(self) weakSelf = self;
#define kRGBColor(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

@interface XJCalendarSelecteViewController ()
@property (weak, nonatomic) IBOutlet UIButton *startTimeButton;
@property (weak, nonatomic) IBOutlet UIView *startBottomView;
@property (weak, nonatomic) IBOutlet UIButton *endTimeButton;
@property (weak, nonatomic) IBOutlet UIView *endBottomView;
@property (weak, nonatomic) IBOutlet UIView *selectTimeBackView;

@property (strong,nonatomic) XJTimePickView *timePickView;
@property (assign,nonatomic) BOOL isEndTime;
@end

@implementation XJCalendarSelecteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择时间";
    
    [self loadAllView];
}

- (void)loadAllView{
    
    [_selectTimeBackView addSubview:self.timePickView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(0, 0, 40, 40);
    [btn setTitle:@"完成" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:18];
    [btn setTitleColor:kRGBColor(255, 99, 51) forState:UIControlStateNormal];
    [btn addTarget:self action: @selector(manageCouponMenu) forControlEvents: UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

#pragma mark - 完成回调
- (void)manageCouponMenu{
    if (_userSelcetResultBlock) {
        NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
        [dictM setValue:_startTimeButton.titleLabel.text forKey:@"startTime"];
        [dictM setValue:_endTimeButton.titleLabel.text forKey:@"endTime"];
        _userSelcetResultBlock(dictM);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 按钮事件
- (IBAction)startTimeButtonAction:(UIButton *)sender {
    if (_isEndTime) {
        self.isEndTime = NO;
    }
}

- (IBAction)endTimeButtonAction:(UIButton *)sender {
    if (!_isEndTime) {
     self.isEndTime = YES;
    }
}

#pragma mark - 修改状态
- (void)setIsEndTime:(BOOL)isEndTime{
    _isEndTime = isEndTime;
    
    if (_isEndTime) {
        [_startTimeButton setTitleColor:kRGBColor(40, 40, 40) forState:UIControlStateNormal];
        _startBottomView.backgroundColor = kRGBColor(40, 40, 40);
        [_endTimeButton setTitleColor:kRGBColor(255, 99, 51) forState:UIControlStateNormal];
        _endBottomView.backgroundColor = kRGBColor(255, 99, 51);
    }else{
        [_startTimeButton setTitleColor:kRGBColor(255, 99, 51) forState:UIControlStateNormal];
        _startBottomView.backgroundColor = kRGBColor(255, 99, 51);
        if ([_endTimeButton.titleLabel.text isEqualToString:@"结束时间"]) {
            [_endTimeButton setTitleColor:kRGBColor(195, 195, 195) forState:UIControlStateNormal];
            _endBottomView.backgroundColor = kRGBColor(195, 195, 195);
        }else{
            [_endTimeButton setTitleColor:kRGBColor(40, 40, 40) forState:UIControlStateNormal];
            _endBottomView.backgroundColor = kRGBColor(40, 40, 40);
        }
    }
}

#pragma mark - 懒加载
- (XJTimePickView *)timePickView{
    if (!_timePickView) {
        _timePickView = [[XJTimePickView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, _selectTimeBackView.frame.size.height)];
        WS(weakSelf)
        _timePickView.calendarChangeBlock = ^(NSString *changeTime) {
            if (weakSelf.isEndTime) {
                [weakSelf.endTimeButton setTitle:changeTime forState:UIControlStateNormal];
            }else{
                [weakSelf.startTimeButton setTitle:changeTime forState:UIControlStateNormal];
            }
        };
    }
    return _timePickView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
