//
//  PyBirthdayPickerView.h
//  PYUSerelectPickVC
//
//  Created by apple on 17/5/6.
//  Copyright © 2017年 pxymac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BirthdayCallbackBlock)(NSString *resultBirthday);
@interface PyBirthdayPickerView : UIView
+ (void)showWithOriginalBrithday:(NSString *)originalBrithday
          changeBrithdayCallback:(BirthdayCallbackBlock)changeBrithdayCallback;

@end
