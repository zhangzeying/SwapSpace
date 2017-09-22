//
//  ContentService.h
//  SwapSpace
//
//  Created by zzy on 31/08/2017.
//  Copyright © 2017 lanmao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContentService : NSObject
/**
 * 根据搜索关键字和模块查列表
 */
+ (void)getPostList:(NSString *)jsonStr completion:(void(^)(id,NSInteger))completion;
/**
 * 根据帖子id获取帖子详情
 */
+ (void)getPostDetailById:(NSString *)jsonStr completion:(void(^)(id))completion;
/**
 * 根据帖子id获取帖子详情
 */
+ (void)addPostReadNum:(NSString *)jsonStr;
/**
 * 信息搜索页面搜索帖子
 */
+ (void)searchPostList:(NSString *)jsonStr completion:(void(^)(id,NSInteger))completion;
/**
 * 举报
 */
+ (void)report:(NSDictionary *)params completion:(void(^)(id))completion;
/**
 * 发帖
 */
+ (void)post:(NSString *)jsonStr photoArr:(NSMutableArray *)photoArr completion:(void(^)())completion;
@end
