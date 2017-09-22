//
//  LoadingView.m
//  SwapSpace
//
//  Created by zzy on 03/09/2017.
//  Copyright © 2017 lanmao. All rights reserved.
//

#import "LoadingView.h"

@interface LoadingView ()
/** <##> */
@property(nonatomic,strong)UILabel *loadingLabel;
/** <##> */
@property(nonatomic,strong)UIActivityIndicatorView *activityIndicator;
@end

@implementation LoadingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithHexString:@"#f6f6f6"];
        // 菊花
        self.activityIndicator = [[UIActivityIndicatorView alloc] init];
        self.activityIndicator.center = self.center;
        self.activityIndicator.color = [UIColor grayColor];
        [self addSubview:self.activityIndicator];
        [self.activityIndicator startAnimating];
        
        // 加载中...
        self.loadingLabel = [[UILabel alloc] init];
        self.loadingLabel.text = @"努力加载中...";
        [self.loadingLabel sizeToFit];
        self.loadingLabel.textColor = [UIColor colorWithHexString:@"787878"];
        self.loadingLabel.font = [UIFont systemFontOfSize:14];
        self.loadingLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.loadingLabel];
        
        CGFloat activityIndicatorX = (self.width - (self.activityIndicator.width + self.loadingLabel.width + 4)) / 2;
        self.activityIndicator.frame = CGRectMake(activityIndicatorX, 0, self.activityIndicator.width, self.activityIndicator.height);
        self.activityIndicator.centerY = self.centerY;
        self.loadingLabel.frame = CGRectMake(self.activityIndicator.right + 4, 0, self.loadingLabel.width, self.loadingLabel.height);
        self.loadingLabel.centerY = self.centerY;
        
    }
    return self;
}
@end
