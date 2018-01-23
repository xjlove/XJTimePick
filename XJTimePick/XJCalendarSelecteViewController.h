//
//  XJCalendarSelecteViewController.h
//
//  Created by xj_love on 2018/1/22.
//  Copyright © 2018年 xj_love. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - 使用范例

@interface XJCalendarSelecteViewController : UIViewController

@property (copy,nonatomic) void (^userSelcetResultBlock) (NSMutableDictionary *resultDictM);

@end
