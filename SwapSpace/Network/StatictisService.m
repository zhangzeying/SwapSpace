//
//  StatictisService.m
//  SwapSpace
//
//  Created by zzy on 24/09/2017.
//  Copyright © 2017 lanmao. All rights reserved.
//

#import "StatictisService.h"
#import "RestService.h"
#import "SvUDIDTools.h"
#import "LocationManage.h"
@implementation StatictisService
/**
 * app打开次数统计
 */
+ (void)statictisForActivation {
    
    NSDictionary *params = @{@"machineFlag":[SvUDIDTools UDID],
                             @"type":@"1",
                             @"city":[LocationManage sharedInstance].locationCity?:@"",
                             @"street":[LocationManage sharedInstance].address?:@""
                             };
    
    [[RestService sharedService] afnetworkingPost:kAPIActivation responseType:Json parameters:params completion:^(id myAfNetBlokResponeDic, BOOL flag) {
        NSLog(@"%@",myAfNetBlokResponeDic);
    }];
}
@end
