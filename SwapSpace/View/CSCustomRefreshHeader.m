//
//  CSCustomRefreshHeader.m
//  ChangShuo
//
//  Created by zzy on 18/04/2017.
//  Copyright © 2017 ctkj. All rights reserved.
//

#import "CSCustomRefreshHeader.h"

@interface CSCustomRefreshHeader()
@property (weak, nonatomic) UILabel *label;
@property (nonatomic, strong)CircleView *circleView;
/** 是否已经刷新过 */
@property(assign,nonatomic)BOOL hasRefreshed;
@end

@implementation CSCustomRefreshHeader

#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare
{
    [super prepare];
    
    // 设置控件的高度
    self.mj_h = 50;
    
    // 添加label
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor colorWithHexString:@"#AAAAAA"];
    label.font = [UIFont systemFontOfSize:13.0f];
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    self.label = label;
    
    self.circleView = [[CircleView alloc] init];
    [self addSubview:self.circleView];
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    [self.label sizeToFit];
    self.label.frame = CGRectMake(self.frame.size.width/2 - self.label.frame.size.width / 2, 15, self.label.frame.size.width, 20.0f);
    self.circleView.frame = CGRectMake(CGRectGetMinX(self.label.frame) - 30, 13, 24, 24);
}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;
    
    switch (state) {
        case MJRefreshStateIdle:
        {
            self.label.text = @"下拉可以刷新";
            break;
        }
        case MJRefreshStatePulling:
        {
            self.label.text = @"松开可以刷新";
            break;
        }
        case MJRefreshStateRefreshing:
        {
            self.label.text = @"加载数据中...";

            CABasicAnimation* rotate =  [CABasicAnimation animationWithKeyPath: @"transform.rotation.z"];
            rotate.removedOnCompletion = NO;
            rotate.fillMode = kCAFillModeForwards;
            
            //Do a series of 5 quarter turns for a total of a 1.25 turns
            //(2PI is a full turn, so pi/2 is a quarter turn)
            [rotate setToValue: [NSNumber numberWithFloat: M_PI / 2]];
            rotate.repeatCount = INT16_MAX;
            
            rotate.duration = 0.25;
            rotate.cumulative = TRUE;
            rotate.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
            [self.circleView.layer addAnimation:rotate forKey:@"rotateAnimation"];
            self.hasRefreshed = YES;//刷新过了
            break;
        }
        default:
            break;
    }
}

/**
 * 重绘圆圈
 */
- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];
    if (self.hasRefreshed) {
        self.hasRefreshed = NO;//重置状态为未刷新
    } else {
        
        self.circleView.progress = MIN(pullingPercent, 1.0);
        self.label.alpha = pullingPercent;
        [self.circleView setNeedsDisplay];
    }

}

/**
 * 结束刷新
 */
- (void)endRefreshing{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void){
        [self.circleView.layer removeAllAnimations];
        self.circleView.progress = 0;
    });
    
    [super endRefreshing];
}
@end
