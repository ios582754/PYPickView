
//
//  PyGenderPickerView.m
//  PYUSerelectPickVC
//
//  Created by apple on 17/5/6.
//  Copyright © 2017年 pxymac. All rights reserved.
//


#import "PyGenderPickerView.h"
#import "PYPickViewDefines.h"
#define KeyWindow [UIApplication sharedApplication].keyWindow
@interface PyGenderPickerView ()<UIPickerViewDataSource, UIPickerViewDelegate>
@property (nonatomic, strong) UIButton *backView; ///
@property (nonatomic, strong) UIView *bottomView; ///
@property (nonatomic,strong) UILabel *titleLable; ///
@property (nonatomic, strong) UIButton *cancelBtn; ///
@property (nonatomic, strong) UIButton *completeBtn; ///
@property (nonatomic, strong) UIPickerView *sexPickView; ///
@property (nonatomic, strong) NSMutableArray *sexArr; ///
@property (nonatomic, copy) BirCallbackBlock changeSexCallback; ///

@property (nonatomic, assign) PySexType selectSexType;

@end

@implementation PyGenderPickerView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self== [super initWithFrame:frame]) {
        
        //创建View
        [self configureUI];
        
    }
    return self;
}

- (void)configureUI {
    [self addSubview:self.backView];
    [self addSubview:self.bottomView];
    
}
+(void) showWithSexType:(PySexType)sexType resultSexCallBack:(BirCallbackBlock)resultCallback {
    PyGenderPickerView *pickerView = [[self alloc] init];
    pickerView.changeSexCallback = resultCallback;
    pickerView.selectSexType = sexType;
    switch (sexType) {
        case PySexTypeMan:
        {
            [pickerView.sexPickView selectRow:0 inComponent:0 animated:NO];
        }break;
        case PySexTypeWomen:
        {
            [pickerView.sexPickView selectRow:1 inComponent:0 animated:NO];
        }break;
        case PySexTypeOther:
        {
            [pickerView.sexPickView selectRow:2 inComponent:0 animated:NO];
        }break;
            
        default:
            break;
    }
    [KeyWindow addSubview:pickerView];
    pickerView.frame = KeyWindow.bounds;
    [pickerView showView];
    
    
}
- (void)showView {
    [UIView animateWithDuration:.30 delay:
     .1 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         self.backView.alpha = 0.75;
                         self.bottomView.transform = CGAffineTransformMakeTranslation(0, -200);
                     } completion:^(BOOL finished) {
                         
                         
                     }];
}
- (void)dismissWithchangedSexType:(PySexType)sexType isCancel:(BOOL)isCancel{
    [UIView animateWithDuration:.3
                          delay:0
                        options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         self.backView.alpha = 0.0;
                         self.bottomView.transform = CGAffineTransformIdentity;
                     } completion:^(BOOL finished) {
                         [self removeFromSuperview];
                         if (!isCancel) {
                             !self.changeSexCallback ? : self.changeSexCallback(sexType);
                         }
                     }];
}
- (void)completeAction:(UIButton *)btn {
    [self dismissWithchangedSexType:self.selectSexType isCancel:NO];
}

- (void)cancelAction:(UIButton *)btn {
    [self dismissWithchangedSexType:PySexTypeMan isCancel:YES];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.sexArr.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return self.sexArr[row];
}

- (CGFloat) pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    
    return 45;
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSString *selectStr = self.sexArr[row];
    switch (row) {
        case 0:
        {
            self.selectSexType = PySexTypeMan;
        }
            break;
        case 1:
        {
            self.selectSexType = PySexTypeWomen;
        }
            break;
        case 2:
        {
            self.selectSexType = PySexTypeOther;
        }
            break;
            
        default:
            break;
    }
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 200)];
        _bottomView.backgroundColor = [UIColor colorWithRed:234/255.0 green:241/255.0 blue:243/255.0 alpha:1];
        [_bottomView addSubview:self.sexPickView];
        [_bottomView addSubview:self.cancelBtn];
        [_bottomView addSubview:self.titleLable];
        [_bottomView addSubview:self.completeBtn];
    }
    return _bottomView;
}

- (UIPickerView *)sexPickView {
    if (!_sexPickView) {
        UIPickerView *  _sexPickerView = [[UIPickerView alloc] init];
        _sexPickerView.dataSource = self;
        _sexPickerView.delegate = self;
        _sexPickerView.frame = CGRectMake(5, 45,_bottomView.bounds.size.width - 10,  _bottomView.bounds.size.height - 45);
        _sexPickerView.layer.mask = [self shapeLayerWithFrame:_sexPickerView.bounds radioSize:CGSizeMake(5, 5)];
        _sexPickerView.backgroundColor = [UIColor whiteColor];
        self.sexPickView = _sexPickerView;
    }
    return _sexPickView;
}
//锐化边角
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

- (UILabel *)titleLable {
    if (!_titleLable) {
        self.titleLable = [[UILabel alloc] init];
        _titleLable.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
        _titleLable.text = @"选择性别";
        _titleLable.textAlignment = NSTextAlignmentCenter;
        _titleLable.frame = CGRectMake((_bottomView.frame.size.width - 100) * 0.5, 0, 100, 45);
    }
    return _titleLable;
}

- (UIView *)backView {
    if (!_backView) {
        UIButton * _balckView = [[UIButton alloc] initWithFrame:KeyWindow.bounds];
        _balckView.backgroundColor = [UIColor blackColor];
        _balckView.alpha = 0;
        [_balckView addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
        self.backView = _balckView;
    }
    return _backView;
}

- (NSMutableArray *)sexArr {
    if (!_sexArr) {
        _sexArr = @[@"男性", @"女性", @"保密"].mutableCopy;;
    }
    return _sexArr;
}
@end
