//
//  PersonalService.h
//  SwapSpace
//
//  Created by zzy on 03/09/2017.
//  Copyright © 2017 lanmao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonalService : NSObject
/**
 * 用户登录
 */
+ (void)login:(NSString *)jsonStr completion:(void(^)(id))completion;
/**
 * 获取我发布的帖子
 */
+ (void)getMyPostList:(NSString *)jsonStr completion:(void(^)(id,NSInteger))completion;
/**
 * 删除帖子
 */
+ (void)deletePostById:(NSString *)jsonStr completion:(void(^)())completion;
/**
 * 置顶帖子
 */
+ (void)stickPostById:(NSString *)jsonStr completion:(void(^)())completion;
/**
 * 修改帖子
 */
+ (void)editPostById:(NSDictionary *)params completion:(void(^)())completion;
@end
