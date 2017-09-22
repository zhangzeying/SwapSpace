//
//  CommUtils.h
//  SwapSpace
//
//  Created by zzy on 04/09/2017.
//  Copyright © 2017 lanmao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommUtils : NSObject
+ (CommUtils *)sharedInstance;
/**
 * 获取userId
 */
- (NSString *)fetchUserId;
/**
 * 保存userId
 */
- (void)saveUserId:(NSString *)userId;
/**
 * 移除userId
 */
- (void)removeUserId;
/**
 * 获取userName
 */
- (NSString *)fetchUserName;
/**
 * 保存userName
 */
- (void)saveUserName:(NSString *)userName;
/**
 * 移除userName
 */
- (void)removeUserName;
/**
 * 获取userName
 */
- (NSString *)fetchCityName;
/**
 * 保存定位城市
 */
- (void)saveCityName:(NSString *)cityName;

- (NSMutableArray *)getMyStickPostCache;
@end
