//
//  CSCustomRefreshFooter.m
//  ChangShuo
//
//  Created by zzy on 18/04/2017.
//  Copyright © 2017 ctkj. All rights reserved.
//

#import "CSCustomRefreshFooter.h"

@interface CSCustomRefreshFooter ()
@property (weak, nonatomic) UIActivityIndicatorView *indicatorV;
@property (weak, nonatomic) UILabel *label;
@end
@implementation CSCustomRefreshFooter
#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare
{
    [super prepare];
    
    // 设置控件的高度
    self.mj_h = 50;
    
    // 添加label
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:13.0f];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor colorWithHexString:@"#AAAAAA"];
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    self.label = label;
    
    UIActivityIndicatorView *indicatorVTemp = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicatorVTemp.hidesWhenStopped = YES;
    [self addSubview:indicatorVTemp];
    self.indicatorV = indicatorVTemp;
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    CGSize sizeTemp = CGSizeMake(25, 25);
    [self.label sizeToFit];
    self.label.frame = (CGRect){(self.frame.size.width - self.label.frame.size.width)/2,13,self.label.frame.size.width,25};
    CGRect rectTemp = CGRectZero;
    rectTemp.size = sizeTemp;
    rectTemp.origin.x = self.label.frame.origin.x - sizeTemp.width - 7;
    rectTemp.origin.y = 13;
    self.indicatorV.frame = rectTemp;
}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;
    
    switch (state) {
        case MJRefreshStateIdle:
        {
            [self.indicatorV stopAnimating];
            self.label.text = @"上拉加载更多";
            break;
        }
        case MJRefreshStatePulling:
        {
            [self.indicatorV stopAnimating];
            self.label.text = @"松开加载数据";
            break;
        }
        case MJRefreshStateRefreshing:
        {
            [self.indicatorV startAnimating];
            self.label.text = @"正在加载数据";
            break;
        }
        case MJRefreshStateNoMoreData:
        {
            [self.indicatorV stopAnimating];
            self.label.text = @"已经全部加载完毕";
            break;
        }
        default:
            break;
    }
}

@end
