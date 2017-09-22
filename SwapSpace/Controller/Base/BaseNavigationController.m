//
//  BaseNavigationController.m
//  yili
//
//  Created by zzy on 2/19/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()<UINavigationControllerDelegate>
@property(nonatomic,strong) id popGestureDelegate; //用来保存系统手势的代理
@end

@implementation BaseNavigationController

- (void)viewDidLoad {

    [[UINavigationBar appearance] setBarTintColor: NavgationBarColor];
    self.popGestureDelegate = self.interactivePopGestureRecognizer.delegate;
    self.delegate = self;
}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {

   
    if (self.childViewControllers.count > 0) {
    
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"nav_back_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
    }

    [super pushViewController:viewController animated:animated];
}

-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([self.topViewController isEqual:self.viewControllers[0]]) {
        //如果是根控制器，恢复系统手势默认的代理
        self.interactivePopGestureRecognizer.delegate = self.popGestureDelegate;
        
    } else {
        //如果是非根控制器，将系统手势的默认代理置空
        self.interactivePopGestureRecognizer.delegate = nil;
    }
}

- (void)backClick {

    [self popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}


@end
