//
//  AppDelegate.m
//  SwapSpace
//
//  Created by zzy on 24/08/2017.
//  Copyright © 2017 lanmao. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "BaseNavigationController.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "CommUtils.h"
#import "AdViewController.h"
#import "AppVersionService.h"
#import "StatictisService.h"
#import <Bugly/Bugly.h>
@interface AppDelegate ()<BMKGeneralDelegate,UIAlertViewDelegate>
{
    BMKMapManager* _mapManager;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self buildKeyWindow];
    [Bugly startWithAppId:@"887115c689"];
    [self initBaiDuMapSDK];
    [self initShareSDK];
    // 调整SVProgressHUD的背景色和前景色
    [SVProgressHUD setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.8]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [AppVersionService getAppVersion:^(NSDictionary *dict) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"发现新版本 %@",dict[@"version"]] message:dict[@"content"] delegate:self cancelButtonTitle:@"稍后再说" otherButtonTitles:@"立即去更新", nil];
        [alert show];
        
    }];
    [StatictisService statictisForActivation];
    NSMutableArray *array = [[CommUtils sharedInstance] getMyStickPostCache];
    NSMutableArray *tempArr = array.mutableCopy;
    for (NSDictionary *dict in tempArr) {
        
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[dict[@"Time"] longLongValue]];
        NSTimeInterval intervalTime = [[NSDate date] timeIntervalSinceDate:date];
        if (intervalTime > 60*60*24) {
            [array removeObject:dict];
        }
    }
    return YES;
}

- (void)buildKeyWindow {
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    AdViewController *adVC = [[AdViewController alloc]init];
    self.window.rootViewController = adVC;
    [self.window makeKeyAndVisible];
}

- (void)changeRootVC {

    HomeViewController *homeVC = [[HomeViewController alloc]init];
    BaseNavigationController *nav = [[BaseNavigationController alloc]initWithRootViewController:homeVC];
    self.window.rootViewController = nav;
}

- (void)initBaiDuMapSDK {

    _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:kBaiduMapKey generalDelegate:self];
    if (!ret) {
        DLog(@"manager start failed!");
    }
}

- (void)initShareSDK {

    [ShareSDK registerActivePlatforms:@[@(SSDKPlatformTypeQQ)
                                        ]
                             onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             default:
                 break;
         }
     }
                      onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         switch (platformType)
         {
                 
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:kQQAppId
                                      appKey:kQQAppKey
                                    authType:SSDKAuthTypeBoth];
                 break;
                 
             default:
                 break;
         }
     }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/%E7%BD%AE%E6%8D%A2%E7%A9%BA%E9%97%B4/id1282007862?l=zh&ls=1&mt=8"]];
    }
}

/**
 *返回网络错误
 *@param iError 错误号
 */
- (void)onGetNetworkState:(int)iError {
    
    if (0 == iError) {
        NSLog(@"联网成功");
    }
    else{
        NSLog(@"onGetNetworkState %d",iError);
    }

}

/**
 *返回授权验证错误
 *@param iError 错误号 : 为0时验证通过，具体参加BMKPermissionCheckResultCode
 */
- (void)onGetPermissionState:(int)iError {
    
    if (0 == iError) {
        NSLog(@"授权成功");
    }
    else {
        NSLog(@"onGetPermissionState %d",iError);
    }
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
