//
//  PostPhotoWall.h
//  SwapSpace
//
//  Created by zzy on 06/09/2017.
//  Copyright © 2017 lanmao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PostPhotoWallDelegate <NSObject>

- (void)deletePhoto:(NSInteger)index;

@end

@interface PostPhotoWall : UIView
/** 所选图片数组 */
@property(nonatomic,strong)NSMutableArray *photoArr;
@property (nonatomic,weak) id<PostPhotoWallDelegate> delegate;
@end
