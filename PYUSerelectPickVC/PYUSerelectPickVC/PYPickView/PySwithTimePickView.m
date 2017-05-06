
//
//  PySwithTimePickView.m
//  PYUSerelectPickVC
//
//  Created by apple on 17/5/6.
//  Copyright © 2017年 pxymac. All rights reserved.
//

#import "PySwithTimePickView.h"
#import "PYPickViewDefines.h"

@interface PySwithTimePickView () <UIPickerViewDataSource, UIPickerViewDelegate>
@property (nonatomic, strong) UIView *balckView;
@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UILabel *titleView;

@property (nonatomic, strong) UIView *contentCenterView;
@property (nonatomic, strong) UIPickerView *leftPickerView;
@property (nonatomic, strong) UIView *centerLine;
@property (nonatomic, strong) UIPickerView *rightPickerView;

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *sureBtn;

@property (nonatomic, strong) NSArray <NSString *> *hours;
@property (nonatomic, strong) NSMutableArray <NSString *> *minus;

@property (nonatomic, copy) NSString *startHour;
@property (nonatomic, copy) NSString *endHour;
@property (nonatomic, copy) NSString *startMinu;
@property (nonatomic, copy) NSString *endMinu;
@property (nonatomic, assign) NSInteger startHourIndex;
@property (nonatomic, assign) NSInteger endHourIndex;
@property (nonatomic, assign) NSInteger startMinuIndex;
@property (nonatomic, assign) NSInteger endMinuIndex;

@property (nonatomic, copy) void(^clickBtnCallback)(BtnType btnType, NSString *startHour, NSString *startMinu, NSString *endHour, NSString *endMinu);

@end

@implementation PySwithTimePickView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initConfig];
    }
    return  self;
}

- (void)initConfig {
    [self addSubview:self.balckView];
    [self addSubview:self.contentView];
}

+ (void)showWithStartHour:(NSString *)startHour
                startMinu:(NSString *)startMinu
                  endHour:(NSString *)endHour
                  endMinu:(NSString *)endMinu
         clickBtnCallback:(void(^)(BtnType btnType, NSString *startHour, NSString *startMinu, NSString *endHour, NSString *endMinu))clickBtnCallback {
    PySwithTimePickView *pickerView = [[self alloc] init];
    [KeyWindow addSubview:pickerView];
    pickerView.frame = KeyWindow.bounds;
    
    if ([pickerView isPureInt:startHour] && startHour.length < 3 && [startHour integerValue] >=0 && [startHour integerValue] < 24) {
        NSString *newStartHour = startHour;
        if (startHour.length < 2) {
            newStartHour = [NSString stringWithFormat:@"0%@", startHour];
        }
        pickerView.startHourIndex = [pickerView.hours indexOfObject:newStartHour];
        pickerView.startHour = newStartHour;
    } else {
        pickerView.startHourIndex = 0;
        pickerView.startHour = @"00";
    }
    if ([pickerView isPureInt:startMinu] && startMinu.length < 3 && [startMinu integerValue] >=0 && [startMinu integerValue] < 60) {
        NSString *newStartMinu = startMinu;
        if (startMinu.length < 2) {
            newStartMinu = [NSString stringWithFormat:@"0%@", startMinu];
        }
        pickerView.startMinuIndex = [pickerView.minus indexOfObject:newStartMinu];
        pickerView.startMinu = newStartMinu;
    } else {
        pickerView.startMinuIndex = 0;
        pickerView.startMinu = @"00";
    }
    if ([pickerView isPureInt:endHour] && endHour.length < 3 && [endHour integerValue] >=0 && [endHour integerValue] < 24) {
        NSString *newEndtHour = endHour;
        if (endHour.length < 2) {
            newEndtHour = [NSString stringWithFormat:@"0%@", endHour];
        }
        pickerView.endHourIndex = [pickerView.hours indexOfObject:newEndtHour];
        pickerView.endHour = newEndtHour;
    } else {
        pickerView.endHourIndex = 0;
        pickerView.endHour = @"00";
    }
    if ([pickerView isPureInt:endMinu] && endMinu.length < 3 && [endMinu integerValue] >=0 && [endMinu integerValue] < 60) {
        NSString *newEndMinu = endMinu;
        if (endMinu.length < 2) {
            newEndMinu = [NSString stringWithFormat:@"0%@", endMinu];
        }
        pickerView.endMinuIndex = [pickerView.minus indexOfObject:newEndMinu];
        pickerView.endMinu = newEndMinu;
    } else {
        pickerView.endMinuIndex = 0;
        pickerView.endMinu = @"00";
    }
    [pickerView.leftPickerView selectRow:pickerView.startHourIndex inComponent:0 animated:NO];
    [pickerView.leftPickerView selectRow:pickerView.startMinuIndex inComponent:1 animated:NO];
    [pickerView.rightPickerView selectRow:pickerView.endHourIndex inComponent:0 animated:NO];
    [pickerView.rightPickerView selectRow:pickerView.endMinuIndex inComponent:1 animated:NO];
    [pickerView.rightPickerView reloadComponent:0];
    [pickerView.rightPickerView reloadComponent:1];
    [pickerView.leftPickerView reloadComponent:0];
    [pickerView.leftPickerView reloadComponent:1];
    
    pickerView.clickBtnCallback = [clickBtnCallback copy];
    
    pickerView.contentView.transform = CGAffineTransformMakeScale(0, 0);
    pickerView.contentView.alpha = 0.0;
    [pickerView show];
    
}

- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd] && ([string rangeOfString:@" "].location == NSNotFound) ;
}

- (void)cancelBtnAction:(UIButton *)btn {
    [self dismissWithCompletionHandler:^{
        !self.clickBtnCallback ? : self.clickBtnCallback(BtnTypeCancel, self.startHour , self.startMinu, self.endHour, self.endMinu);
    }];
}

- (void)sureBtnAction:(UIButton *)btn {
    [self dismissWithCompletionHandler:^{
        !self.clickBtnCallback ? : self.clickBtnCallback(BtnTypeSure,  self.startHour , self.startMinu, self.endHour, self.endMinu);
    }];
}

- (void)show {
    [UIView animateWithDuration:0.25
                          delay:0
         usingSpringWithDamping:0.8
          initialSpringVelocity:10
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.contentView.transform =  CGAffineTransformIdentity;
                         self.contentView.alpha = 1.0;
                         self.balckView.alpha = 0.75;
                     } completion:nil];
}

- (void)dismissWithCompletionHandler:(void(^)())completionHandler {
    [UIView animateWithDuration:0.25
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.contentView.alpha = 0.0;
                         self.balckView.alpha = 0.0;
                     } completion:^(BOOL finished) {
                         [self removeFromSuperview];
                         !completionHandler ? : completionHandler();
                     }];
}

#pragma mark - UIPickerViewDataSource, UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return component ? self.minus.count : self.hours.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return component ? self.minus[row] : self.hours[row];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 45;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (pickerView == self.leftPickerView) {
        if (component) {
            self.startMinuIndex = row;
            self.startMinu = self.minus[row];
            [self.leftPickerView reloadComponent:1];
        } else {
            self.startHourIndex = row;
            self.startHour = self.hours[row];
            [self.leftPickerView reloadComponent:0];
        }
    } else {
        if (component) {
            self.endMinuIndex = row;
            self.endMinu = self.minus[row];
            [self.rightPickerView reloadComponent:1];
        } else {
            self.endHourIndex = row;
            self.endHour = self.hours[row];
            [self.rightPickerView reloadComponent:0];
        }
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.minimumScaleFactor = 8;
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        pickerLabel.layer.borderWidth= .5;
        pickerLabel.layer.borderColor=lineColor.CGColor;
        pickerLabel.backgroundColor = [UIColor clearColor];
        [pickerLabel setFont:[UIFont systemFontOfSize:18]];
        
        if (pickerView == self.leftPickerView) {
            if (component == 0 && row == self.startHourIndex) {
                pickerLabel.textColor = PickerGreen;
            } else if (component == 1 && row == self.startMinuIndex) {
                pickerLabel.textColor = PickerGreen;
            }
        }else if (pickerView == self.rightPickerView){
            if (component == 0 && row == self.endHourIndex) {
                pickerLabel.textColor = PickerYellow;
            } else if (component == 1 && row == self.endMinuIndex) {
                pickerLabel.textColor = PickerYellow;
            }
        }
    }
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

