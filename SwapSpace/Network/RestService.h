//
//  RestService.h
//  HeXin
//
//  Created by zzy on 9/30/15.
//  Copyright © 2015 zzy. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger ,ResponseType){
    Binary, //二进制
    Json, //json
};
@interface RestService : NSObject
typedef void(^completionHandler)(id myAfNetBlokResponeDic,BOOL flag);
+ (id)sharedService;
//get请求
- (void)afnetworkingGet:(NSString *)str :(completionHandler)completion;

//post请求
- (void)afnetworkingPost:(NSString *)str responseType:(ResponseType)responseType parameters:(NSDictionary *)parameters completion:(completionHandler)completion;
@end
