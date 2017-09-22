//
//  Utils.h
//  SwapSpace
//
//  Created by zzy on 11/09/2017.
//  Copyright © 2017 lanmao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject
+ (NSArray *)getDistrictArr:(BOOL)isNeedAll;
+ (NSArray *)getStreetArr:(BOOL)isNeedAll;
+ (BOOL)checkPhoneNum:(NSString *)phoneNum;
@end
