//
//  PhotoImageView.m
//  SwapSpace
//
//  Created by zzy on 07/09/2017.
//  Copyright © 2017 lanmao. All rights reserved.
//

#import "PhotoImageView.h"

@implementation PhotoImageView

- (nullable UIView *)hitTest:(CGPoint)point withEvent:(nullable UIEvent *)event {
    
    UIView * view = [super hitTest:point withEvent:event];
    if (view == nil) {
        for (UIView * subView in self.subviews) {
            // 将坐标系转化为自己的坐标系
            CGPoint tp = [subView convertPoint:point fromView:self];
            if (CGRectContainsPoint(subView.bounds, tp)) {
                view = subView;
            }
        }
    }
    return view;
}

@end
