//
//  BaseViewController.m
//  BathroomShopping
//
//  Created by zzy on 7/2/16.
//  Copyright © 2016 zzy. All rights reserved.
//

#import "BaseViewController.h"
#import "LoadingView.h"
@interface BaseViewController ()
/** <##> */
@property(nonatomic,strong)LoadingView *loadingView;
@end

@implementation BaseViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    self.view.backgroundColor = [UIColor whiteColor];
}



- (void)openLoading {
    self.loadingView = [[LoadingView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.loadingView];
}

- (void)closeLoading {
    [_loadingView removeFromSuperview];
    self.loadingView = nil;
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}
@end
