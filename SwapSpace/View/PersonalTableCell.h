//
//  PersonalTableCell.h
//  SwapSpace
//
//  Created by zzy on 04/09/2017.
//  Copyright © 2017 lanmao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ContentModel,PersonalCenterViewController;

@protocol PersonalTableCellDelegate <NSObject>

- (void)deletePostSuccess:(ContentModel *)model;
- (void)editPost:(ContentModel *)model;
@end


@interface PersonalTableCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)table;
/** <##> */
@property(nonatomic,strong)ContentModel *model;
@property (nonatomic,weak) id<PersonalTableCellDelegate> delegate;
@end
