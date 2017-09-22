//
//  PostPhotoWall.m
//  SwapSpace
//
//  Created by zzy on 06/09/2017.
//  Copyright © 2017 lanmao. All rights reserved.
//

#import "PostPhotoWall.h"
#import "PhotoImageView.h"
#define ImageW 90
#define VerticalSpace 12

@interface PostPhotoWall()
@end

@implementation PostPhotoWall

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

#pragma mark --CreatUI--
- (void)initView {

    for (int i = 0; i < self.photoArr.count; i++) {
        
        PhotoImageView *image = [[PhotoImageView alloc]init];
        image.userInteractionEnabled = YES;
        [self addSubview:image];
        image.image = self.photoArr[i];
        image.tag = i;
        
        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [deleteBtn setBackgroundImage:[UIImage imageNamed:@"delete_photo"] forState:UIControlStateNormal];
        deleteBtn.tag = i;
        [deleteBtn addTarget:self action:@selector(deleteClick:) forControlEvents:UIControlEventTouchUpInside];
        [image addSubview:deleteBtn];
    }
    
    self.height = ((self.photoArr.count-1)/3+1) * (ImageW + VerticalSpace);
}

/**
 * 布局子控件
 */
- (void)layoutSubviews {
    
    CGFloat hspace = (self.width - 3 * ImageW) / 4;
    for (int i = 0; i < self.subviews.count; i++) {
    
        UIImageView *image = self.subviews[i];
        image.frame = CGRectMake((i%3+1)*hspace+(i%3)*ImageW, (i/3)*ImageW+(i/3+1)*VerticalSpace, ImageW, ImageW);
        
        UIButton *deleteBtn = image.subviews[0];
        deleteBtn.frame = CGRectMake(image.width - 18/2, -18/2, 18, 18);
    }
}

/**
 * 图片数组set方法
 */
- (void)setPhotoArr:(NSMutableArray *)photoArr {

    _photoArr = photoArr;
    [self initView];
    [self setNeedsLayout]; //立即刷新布局
}

- (void)deleteClick:(UIButton *)sender {

    if ([self.delegate respondsToSelector:@selector(deletePhoto:)]) {
        
        [self.delegate deletePhoto:sender.tag];
    }
}
@end
