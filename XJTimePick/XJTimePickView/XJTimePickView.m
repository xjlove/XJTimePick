//
//  XJTimePickView.m
//
//  Created by xj_love on 2018/1/23.
//  Copyright © 2018年 xj_love. All rights reserved.
//

#import "XJTimePickView.h"

/** 时间格式 */
#define DateFormat @"yyyy.MM.dd"

#define kITLocalDate(date) \

@interface XJTimePickView ()<UIPickerViewDelegate,UIPickerViewDataSource>

/** 最大时间 */
@property (nullable, strong, nonatomic) NSDate *maximumDate;

/** 选择器 */
@property (nonatomic,strong) UIPickerView *pickerView;

/** 年份Max */
@property (nonatomic, assign) NSInteger maxYear;

/** 月份Max */
@property (nonatomic, assign) NSInteger maxMonth;

@property (assign,nonatomic) NSInteger maxDay;

/** 年份min */
@property (nonatomic, assign) NSInteger minYear;

/** 月份min */
@property (nonatomic, assign) NSInteger minMonth;

@property (assign,nonatomic) NSInteger minDay;

@property (strong, nonatomic) NSDateFormatter *dateFormatter;

/** 年份数组 */
@property (nonatomic,strong) NSMutableArray *yearArray;

/** 月份数组 */
@property (nonatomic,strong) NSMutableArray *monthArray;

@property (strong,nonatomic) NSMutableArray *dayArrM;

/** 选中的年份 */
@property (nonatomic, copy) NSString *choosedYear;

/** 选中的月份 */
@property (nonatomic, copy) NSString *choosedMonth;

@property (copy,nonatomic) NSString *chooseDay;

/** 是否是当前年份 */
@property (nonatomic, assign) BOOL isCurrentYear;

/** 是否是第一年 */
@property (nonatomic, assign) BOOL isFirstYear;

@end

@implementation XJTimePickView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        [self show];
    }
    return self;
}

#pragma mark - 显示
- (void)show{
    
    // 初始化获取数据
    [self getData];
    [self addSubview:self.pickerView];
    
}

#pragma mark - 始化获取数据
- (void)getData{
    
    // 最大时间
    if (self.maximumDate == nil) {
        self.maximumDate = [self.dateFormatter dateFromString:[self getCurrentTimes]];
    }
    self.maximumDate = [self.maximumDate copy];
    
    kITLocalDate(_maximumDate);
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:_maximumDate];
    self.maxYear = [components year];
    self.maxMonth = [components month];
    self.maxDay = [components day];
    
    // 最小时间
    if (self.minimumDate == nil) {
        self.minimumDate = [self.dateFormatter dateFromString:@"2016.01.01"];
    }
    
    self.minimumDate = [self.minimumDate copy];
    
    kITLocalDate(_minimumDate);
    
    NSCalendar *calendar2 = [NSCalendar currentCalendar];
    NSDateComponents *components2 = [calendar2 components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:self.minimumDate];
    self.minYear = [components2 year];
    self.minMonth = [components2 month];
    self.minDay = [components2 day];
    
    // 年份数组
    for (NSInteger i = self.minYear; i<=self.maxYear; i++) {
        [self.yearArray addObject:[NSString stringWithFormat:@"%ld",i]];
    }
    
}

#pragma mark - UIPickerViewDelegate+UIPickerViewDataSource
// 返回选择器有几列.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

// 返回每组有几行
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if (component == 0) {
        return self.yearArray.count;
    }else if(component == 1){
        if (_isCurrentYear == YES) { // 当前年
            if (_isFirstYear == YES) {
                return (self.maxMonth - self.minMonth +1);
            }else{
                return self.maxMonth;
            }
        }else{
            if (_isFirstYear == YES) {
                return (12 - self.minMonth +1);
            }else{
                return 12;
            }
        }
    }else{
        return self.dayArrM.count;
    }
}

// 返回第component列第row行的内容（标题）
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        return [NSString stringWithFormat:@"%@年",self.yearArray[row]];
    }else if(component == 1){
        if (_isFirstYear == YES) {
            return [NSString stringWithFormat:@"%@月",self.monthArray[self.minMonth + row -1]];
        }else{
            return [NSString stringWithFormat:@"%@月",self.monthArray[row]];
        }
    }else{
        return [NSString stringWithFormat:@"%@日",self.dayArrM[row]];
    }
}

