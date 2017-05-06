//
//  PyAddressPickView.h
//  PYUSerelectPickVC
//
//  Created by apple on 17/5/6.
//  Copyright © 2017年 pxymac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PyAddressPickView : UIView
+ (void)showWithCompleteCallbak:(void(^)(NSString *aprovince, NSString *city, NSString *area))completeCallback;
@end
