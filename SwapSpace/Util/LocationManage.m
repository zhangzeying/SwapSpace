//
//  LocationManage.m
//  SwapSpace
//
//  Created by zzy on 04/09/2017.
//  Copyright © 2017 lanmao. All rights reserved.
//

#import "LocationManage.h"
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import "CommUtils.h"
@interface LocationManage()<BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
/** <##> */
@property(assign,nonatomic)BOOL isLocation;
/** <##> */
@property(copy,nonatomic)LocationBlock locationBlock;
/** <##> */
@property(nonatomic,strong)BMKLocationService *locService;
/** <##> */
@property(nonatomic,strong)BMKGeoCodeSearch *searcher;
@end

@implementation LocationManage

- (BMKLocationService *)locService {
    
    if (_locService == nil) {
        
        //初始化BMKLocationService
        _locService = [[BMKLocationService alloc]init];
        _locService.delegate = self;
    }
    
    return _locService;
}

- (BMKGeoCodeSearch *)searcher {
    
    if (_searcher == nil) {
        
        _searcher = [[BMKGeoCodeSearch alloc]init];
        _searcher.delegate = self;
    }
    
    return _searcher;
}

+ (instancetype)sharedInstance
{
    static LocationManage *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[LocationManage alloc] init];
    });
    return sharedInstance;
}

- (void)locationWithCompletionBlock:(LocationBlock)locationBlock {
    
    NSString *cityName = [[CommUtils sharedInstance] fetchCityName];
    if ([cityName hasSuffix:@"市"]) {
        cityName = [cityName stringByReplacingCharactersInRange:NSMakeRange(cityName.length - 1, 1) withString:@""];
    }
    self.selectCity = cityName.length > 0 ? cityName : @"北京";
    self.locationCity = @"北京";
    self.address = @"暂无地址信息";
    [self.locService startUserLocationService];
    self.locationBlock = locationBlock;
}


#pragma mark --- BMKLocationServiceDelegate ---
/**
 * 定位成功
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    if (!self.isLocation)
    {
        self.isLocation = YES;
        [_locService stopUserLocationService];
        self.longitude = userLocation.location.coordinate.longitude;
        self.latitude = userLocation.location.coordinate.latitude;
        BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
        reverseGeocodeSearchOption.reverseGeoPoint = userLocation.location.coordinate;
        BOOL flag = [self.searcher reverseGeoCode:reverseGeocodeSearchOption];
        if (flag)
        {
            DLog(@"反geo检索发送成功");
        }
        else
        {
            DLog(@"反geo检索发送失败");
        }
    }
}

/**
 * 定位失败
 */
- (void)didFailToLocateUserWithError:(NSError *)error {
    
    [_locService startUserLocationService];
}

//接收反向地理编码结果
-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:
(BMKReverseGeoCodeResult *)result
                       errorCode:(BMKSearchErrorCode)error{
    
    if (error == BMK_SEARCH_NO_ERROR) {
        
        if (result.addressDetail.city.length > 0) {
            NSString *cityName = result.addressDetail.city;
            if ([cityName hasSuffix:@"市"]) {
                cityName = [cityName stringByReplacingCharactersInRange:NSMakeRange(cityName.length - 1, 1) withString:@""];
            }
            self.locationCity = cityName;
            for (int i = 0; i < result.poiList.count; i++) {
                
                if (i == 0) {
                    BMKPoiInfo *poiInfo = result.poiList[i];
                    self.address = poiInfo.name;
                    break;
                }
            }
            self.address = self.address > 0 ? self.address : @"暂无地址信息";
            if (self.locationBlock && ![result.addressDetail.city isEqualToString:[[CommUtils sharedInstance] fetchCityName]]) {
                
                self.locationBlock(result.addressDetail.city);
            }
            
        }
    }
    else {
        DLog(@"抱歉，未找到结果");
    }
}

@end
