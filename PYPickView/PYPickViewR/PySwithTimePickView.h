//
//  PySwithTimePickView.h
//  PYUSerelectPickVC
//
//  Created by apple on 17/5/6.
//  Copyright © 2017年 pxymac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, BtnType) {
    BtnTypeCancel,
    BtnTypeSure
};

@interface PySwithTimePickView : UIView
+ (void)showWithStartHour:(NSString *)startHour
startMinu:(NSString *)startMinu
endHour:(NSString *)endHour
endMinu:(NSString *)endMinu
clickBtnCallback:(void(^)(BtnType btnType, NSString *startHour, NSString *startMinu, NSString *endHour, NSString *endMinu))clickBtnCallback;

@end
