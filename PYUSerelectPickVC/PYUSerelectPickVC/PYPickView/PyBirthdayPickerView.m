//
//  PyBirthdayPickerView.m
//  PYUSerelectPickVC
//
//  Created by apple on 17/5/6.
//  Copyright © 2017年 pxymac. All rights reserved.
//

#import "PyBirthdayPickerView.h"
#import "PYPickViewDefines.h"
#define KeyWindow [UIApplication sharedApplication].keyWindow
@interface PyBirthdayPickerView ()
@property (nonatomic, strong) UIButton *balckView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, copy) UILabel *TitleLabel;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *completeBtn;
@property (nonatomic, strong) UIDatePicker *brithdayPicker;
@property (nonatomic, copy) BirthdayCallbackBlock changeBrithdayCallback;
@end

@implementation PyBirthdayPickerView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self initConfig];
    }
    return self;
}

- (void)initConfig {
    [self addSubview:self.balckView];
    [self addSubview:self.bottomView];
}

+ (void)showWithOriginalBrithday:(NSString *)originalBrithday
          changeBrithdayCallback:(BirthdayCallbackBlock)changeBrithdayCallback {
    PyBirthdayPickerView *pickerView = [[self alloc] init];
    pickerView.changeBrithdayCallback = [changeBrithdayCallback copy];
    if (originalBrithday != nil) {
        pickerView.brithdayPicker.date = [self dateFromString:originalBrithday withFormat:@"yyyy-MM-dd"];
    }
    [KeyWindow addSubview:pickerView];
    pickerView.frame = KeyWindow.bounds;
    [pickerView show];
}

- (void)cancelAction:(UIButton *)btn {
    [self dismissWithchangedBrithday:nil];
}

- (void)completeAction:(UIButton *)btn {
    NSDateFormatter *dateFmt = [[NSDateFormatter alloc] init];
    dateFmt.dateFormat = @"yyyy-MM-dd";
    NSString *brithday = [dateFmt stringFromDate:self.brithdayPicker.date];
    [self dismissWithchangedBrithday:brithday];
}

- (void)show {
    [UIView animateWithDuration:.35
                          delay:.2
                        options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         self.balckView.alpha = 0.75;
                         self.bottomView.transform = CGAffineTransformMakeTranslation(0, -250);
                     } completion:nil];
}

- (void)dismissWithchangedBrithday:(NSString *)changedBrithday{
    [UIView animateWithDuration:.3
                          delay:0
                        options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         self.balckView.alpha = 0.0;
                         self.bottomView.transform = CGAffineTransformIdentity;
                     } completion:^(BOOL finished) {
                         [self removeFromSuperview];
                         if (changedBrithday) {
                             !self.changeBrithdayCallback ? : self.changeBrithdayCallback(changedBrithday);
                         }
                     }];
}

+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    NSDate *date = [formatter dateFromString:string];
    return date;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 250)];
        _bottomView.backgroundColor = [UIColor colorWithRed:234/255.0 green:241/255.0 blue:243/255.0 alpha:1];
        [_bottomView addSubview:self.brithdayPicker];
        [_bottomView addSubview:self.cancelBtn];
        [_bottomView addSubview:self.TitleLabel];
        [_bottomView addSubview:self.completeBtn];
    }
    return _bottomView;
}

- (UIDatePicker *)brithdayPicker {
    if (!_brithdayPicker) {
        _brithdayPicker = [[UIDatePicker alloc] init];
        _brithdayPicker.datePickerMode = UIDatePickerModeDate;
        _brithdayPicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
        _brithdayPicker.frame = CGRectMake(5, 45,_bottomView.bounds.size.width - 10,  _bottomView.bounds.size.height - 45);
        _brithdayPicker.layer.mask = [self shapeLayerWithFrame:_brithdayPicker.bounds radioSize:CGSizeMake(5, 5)];
        _brithdayPicker.backgroundColor = [UIColor whiteColor];
    }
    return _brithdayPicker;
}

- (CAShapeLayer *)shapeLayerWithFrame:(CGRect)frame radioSize:(CGSize)radioSize {
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:frame
                                               byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight
                                                     cornerRadii:radioSize];
    CAShapeLayer *masklayer = [[CAShapeLayer alloc]init];
    masklayer.frame = frame;
    masklayer.path = path.CGPath;
    return masklayer;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        _cancelBtn.frame = CGRectMake(0, 0, 80, 45);
        [_cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (UIButton *)completeBtn {
    if (!_completeBtn) {
        _completeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_completeBtn setTitle:@"完成" forState:UIControlStateNormal];
        _completeBtn.titleLabel.textColor = [UIColor blueColor];
        [_completeBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        _completeBtn.frame = CGRectMake(_bottomView.frame.size.width - 80 , 0, 80, 45);
        [_completeBtn addTarget:self action:@selector(completeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _completeBtn;
}

- (UILabel *)TitleLabel {
    if (!_TitleLabel) {
        _TitleLabel = [[UILabel alloc] init];
        _TitleLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
        _TitleLabel.text = @"选择日期";
        _TitleLabel.textAlignment = NSTextAlignmentCenter;
        _TitleLabel.frame = CGRectMake((_bottomView.frame.size.width - 100) * 0.5, 0, 100, 45);
    }
    return _TitleLabel;
}

- (UIView *)balckView {
    if (!_balckView) {
        _balckView = [[UIButton alloc] initWithFrame:KeyWindow.bounds];
        _balckView.backgroundColor = [UIColor blackColor];
        _balckView.alpha = 0;
        [_balckView addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _balckView;
}
@end
