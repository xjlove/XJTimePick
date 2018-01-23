//
//  XJTimePickView.h
//
//  Created by xj_love on 2018/1/23.
//  Copyright © 2018年 xj_love. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XJTimePickView : UIView

/** 最小时间 */
@property (strong, nonatomic) NSDate *minimumDate;

@property (copy,nonatomic) void (^calendarChangeBlock) (NSString *changeTime);

@end
