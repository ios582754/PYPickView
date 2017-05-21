//
//  PyGenderPickerView.h
//  PYUSerelectPickVC
//
//  Created by apple on 17/5/6.
//  Copyright © 2017年 pxymac. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, PySexType) {
    PySexTypeMan = 0,
    PySexTypeWomen,
    PySexTypeOther
};
typedef void(^BirCallbackBlock)(PySexType sexType);
@interface PyGenderPickerView : UIView
+(void) showWithSexType:(PySexType) sexType resultSexCallBack:(BirCallbackBlock)resultCallback;

@end