#pragma mark - getters and setters
- (UIView *)balckView {
    if (!_balckView) {
        _balckView = [[UIView alloc] initWithFrame:KeyWindow.bounds];
        _balckView.backgroundColor = [UIColor blackColor];
        _balckView.alpha = 0;
    }
    return _balckView;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.frame = CGRectMake(leadingMargin, (KeyWindow.frame.size.height - contentViewH) * 0.5, contentViewW, contentViewH);
        _contentView.layer.cornerRadius = 5.0;
        _contentView.layer.masksToBounds = YES;
        [_contentView addSubview:self.titleView];
        [_contentView addSubview:self.contentCenterView];
        [_contentView addSubview:self.bottomView];
    }
    return _contentView;
}

- (UILabel *)titleView {
    if (!_titleView) {
        _titleView = [[UILabel alloc] init];
        _titleView.frame = CGRectMake(0, 0, _contentView.frame.size.width, 50);
        _titleView.textAlignment = NSTextAlignmentCenter;
        _titleView.text = @"修改时间";
        _titleView.font = [UIFont systemFontOfSize:19];
        _titleView.textColor = [UIColor whiteColor];
        _titleView.backgroundColor = PickerYellow;
    }
    return _titleView;
}

- (UIView *)contentCenterView {
    if (!_contentCenterView) {
        _contentCenterView = [[UIView alloc] init];
        _contentCenterView.frame = CGRectMake(0, CGRectGetMaxY(_titleView.frame), _contentView.frame.size.width, 180);
        
        UILabel *startL = [[UILabel alloc] init];
        startL.frame = CGRectMake(0, 0, _contentCenterView.width * 0.5, 40);
        startL.textAlignment = NSTextAlignmentCenter;
        startL.text = @"开始时间";
        startL.font = [UIFont systemFontOfSize:15];
        startL.textColor = RGBA(51, 51, 51, 1);
        [_contentCenterView addSubview:startL];
        
        UILabel *endL = [[UILabel alloc] init];
        endL.frame = CGRectMake(_contentCenterView.width * 0.5, 0, _contentCenterView.width * 0.5, startL.frame.size.height);
        endL.textAlignment = NSTextAlignmentCenter;
        endL.text = @"结束时间";
        endL.font = [UIFont systemFontOfSize:15];
        endL.textColor = RGBA(51, 51, 51, 1);
        [_contentCenterView addSubview:endL];
        
        [_contentCenterView addSubview:self.centerLine];
        [_contentCenterView addSubview:self.leftPickerView];
        [_contentCenterView addSubview:self.rightPickerView];
        
        _centerLine.centerY = self.leftPickerView.centerY;
        
        UILabel *leftDot=[[UILabel alloc] init];
        leftDot.text=@":";
        leftDot.textColor= PickerGreen;
        leftDot.font=[UIFont systemFontOfSize:18];
        [_contentCenterView addSubview:leftDot];
        [leftDot sizeToFit];
        leftDot.center = _leftPickerView.center;
        
        UILabel *rightDot=[[UILabel alloc] init];
        rightDot.text=@":";
        rightDot.textColor= PickerYellow;
        rightDot.font=[UIFont systemFontOfSize:18];
        [_contentCenterView addSubview:rightDot];
        [rightDot sizeToFit];
        rightDot.center = _rightPickerView.center;
        
    }
    return _contentCenterView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor whiteColor];
        _bottomView.frame = CGRectMake(0, CGRectGetMaxY(_contentCenterView.frame), _contentView.frame.size.width, 50);
        [_bottomView addSubview:self.cancelBtn];
        [_bottomView addSubview:self.sureBtn];
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = lineColor;
        line.frame = CGRectMake(0, 0, _bottomView.frame.size.width, 1);
        [_bottomView addSubview:line];
        
        UIView *line2 = [[UIView alloc] init];
        line2.frame = CGRectMake((_bottomView.frame.size.width - 1) * 0.5, 0, 1, _bottomView.frame.size.height);
        line2.backgroundColor = line.backgroundColor;
        [_bottomView addSubview:line2];
    }
    return _bottomView;
}

