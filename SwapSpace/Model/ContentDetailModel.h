//
//  ContentDetailModel.h
//  SwapSpace
//
//  Created by zzy on 03/09/2017.
//  Copyright © 2017 lanmao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContentDetailModel : NSObject
/** <##> */
@property(nonatomic,copy)NSString *pid;
/** <##> */
@property(nonatomic,copy)NSString *title;
/** <##> */
@property(nonatomic,copy)NSString *pcreatetime;
/** <##> */
@property(nonatomic,copy)NSString *readernum;
/** <##> */
@property(nonatomic,copy)NSString *content;
/** <##> */
@property(copy,nonatomic)NSString *price;
/** <##> */
@property(nonatomic,copy)NSString *address;
/** <##> */
@property(copy,nonatomic)NSString *contact;
/** <##> */
@property(copy,nonatomic)NSString *phone;
/** <##> */
@property(nonatomic,strong)NSArray *photoArray;
@end
