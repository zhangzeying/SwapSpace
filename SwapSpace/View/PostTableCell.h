//
//  PostTableCell.h
//  SwapSpace
//
//  Created by zzy on 02/09/2017.
//  Copyright © 2017 lanmao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ContentModel;
@interface PostTableCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)table;
/** <##> */
@property(nonatomic,strong)ContentModel *model;
/** <##> */
@property (nonatomic, weak)UIViewController *vc;
@end
