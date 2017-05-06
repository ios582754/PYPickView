//
//  PyAddressPickView.m
//  PYUSerelectPickVC
//
//  Created by apple on 17/5/6.
//  Copyright © 2017年 pxymac. All rights reserved.
//

#import "PyAddressPickView.h"
#import "PYPickViewDefines.h"
@interface AddressAreaItem :NSObject
@property (nonatomic, copy) NSString *area;
@end
@implementation AddressAreaItem
@end

@interface AddressCityItem :NSObject
@property (nonatomic, copy) NSString *city;
@property (nonatomic, strong) NSMutableArray<AddressAreaItem *> *AreaArray;
@end
@implementation AddressCityItem
- (NSMutableArray<AddressAreaItem *> *)AreaArray {
    if (!_AreaArray) {
        _AreaArray = [NSMutableArray array];
    }
    return _AreaArray;
}
@end

@interface AdddressProvinceItem :NSObject
@property (nonatomic, copy) NSString *province;
@property (nonatomic, strong) NSMutableArray<AddressCityItem *> *cityArray;
@end
@implementation AdddressProvinceItem
- (NSMutableArray<AddressCityItem *> *)cityArray {
    if (!_cityArray) {
        _cityArray = [NSMutableArray array];
    }
    return _cityArray;
}
@end

@interface PyAddressPickView () <UIPickerViewDataSource, UIPickerViewDelegate>
@property (nonatomic, strong) UIButton *balckView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, copy) UILabel *TitleLabel;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *completeBtn;
@property (nonatomic, strong) UIPickerView *addressPickerView;

@property (nonatomic, copy) void(^completeCallback)(NSString *aprovince, NSString *city, NSString *area);

@property (nonatomic, strong) NSArray *addressArr;
@property (strong, nonatomic) NSMutableArray *provinceArr;
@property (strong, nonatomic) NSMutableArray *cityArr;
@property (strong, nonatomic) NSMutableArray *areaArr;
@property (nonatomic, assign) NSInteger selProvinceIndex;
@property (nonatomic, assign) NSInteger selCityIndex;
@property (nonatomic, assign) NSInteger selAreaIndext;
@property (nonatomic, copy) NSString *addressStr;
@end

@implementation PyAddressPickView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self initConfig];
    }
    return self;
}

- (void)initConfig {
    [self handleAddressData];
    [self addSubview:self.balckView];
    [self addSubview:self.bottomView];
}

+ (void)showWithCompleteCallbak:(void (^)(NSString *, NSString *, NSString *))completeCallback {
    PyAddressPickView *pickerView = [[self alloc] init];
    pickerView.completeCallback = [completeCallback copy];
    [KeyWindow addSubview:pickerView];
    pickerView.frame = KeyWindow.bounds;
    pickerView.selAreaIndext = 0;
    pickerView.selProvinceIndex = 0;
    pickerView.selCityIndex = 0;
    [pickerView show];
}

- (void)handleAddressData {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (NSDictionary *Dict  in self.addressArr) {
            AdddressProvinceItem *provinceItem = [[AdddressProvinceItem alloc] init];
            [self.provinceArr addObject:provinceItem];
            for (NSString *key in Dict) {
                provinceItem.province = key;
                if ([Dict[key] isKindOfClass:[NSArray class]]) {
                    for (id DictCity in Dict[key]) {
                        AddressCityItem *cityItem = [[AddressCityItem alloc] init];
                        [provinceItem.cityArray addObject:cityItem];
                        if ([DictCity isKindOfClass:[NSString class]]) {
                            cityItem.city = DictCity;
                        } else {
                            for (NSString *cityKey in (NSDictionary *)DictCity) {
                                cityItem.city = cityKey;
                                for (NSString *area in DictCity[cityKey]) {
                                    AddressAreaItem *areaItem = [[AddressAreaItem alloc] init];
                                    [cityItem.AreaArray addObject:areaItem];
                                    areaItem.area = area;
                                }
                            }
                        }
                    }
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.addressPickerView reloadAllComponents];
        });
    });
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

