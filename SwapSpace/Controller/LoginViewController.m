//
//  LoginViewController.m
//  SwapSpace
//
//  Created by zzy on 04/09/2017.
//  Copyright © 2017 lanmao. All rights reserved.
//

#import "LoginViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "PersonalService.h"
#import "CommUtils.h"
#import "UserModel.h"
@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"登录";
    UIButton *qqLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    qqLoginBtn.frame = CGRectMake(0, 0, 100, 150);
    qqLoginBtn.center = self.view.center;
    [qqLoginBtn setBackgroundImage:[UIImage imageNamed:@"qq"] forState:UIControlStateNormal];
    qqLoginBtn.adjustsImageWhenHighlighted = NO;
    [qqLoginBtn addTarget:self action:@selector(qqLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:qqLoginBtn];
}

- (void)qqLogin {
    
    [SVProgressHUD show];
    [ShareSDK getUserInfo:SSDKPlatformTypeQQ
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
     {
         
         if (state == SSDKResponseStateSuccess)
         {
             NSDictionary *dict = @{@"userid":user.uid,
                                    @"username":user.nickname,
                                    @"weixin":user.nickname,
                                    @"phone":@""
                                    };
             NSError *error;
             NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
             if (!error) {
                 
                 NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                 [PersonalService login:jsonStr completion:^(UserModel *model) {
                     
                     if (model) {
                         
                         [SVProgressHUD showSuccessWithStatus:@"登录成功"];
                         [self.navigationController popViewControllerAnimated:YES];
                         
                     } else {
                         
                         [SVProgressHUD showErrorWithStatus:@"登录失败"];
                     }
                 }];
             }
             
         }
         
         else if (state == SSDKResponseStateFail)
         {
             [SVProgressHUD showErrorWithStatus:@"登录失败"];
             
         } else {
             
             [SVProgressHUD dismiss];
         }
         
     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
