//
//  EditPostViewController.h
//  SwapSpace
//
//  Created by zzy on 10/09/2017.
//  Copyright © 2017 lanmao. All rights reserved.
//

#import "BaseViewController.h"
@class ContentModel;

@protocol EditPostDelegate <NSObject>

- (void)editPostSuccess:(ContentModel *)model;

@end

@interface EditPostViewController : BaseViewController
/** <##> */
@property(nonatomic,strong)ContentModel *model;

@property (nonatomic,weak) id<EditPostDelegate> delegate;
@end
