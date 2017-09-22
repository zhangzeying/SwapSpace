//
//  CustomButton.m
//  BathroomShopping
//
//  Created by zzy on 7/13/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "CustomButton.h"
@implementation CustomButton

- (void)layoutSubviews {
    
    [super layoutSubviews];
    CGFloat midX = self.frame.size.width / 2;
    CGFloat midY = self.frame.size.height/ 2 ;
    [self.titleLabel sizeToFit];
    self.titleLabel.center = CGPointMake(midX, midY + self.centerOffset);
    self.imageView.center = CGPointMake(midX, midY - 10);
}

- (void)setCenterOffset:(CGFloat)centerOffset {

    _centerOffset = centerOffset;
    [self setNeedsLayout];
}
@end