// 选中第component第row的时候调用
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if (component == 0) {
        if (row == self.yearArray.count - 1) { // 当前年份
            _isCurrentYear = YES; // 当前年
        }else{
            _isCurrentYear = NO;
        }
        if (row == 0) {
            _isFirstYear = YES;
        }else{
            _isFirstYear = NO;
        }
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:NO];
        self.choosedYear = self.yearArray[row];
        self.choosedMonth = @"01";
        self.chooseDay = @"01";
        [self setNewDayArrM];//更新天数
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:NO];
    }else if(component == 1){
        if (_isFirstYear == YES) { // 第一年
            self.choosedMonth = self.monthArray[row + self.minMonth - 1];
        }else{
            self.choosedMonth = self.monthArray[row];
        }
        self.chooseDay = @"01";
        [self setNewDayArrM];//更新天数
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:NO];
    }else{
        self.chooseDay = self.dayArrM[row];
    }
    if (self.calendarChangeBlock) {
        self.calendarChangeBlock([NSString stringWithFormat:@"%@-%@-%@",self.choosedYear,self.choosedMonth,self.chooseDay]);
    }
}

#pragma mark - 重置天数数组数据
- (void)setNewDayArrM{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM"]; // 年-月
    NSString *dateStr = [NSString stringWithFormat:@"%@-%@",self.choosedYear,self.choosedMonth];
    NSDate * date = [formatter dateFromString:dateStr];
    NSCalendar *calendar3 = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSRange range = [calendar3 rangeOfUnit:NSCalendarUnitDay
                                    inUnit: NSCalendarUnitMonth
                                   forDate:date];
    [self.dayArrM removeAllObjects];
    
    if (_isCurrentYear) {
        if (self.maxMonth == [self.choosedMonth integerValue]) {
            for (int i = 1; i<=self.maxDay; i++) {
                [self.dayArrM addObject:[NSString stringWithFormat:@"%02d",i]];
            }
        }
    }else{
        for (int i = 1; i<=range.length; i++) {
            [self.dayArrM addObject:[NSString stringWithFormat:@"%02d",i]];
        }
    }
}

#pragma mark - 懒加载
- (UIPickerView *)pickerView{
    if (!_pickerView) {
        // 选择器
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        _pickerView.backgroundColor = [UIColor whiteColor];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        _pickerView.showsSelectionIndicator = YES;
        self.choosedYear = [NSString stringWithFormat:@"%ld",self.maxYear];
        self.choosedMonth = [NSString stringWithFormat:@"%ld",self.maxMonth];
        [_pickerView selectRow:self.maxYear-self.minYear inComponent:0 animated:NO];
        [self pickerView:_pickerView didSelectRow:self.maxYear-self.minYear inComponent:0];
    }
    return _pickerView;
}

- (NSMutableArray *)yearArray{
    if (_yearArray == nil) {
        _yearArray = [[NSMutableArray alloc] init];
    }
    return _yearArray;
}

- (NSMutableArray *)monthArray{
    if (_monthArray == nil) {
        _monthArray = [[NSMutableArray alloc] init];
        for (int i = 1; i<=12; i++) {
            [_monthArray addObject:[NSString stringWithFormat:@"%02d",i]];
        }
    }
    return _monthArray;
}

- (NSMutableArray *)dayArrM{
    if (!_dayArrM) {
        _dayArrM = [[NSMutableArray alloc] init];
    }
    return _dayArrM;
}

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = DateFormat;
    }
    return _dateFormatter;
}


#pragma mark - 重写方法设置字体
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    //设置分割线的颜色
    ((UIView *)[pickerView.subviews objectAtIndex:1]).backgroundColor = [UIColor colorWithRed:195/255.0 green:195/255.0 blue:195/255.0 alpha:1.0];
    ((UIView *)[pickerView.subviews objectAtIndex:2]).backgroundColor = [UIColor colorWithRed:195/255.0 green:195/255.0 blue:195/255.0 alpha:1.0];
    
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:23]];
        pickerLabel.textColor = [UIColor colorWithRed:40/255.0 green:40/255.0 blue:40/255.0 alpha:1.0];
    }
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

#pragma mark - 取得当前时间
- (NSString*)getCurrentTimes{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    [formatter setDateFormat:@"yyyy.MM.dd"];
    //现在时间,你可以输出来看下是什么格式
    NSDate *datenow = [NSDate date];
    //----------将nsdate按formatter格式转成nsstring
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    //    NSLog(@"currentTimeString = %@",currentTimeString);
    return currentTimeString;
}

@end
