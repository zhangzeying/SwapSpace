//
//  UITableView+EmptyData.h
//  bigbusiness
//
//  Created by zzy on 2/4/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (EmptyData)
- (void)tableViewDisplayWitMsg:(NSString *)message ifNecessaryForRowCount:(NSUInteger) rowCount;
@end
