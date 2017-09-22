//
//  DropDownButton.m
//  SwapSpace
//
//  Created by zzy on 31/08/2017.
//  Copyright © 2017 lanmao. All rights reserved.
//

#import "DropDownButton.h"

@implementation DropDownButton

- (void)layoutSubviews {

    [super layoutSubviews];
    self.imageView.x = self.width - 2 - self.imageView.width;
    self.titleLabel.centerX = self.width / 2;
}

@end
