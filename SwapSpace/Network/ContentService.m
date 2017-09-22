//
//  ContentService.m
//  SwapSpace
//
//  Created by zzy on 31/08/2017.
//  Copyright © 2017 lanmao. All rights reserved.
//

#import "ContentService.h"
#import "RestService.h"
#import "ContentModel.h"
#import "ContentDetailModel.h"
@implementation ContentService
/**
 * 根据搜索关键字和模块查列表
 */
+ (void)getPostList:(NSString *)jsonStr completion:(void(^)(id,NSInteger))completion {
    
    NSDictionary *params = @{@"jsonpCallback":@"jsonpCallback",
                             @"jsoninput":jsonStr};
    
    
    [[RestService sharedService] afnetworkingPost:kAPIPostList responseType:Binary parameters:params completion:^(id myAfNetBlokResponeDic, BOOL flag) {
        
        if (flag) {
            
            NSString *resultStr = [[NSString alloc] initWithData:myAfNetBlokResponeDic encoding:NSUTF8StringEncoding];
            NSArray *array = [resultStr componentsSeparatedByString:@"totalPage="];
            if (array.count > 0) {
                
                NSString *str = array[0];
                NSString *jsonStr = [str substringFromIndex:14];
                jsonStr = [jsonStr substringToIndex:jsonStr.length - 1];
                NSInteger totalCount = [array[1] integerValue];
                NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
                NSArray *resultArr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
                NSArray *modelArr = [ContentModel mj_objectArrayWithKeyValuesArray:resultArr];
                completion(modelArr,totalCount);
            }
            
        } else {
        
            [SVProgressHUD showErrorWithStatus:@"网络连接发生错误"];
            completion(nil,-1);
        }
    }];
}

/**
 * 根据帖子id获取帖子详情
 */
+ (void)getPostDetailById:(NSString *)jsonStr completion:(void(^)(id))completion {
    
    NSDictionary *params = @{@"jsonpCallback":@"jsonpCallback",
                             @"jsoninput":jsonStr};
    [[RestService sharedService] afnetworkingPost:kAPIPostDetail responseType:Binary parameters:params completion:^(id myAfNetBlokResponeDic, BOOL flag) {
        
        if (flag) {
            
            NSString *resultStr = [[NSString alloc] initWithData:myAfNetBlokResponeDic encoding:NSUTF8StringEncoding];
            NSString *jsonStr = [resultStr substringFromIndex:14];
            jsonStr = [jsonStr substringToIndex:jsonStr.length - 2];
            NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
            NSArray *resultArr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
            
            [ContentDetailModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{
                         @"photoArray" : @"postattachList"
                         };
            }];
            
            NSArray *modelArr = [ContentDetailModel mj_objectArrayWithKeyValuesArray:resultArr];
            if (modelArr.count>0) {
                completion(modelArr[0]);
            }else {
                completion(nil);
            }
            
        } else {
            
            [SVProgressHUD showErrorWithStatus:@"网络连接发生错误"];
        }

        
    }];
}

/**
 * 增加帖子浏览数
 */
+ (void)addPostReadNum:(NSString *)jsonStr{
    
    NSDictionary *params = @{@"jsonpCallback":@"jsonpCallback",
                             @"jsoninput":jsonStr};
    
    [[RestService sharedService] afnetworkingPost:kAPIAddPostReadNum responseType:Binary parameters:params completion:^(id myAfNetBlokResponeDic, BOOL flag) {
        
    }];
}

/**
 * 信息搜索页面搜索帖子
 */
