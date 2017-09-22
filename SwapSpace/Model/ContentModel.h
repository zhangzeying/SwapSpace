//
//  ContentModel.h
//  SwapSpace
//
//  Created by zzy on 01/09/2017.
//  Copyright © 2017 lanmao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContentModel : NSObject
/** <##> */
@property(nonatomic,copy)NSString *pid;
/** <##> */
@property(nonatomic,copy)NSString *title;
/** <##> */
@property(nonatomic,copy)NSString *url;
/** <##> */
@property(nonatomic,copy)NSString *address;
/** <##> */
@property(copy,nonatomic)NSString *price;
/** <##> */
@property(assign,nonatomic)NSInteger readernum;
/** <##> */
@property(assign,nonatomic)NSInteger indexPathRow;
@end