- (UIPickerView *)leftPickerView {
    if (!_leftPickerView) {
        _leftPickerView = [[UIPickerView alloc] init];
        _leftPickerView.dataSource = self;
        _leftPickerView.delegate = self;
        _leftPickerView.frame = CGRectMake(margin, 40, (_contentCenterView.bounds.size.width - 4 *margin - _centerLine.frame.size.width) * 0.5,  _contentCenterView.bounds.size.height -  margin - 40);
        _leftPickerView.layer.cornerRadius = 5.0;
        _leftPickerView.layer.masksToBounds = YES;
        _leftPickerView.backgroundColor = [UIColor colorWithRed:243/255.0 green:246/255.0 blue:245/255.0 alpha:1];
    }
    return _leftPickerView;
}

- (UIPickerView *)rightPickerView {
    if (!_rightPickerView) {
        _rightPickerView = [[UIPickerView alloc] init];
        _rightPickerView.dataSource = self;
        _rightPickerView.delegate = self;
        _rightPickerView.frame = CGRectMake(_contentCenterView.frame.size.width - margin - _leftPickerView.frame.size.width, _leftPickerView.frame.origin.y ,_leftPickerView.frame.size.width,  _leftPickerView.frame.size.height);
        _rightPickerView.layer.cornerRadius = 5.0;
        _rightPickerView.layer.masksToBounds = YES;
        _rightPickerView.backgroundColor = _leftPickerView.backgroundColor;
    }
    return _rightPickerView;
}

- (UIView *)centerLine {
    if (!_centerLine) {
        _centerLine = [[UIView alloc] init];
        _centerLine.backgroundColor = [UIColor grayColor];
        _centerLine.size = CGSizeMake(20, 1);
        _centerLine.centerX = _contentCenterView.width * 0.5;
        _centerLine.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
    }
    return _centerLine;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitle:@"取  消" forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancelBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _cancelBtn.frame = CGRectMake(0, 0, (_bottomView.frame.size.width) * 0.5 , _bottomView.frame.size.height);
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [_cancelBtn setTitleColor:PickerGreen forState:UIControlStateNormal];
    }
    return _cancelBtn;
}

- (UIButton *)sureBtn {
    if (!_sureBtn) {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sureBtn setTitle:@"确  认" forState:UIControlStateNormal];
        [_sureBtn addTarget:self action:@selector(sureBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _sureBtn.frame = CGRectMake( _cancelBtn.frame.size.width, 0, _cancelBtn.frame.size.width , _cancelBtn.frame.size.height);
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [_sureBtn setTitleColor:PickerYellow forState:UIControlStateNormal];
    }
    return _sureBtn;
}

- (NSArray<NSString *> *)hours {
    if (!_hours) {
        _hours = @[@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23"];
    }
    return _hours;
}

- (NSMutableArray<NSString *> *)minus {
    if (!_minus) {
        _minus = [NSMutableArray array];
        for (NSInteger i = 0; i < 60; i++) {
            NSString *minuStr = [NSString stringWithFormat:@"%zd", i];
            if (i < 10) {
                minuStr = [NSString stringWithFormat:@"0%zd", i];
            }
            [_minus addObject:minuStr];
        }
    }
    return _minus;
}

@end
