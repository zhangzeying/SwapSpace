//
//  Utils.m
//  SwapSpace
//
//  Created by zzy on 11/09/2017.
//  Copyright © 2017 lanmao. All rights reserved.
//

#import "Utils.h"
#import "LocationManage.h"
@implementation Utils
+ (NSArray *)getDistrictArr:(BOOL)isNeedAll {
    
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"city_map" ofType:@"json"];
    NSData *data=[NSData dataWithContentsOfFile:jsonPath];
    NSError *error;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                         options:NSJSONReadingAllowFragments
                                                           error:&error];
    NSArray *array = [dict objectForKey:[LocationManage sharedInstance].selectCity];
    NSMutableArray *districtArr = [NSMutableArray array];
    if (isNeedAll) {
        [districtArr addObject:[NSString stringWithFormat:@"全%@",[LocationManage sharedInstance].selectCity]];
    }
    for (int i = 0; i < array.count; i++) {
        NSDictionary *dict = array[i];
        NSString *district = dict[@"county"];
        if (district.length > 0) {
            
            [districtArr addObject:district];
        }
    }
    return districtArr;
}

+ (NSArray *)getStreetArr:(BOOL)isNeedAll {
    
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"city_map" ofType:@"json"];
    NSData *data=[NSData dataWithContentsOfFile:jsonPath];
    NSError *error;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                         options:NSJSONReadingAllowFragments
                                                           error:&error];
    NSArray *array = [dict objectForKey:[LocationManage sharedInstance].selectCity];
    NSMutableArray *streetArr = @[].mutableCopy;
    for (int i = 0; i < array.count; i++) {
        NSDictionary *dict = array[i];
        NSString *district = dict[@"county"];
        if (district.length > 0) {
            NSMutableArray *arr = [NSMutableArray arrayWithArray:dict[@"streets"]];
            if (arr.count > 0 && isNeedAll) {
                [arr insertObject:[NSString stringWithFormat:@"全%@区",district] atIndex:0];
            }
            [streetArr addObject:arr];
        }
    }
    return streetArr;
}

#pragma mark 判断手机号
+ (BOOL)checkPhoneNum:(NSString *)phoneNum {
    //手机号以13， 15，14 18开头，八个 \d 数字字符
    NSString *regex = @"^((13[0-9])|(14[0-9])|(15[^4,\\D])|([1][7][8])|(18[0,0-9]))\\d{8}$";
    NSPredicate *mobileTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [mobileTest evaluateWithObject:phoneNum];
}
@end
