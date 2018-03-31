//
//  PersonalService.m
//  SwapSpace
//
//  Created by zzy on 03/09/2017.
//  Copyright © 2017 lanmao. All rights reserved.
//

#import "PersonalService.h"
#import "RestService.h"
#import "UserModel.h"
#import "CommUtils.h"
#import "ContentModel.h"
@implementation PersonalService
/**
 * 用户登录
 */
+ (void)login:(NSString *)jsonStr completion:(void(^)(id))completion {
    
    NSDictionary *params = @{@"jsonpCallback":@"jsonpCallback",
                             @"jsoninput":jsonStr};
    
    
    [[RestService sharedService] afnetworkingPost:kAPILogin responseType:Binary parameters:params completion:^(id myAfNetBlokResponeDic, BOOL flag) {
        if (flag) {
            
            NSString *resultStr = [[NSString alloc] initWithData:myAfNetBlokResponeDic encoding:NSUTF8StringEncoding];
            NSString *jsonStr = [resultStr substringFromIndex:14];
            jsonStr = [jsonStr substringToIndex:jsonStr.length - 3];
            NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
            UserModel *model = [UserModel mj_objectWithKeyValues:dict];
            if (model.uid.length > 0) {
                [[CommUtils sharedInstance]saveUserId:model.uid];
                [[CommUtils sharedInstance]saveUserName:model.username];
            }
            completion(model);
        } else {
        
            [SVProgressHUD showErrorWithStatus:@"网络连接发生错误"];
        }
        
    }];
}

/**
 * 获取我发布的帖子
 */
+ (void)getMyPostList:(NSString *)jsonStr completion:(void(^)(id,NSInteger))completion {
    
    NSDictionary *params = @{@"jsonpCallback":@"jsonpCallback",
                             @"jsoninput":jsonStr};
    [[RestService sharedService] afnetworkingPost:kAPIMyPostList responseType:Binary parameters:params completion:^(id myAfNetBlokResponeDic, BOOL flag) {
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
        }
        
    }];
}

/**
 * 删除帖子
 */
+ (void)deletePostById:(NSString *)jsonStr completion:(void(^)())completion {
    
    NSDictionary *params = @{@"jsonpCallback":@"jsonpCallback",
                             @"jsoninput":jsonStr};
    [[RestService sharedService] afnetworkingPost:kAPIDeletePost responseType:Binary parameters:params completion:^(id myAfNetBlokResponeDic, BOOL flag) {
        if (flag) {
            
            NSString *resultStr = [[NSString alloc] initWithData:myAfNetBlokResponeDic encoding:NSUTF8StringEncoding];
            NSString *jsonStr = [resultStr substringFromIndex:14];
            jsonStr = [jsonStr substringToIndex:jsonStr.length - 3];
            NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
            NSArray *resultArr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
            if (resultArr.count > 0) {
                
                NSInteger status = [resultArr[0] integerValue];
                if (status == 1) {
                    
                    [SVProgressHUD showSuccessWithStatus:@"该信息删除成功！"];
                     completion();
                    
                } else {
                    
                    [SVProgressHUD showErrorWithStatus:@"该信息删除失败！"];
                }
                
            } else {
                
                [SVProgressHUD showErrorWithStatus:@"该信息删除失败！"];
            }
        } else {
            
            [SVProgressHUD showErrorWithStatus:@"网络连接发生错误"];
        }
    }];
}

/**
 * 置顶帖子
 */
+ (void)stickPostById:(NSString *)jsonStr completion:(void(^)())completion {
    
    NSDictionary *params = @{@"jsonpCallback":@"jsonpCallback",
                             @"jsoninput":jsonStr};
    [[RestService sharedService] afnetworkingPost:kAPIStickPost responseType:Binary parameters:params completion:^(id myAfNetBlokResponeDic, BOOL flag) {
        if (flag) {
            
            NSString *resultStr = [[NSString alloc] initWithData:myAfNetBlokResponeDic encoding:NSUTF8StringEncoding];
            NSString *jsonStr = [resultStr substringFromIndex:14];
            jsonStr = [jsonStr substringToIndex:jsonStr.length - 3];
            NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
            NSArray *resultArr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
            if (resultArr.count > 0) {
                
                NSInteger status = [resultArr[0] integerValue];
                if (status == 1) {
                    
                    [SVProgressHUD showSuccessWithStatus:@"该信息置顶成功！"];
                    completion();
                    
                } else {
                
                    [SVProgressHUD showErrorWithStatus:@"该信息置顶失败！"];
                }
                
            } else {
                
                [SVProgressHUD showErrorWithStatus:@"该信息置顶失败！"];
            }
        } else {
            
            [SVProgressHUD showErrorWithStatus:@"网络连接发生错误"];
        }
        
    }];
}

/**
 * 修改帖子
 */
+ (void)editPostById:(NSDictionary *)params completion:(void(^)())completion{
    
    [[RestService sharedService] afnetworkingPost:kAPIEditPost responseType:Json parameters:params completion:^(id myAfNetBlokResponeDic, BOOL flag) {
        if (flag) {
            
            NSDictionary *dict = myAfNetBlokResponeDic;
            if ([dict[@"stat"] isEqualToString:@"1"]) {
                
                [SVProgressHUD showSuccessWithStatus:@"该信息修改成功！"];
                completion();
                
            } else {
                
                [SVProgressHUD showErrorWithStatus:@"该信息修改失败！"];
            }
        } else {
            
            [SVProgressHUD showErrorWithStatus:@"网络连接发生错误"];
        }
        
    }];
}
@end
