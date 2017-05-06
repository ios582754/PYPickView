//
//  PYPickViewDefines.h
//  PYUSerelectPickVC
//
//  Created by apple on 17/5/6.
//  Copyright © 2017年 pxymac. All rights reserved.
//

#ifndef PYPickViewDefines_h
#define PYPickViewDefines_h

#import "UIView+PyExtension.h"
//SCREEN
#define PY_SCREEN_HIGH [UIScreen mainScreen].bounds.size.height

#define PY_SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define KeyWindow [UIApplication sharedApplication].keyWindow
#define iPhone4s ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

#define KeyWindow [UIApplication sharedApplication].keyWindow
#define RGBA(r,g,b,a)    [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#define margin 10
#define leadingMargin ((iPhone4s || iPhone5) ? 20 : (iPhone6 ? 30 : 40))
#define contentViewW (KeyWindow.bounds.size.width - 2 * leadingMargin)
#define contentViewH 280

#define PickerGreen [UIColor colorWithRed:69/255.0 green:181/255.0 blue:55/255.0 alpha:0.8]
#define PickerYellow [UIColor colorWithRed:255/255.0 green:140/255.0 blue:37/255.0 alpha:1]
#define lineColor [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0]

#endif /* PYPickViewDefines_h */
