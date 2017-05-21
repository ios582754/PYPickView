//
//  ViewController.m
//  PYUSerelectPickVC
//
//  Created by apple on 17/5/6.
//  Copyright © 2017年 pxymac. All rights reserved.
//

#import "ViewController.h"
#import "PyGenderPickerView.h"
#import "PyBirthdayPickerView.h"
#import "PyAddressPickView.h"
#import "PySwithTimePickView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)sexPickAction:(id)sender {
    [PyGenderPickerView showWithSexType:PySexTypeMan resultSexCallBack:^(PySexType sexType) {
        NSString *sex = nil;
        switch (sexType) {
            case PySexTypeMan:
            {
                sex = @"男";
            } break;
            case PySexTypeWomen:
            {
                sex = @"女";
            } break;
                
            case PySexTypeOther:
            {
                sex = @"保密";
            } break;
            default:
                break;
        }
        [sender setTitle:sex forState:UIControlStateNormal];
    }];
}

- (IBAction)brithdayAction:(UIButton *)sender {
    [PyBirthdayPickerView showWithOriginalBrithday:@"2017-03-25"
                            changeBrithdayCallback:^(NSString *changedBrithday) {
                                [sender setTitle:changedBrithday forState:UIControlStateNormal];
                                
                            }];
}

- (IBAction)addressAction:(UIButton *)sender {
    [PyAddressPickView showWithCompleteCallbak:^(NSString *aprovince, NSString *city, NSString *area) {
        [sender setTitle:[NSString stringWithFormat:@"%@-%@-%@",aprovince, city, area] forState:UIControlStateNormal];
    }];
}

- (IBAction)timeSetAction:(id)sender {
    [PySwithTimePickView showWithStartHour:@"5"
                                 startMinu:@"18"
                                   endHour:@"08"
                                   endMinu:@"56"
                          clickBtnCallback:^(BtnType btnType, NSString *startHour, NSString *startMinu, NSString *endHour, NSString *endMinu) {
                              [sender setTitle:[NSString stringWithFormat:@"%@:%@ - %@:%@",startHour, startMinu, endHour, endMinu] forState:UIControlStateNormal];
                          }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
