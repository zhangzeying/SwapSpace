//
//  LocationManage.h
//  SwapSpace
//
//  Created by zzy on 04/09/2017.
//  Copyright © 2017 lanmao. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^LocationBlock)(NSString *locationCity);
@interface LocationManage : NSObject
+ (instancetype)sharedInstance;
- (void)locationWithCompletionBlock:(LocationBlock)locationBlock;
/** 当前所选城市 */
@property(nonatomic,copy)NSString *selectCity;
/** 当前定位城市 */
@property(nonatomic,copy)NSString *locationCity;
/** <##> */
@property(nonatomic,copy)NSString *address;
/** <##> */
@property(assign,nonatomic)double longitude;
/** <##> */
@property(assign,nonatomic)double latitude;
@end
