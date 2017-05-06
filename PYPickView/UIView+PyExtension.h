//
//  UIView+PyExtension.h
//  PYUSerelectPickVC
//
//  Created by apple on 17/5/6.
//  Copyright © 2017年 pxymac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (PyExtension)
/** centerX */
@property (nonatomic, assign) CGFloat centerX;

/** centerY */
@property (nonatomic, assign) CGFloat centerY;

/** width */
@property (nonatomic, assign) CGFloat width;

/** height */
@property (nonatomic, assign) CGFloat height;

/** x */
@property (nonatomic, assign) CGFloat x;

/** y */
@property (nonatomic, assign) CGFloat y;

@property (nonatomic, assign) CGSize size;


/**
 *  从Xib中加载的控件
 */

+ (instancetype)viewFromXib;
- (BOOL)intersectWithView:(UIView *)view;
- (void)circleImage;

@end