- (void)dismissIsCancel:(BOOL)isCancel{
    [UIView animateWithDuration:.3
                          delay:0
                        options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         self.balckView.alpha = 0.0;
                         self.bottomView.transform = CGAffineTransformIdentity;
                     } completion:^(BOOL finished) {
                         [self removeFromSuperview];
                         if (!isCancel) {
                             NSString *city = nil;
                             NSString *area = nil;
                             if (self.cityArr.count) {
                                 city = ((AddressCityItem *)self.cityArr[self.selCityIndex]).city;
                             }
                             if (self.areaArr.count) {
                                 area = ((AddressAreaItem *)self.areaArr[self.selAreaIndext]).area;
                             }
                             !self.completeCallback ? : self.completeCallback(((AdddressProvinceItem *)self.provinceArr[self.selProvinceIndex]).province, city, area);
                         }
                     }];
}

- (void)completeAction:(UIButton *)btn {
    [self dismissIsCancel:NO];
}

- (void)cancelAction:(UIButton *)btn {
    [self dismissIsCancel:YES];
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return self.provinceArr.count;
    } else if (component == 1){
        self.selProvinceIndex = [pickerView selectedRowInComponent:0];
        if (self.provinceArr.count) {
            AdddressProvinceItem *ProvinceItem = self.provinceArr[self.selProvinceIndex];
            self.cityArr = ProvinceItem.cityArray;
            return self.cityArr.count;
        } else {
            return 0;
        }
    } else {
        if (self.cityArr.count) {
            self.selCityIndex = [pickerView selectedRowInComponent:1];
            AddressCityItem *cityItem = self.cityArr[self.selCityIndex];
            self.areaArr = cityItem.AreaArray;
            return self.areaArr.count;
        } else {
            return 0;
        }
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component==0) {
        return ((AdddressProvinceItem *)self.provinceArr[row]).province;
    }else if(component==1){
        return ((AddressCityItem *)((AdddressProvinceItem *)self.provinceArr[self.selProvinceIndex]).cityArray[row]).city;
    }else{
        return ((AddressAreaItem *)((AddressCityItem *)self.cityArr[self.selCityIndex]).AreaArray[row]).area;
    }
}

#pragma mark - UIPickerViewDelegate
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.minimumScaleFactor = 8.0;
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:17]];
    }
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component==0) {
        self.selProvinceIndex = row;
        [pickerView reloadComponent:1];
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:1 animated:YES];
        [pickerView selectRow:0 inComponent:2 animated:YES];
        
    }else if(component==1){
        self.selCityIndex = row;
        [pickerView selectRow:0 inComponent:2 animated:YES];
        [pickerView reloadComponent:2];
    }
    self.selAreaIndext = [pickerView selectedRowInComponent:2];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 45;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 250)];
        _bottomView.backgroundColor = [UIColor colorWithRed:234/255.0 green:241/255.0 blue:243/255.0 alpha:1];
        [_bottomView addSubview:self.addressPickerView];
        [_bottomView addSubview:self.cancelBtn];
        [_bottomView addSubview:self.TitleLabel];
        [_bottomView addSubview:self.completeBtn];
    }
    return _bottomView;
}

- (UIPickerView *)addressPickerView {
    if (!_addressPickerView) {
        _addressPickerView = [[UIPickerView alloc] init];
        _addressPickerView.dataSource = self;
        _addressPickerView.delegate = self;
        _addressPickerView.frame = CGRectMake(5, 45,_bottomView.bounds.size.width - 10,  _bottomView.bounds.size.height - 45);
        _addressPickerView.layer.mask = [self shapeLayerWithFrame:_addressPickerView.bounds radioSize:CGSizeMake(5, 5)];
        _addressPickerView.backgroundColor = [UIColor whiteColor];
    }
    return _addressPickerView;
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
        _TitleLabel.text = @"选择地址";
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

- (NSArray *)addressArr {
    if (!_addressArr) {
        _addressArr = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"address" ofType:@"plist"]];
    }
    return _addressArr;
}

- (NSMutableArray *)provinceArr {
    if (!_provinceArr) {
        _provinceArr = [NSMutableArray array];
    }
    return _provinceArr;
}

- (NSMutableArray *)cityArr {
    if (!_cityArr) {
        _cityArr = [NSMutableArray array];
    }
    return _cityArr;
}
@end

