//
//  CommUtils.m
//  SwapSpace
//
//  Created by zzy on 04/09/2017.
//  Copyright © 2017 lanmao. All rights reserved.
//

#import "CommUtils.h"

@implementation CommUtils
+ (CommUtils *)sharedInstance {
    static dispatch_once_t pred;
    static CommUtils *instance = nil;
    dispatch_once(&pred, ^{ instance = [[self alloc] init]; });
    return instance;
}
/**
 * 获取userId
 */
- (NSString *)fetchUserId {
    
    NSUserDefaults *setting = [NSUserDefaults standardUserDefaults];
    return [setting objectForKey:@"userId"];
}

/**
 * 保存userId
 */
- (void)saveUserId:(NSString *)userId {
    
    NSUserDefaults *setting = [NSUserDefaults standardUserDefaults];
    [setting setObject:userId forKey:@"userId"];
    [setting synchronize];
}

/**
 * 移除userId
 */
- (void)removeUserId {
    
    NSUserDefaults *setting = [NSUserDefaults standardUserDefaults];
    [setting removeObjectForKey:@"userId"];
    [setting synchronize];
}

/**
 * 获取userName
 */
- (NSString *)fetchUserName {
    
    NSUserDefaults *setting = [NSUserDefaults standardUserDefaults];
    return [setting objectForKey:@"userName"];
}

/**
 * 保存userName
 */
- (void)saveUserName:(NSString *)userName {
    
    NSUserDefaults *setting = [NSUserDefaults standardUserDefaults];
    [setting setObject:userName forKey:@"userName"];
    [setting synchronize];
}
/**
 * 移除userName
 */
- (void)removeUserName {
    
    NSUserDefaults *setting = [NSUserDefaults standardUserDefaults];
    [setting removeObjectForKey:@"userName"];
    [setting synchronize];
}

/**
 * 获取当前所选城市
 */
- (NSString *)fetchCityName {
    
    NSUserDefaults *setting = [NSUserDefaults standardUserDefaults];
    return [setting objectForKey:@"cityName"];
}

/**
 * 保存当前所选城市
 */
- (void)saveCityName:(NSString *)cityName {
    
    NSUserDefaults *setting = [NSUserDefaults standardUserDefaults];
    [setting setObject:cityName forKey:@"cityName"];
    [setting synchronize];
}

- (NSMutableArray *)getMyStickPostCache {
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:MyStickFileName];
    NSData *data = [NSData dataWithContentsOfFile:path];
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}
@end