+ (void)searchPostList:(NSString *)jsonStr completion:(void(^)(id,NSInteger))completion {
    
    NSDictionary *params = @{@"jsonpCallback":@"jsonpCallback",
                             @"jsoninput":jsonStr};

    [[RestService sharedService] afnetworkingPost:kAPISearchPostList responseType:Binary parameters:params completion:^(id myAfNetBlokResponeDic, BOOL flag) {
        
        if (flag) {
            
            [SVProgressHUD dismiss];
            NSString *resultStr = [[NSString alloc] initWithData:myAfNetBlokResponeDic encoding:NSUTF8StringEncoding];
            NSString *jsonStr = [resultStr substringFromIndex:14];
            jsonStr = [jsonStr substringToIndex:jsonStr.length - 2];
            NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
            NSArray *resultArr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
            NSArray *modelArr = [ContentModel mj_objectArrayWithKeyValuesArray:resultArr];
            completion(modelArr,0);
            
        }else {
            
            [SVProgressHUD showErrorWithStatus:@"网络连接发生错误"];
            completion(nil,-1);
        }
        
    }];
}

/**
 * 举报
 */
+ (void)report:(NSDictionary *)params completion:(void(^)(id))completion {
    
    [[RestService sharedService] afnetworkingPost:kAPIReport responseType:Json parameters:params completion:^(id myAfNetBlokResponeDic, BOOL flag) {
        if (flag) {
            
            NSDictionary *dict = myAfNetBlokResponeDic;
            if ([dict[@"resultCode"] isEqualToString:@"1"]) {
                [SVProgressHUD showSuccessWithStatus:@"举报成功！"];
            } else if ([dict[@"resultCode"] isEqualToString:@"2"]){
                [SVProgressHUD showErrorWithStatus:@"不能重复举报！"];
            } else {
                [SVProgressHUD showErrorWithStatus:@"举报失败！"];
            }
        } else {
            
            [SVProgressHUD showErrorWithStatus:@"网络连接发生错误"];
        }

    }];
}

/**
 * 发帖
 */
+(void)post:(NSString *)jsonStr photoArr:(NSMutableArray *)photoArr completion:(void(^)())completion {
    
    NSDictionary *params = @{@"jsonpCallback":@"jsonpCallback",
                             @"jsoninput":jsonStr};
    [SVProgressHUD show];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 15;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json", @"text/html",@"text/json",@"text/javascript",@"multipart/form-data"]];
    [manager POST:kAPIPost parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (int i = 0; i< photoArr.count; i++) {
            
            UIImage *image = photoArr[i];
            NSDate *date = [NSDate date];
            NSDateFormatter *formormat = [[NSDateFormatter alloc]init];
            [formormat setDateFormat:@"YYYYMMdd_HHmmss"];
            NSString *dateString = [formormat stringFromDate:date];
            NSString *fileName = [NSString  stringWithFormat:@"%@.png",dateString];
            NSData *imageData = UIImageJPEGRepresentation(image, 1);
            double scaleNum = (double)300*1024/imageData.length;
            NSLog(@"图片压缩率：%f",scaleNum);
            if(scaleNum <1){
                imageData = UIImageJPEGRepresentation(image, scaleNum);
            }else{
                
                imageData = UIImageJPEGRepresentation(image, 0.1);
            }
            [formData appendPartWithFileData:imageData name:@"files" fileName:fileName mimeType:@"image/jpg/png/jpeg"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [SVProgressHUD dismiss];
        NSString *resultStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSString *jsonStr = [resultStr substringFromIndex:14];
        jsonStr = [jsonStr substringToIndex:jsonStr.length - 2];
        NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *resultArr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
        if (resultArr.count > 0) {
            
            NSInteger status = [resultArr[0] integerValue];
            if (status == 1) {
                
                [SVProgressHUD showSuccessWithStatus:@"该信息发布成功！"];
                completion();
                
            } else if (status == 2) {
                
                [SVProgressHUD showErrorWithStatus:@"请不要重复发帖！"];
                
            } else {
            
                [SVProgressHUD showErrorWithStatus:@"该信息发布失败！"];
            }
            
        } else {
            
            [SVProgressHUD showErrorWithStatus:@"该信息发布失败！"];
        }
        

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD showErrorWithStatus:@"网络连接发生错误"];
    }];
}
@end
