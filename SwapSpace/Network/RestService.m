//
//  RestService.m
//  HeXin
//
//  Created by zzy on 9/30/15.
//  Copyright © 2015 zzy. All rights reserved.
//

#import "RestService.h"



@implementation RestService
+ (id)sharedService {
    
    static RestService *_sharedService = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedService = [[self alloc] init];
    });
    
    return _sharedService;
}

- (NSString *)getUrl:(NSString *)resource {
    
    return [NSString stringWithFormat:@"%@%@", BaseUrl, resource];
    
}


//get请求
- (void)afnetworkingGet:(NSString *)str :(completionHandler)completion{
    
    
    NSString *url = [self getUrl:str];
    NSLog(@"%@",url);
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 15.0f;
    
    //    [manager.requestSerializer setValue:[[CommUtils sharedInstance] fetchToken] forHTTPHeaderField:@"cookie"];
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@",responseObject);
        completion(responseObject,YES);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD showErrorWithStatus:@"网络连接发生错误"];
        completion(error,NO);
        return;
    }];
    
}

//post请求
- (void)afnetworkingPost:(NSString *)str responseType:(ResponseType)responseType parameters:(NSDictionary *)parameters completion:(completionHandler)completion {
    
    NSString *url = [self getUrl:str];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    DLog(@"%@",url);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    if (responseType == Binary) {
        
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    } else {
    
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    
    manager.requestSerializer.timeoutInterval = 15.0f;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
//    [manager.requestSerializer setValue:[[CommUtils sharedInstance] fetchToken] forHTTPHeaderField:@"cookie"];
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        completion(responseObject,YES);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        DLog(@"%@",error);
        completion(error,NO);
        return;
    }];
}

@end
