//
//  HomeViewController.m
//  SwapSpace
//
//  Created by zzy on 24/08/2017.
//  Copyright © 2017 lanmao. All rights reserved.
//

#import "HomeViewController.h"
#import "TLCityPickerController.h"
#import "CustomButton.h"
#import "PostViewController.h"
#import "SearchViewController.h"
#import "ContentViewController.h"
#import "PersonalCenterViewController.h"
#import "LoginViewController.h"
#import "CommUtils.h"
#import "LocationManage.h"

@interface HomeViewController ()<TLCityPickerDelegate, UIAlertViewDelegate, UISearchBarDelegate>
/** <##> */
@property (nonatomic, weak) UIButton *chooseCityBtn;
/** <##> */
@property (nonatomic, weak) UISearchBar *searchBar;
/** <##> */
@property(nonatomic,strong)NSArray *categoryArr;
@end

@implementation HomeViewController

- (NSArray *)categoryArr {
    
    if (_categoryArr == nil) {
        
        _categoryArr = @[@"房产",@"交通工具",@"手机",@"家电",@"招聘",@"二手交易"];
    }
    
    return _categoryArr;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationItem.title = @"置换空间";

    UIButton *callBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [callBtn setTitle:@"客服电话" forState:UIControlStateNormal];
    [callBtn setImage:[UIImage imageNamed:@"call_icon"] forState:UIControlStateNormal];
    callBtn.width = 70;
    callBtn.height = 35;
    callBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    callBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [callBtn addTarget:self action:@selector(callClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:callBtn];
    
    NSString *cityName = [[CommUtils sharedInstance] fetchCityName];
    if ([cityName hasSuffix:@"市"]) {
        cityName = [cityName stringByReplacingCharactersInRange:NSMakeRange(cityName.length - 1, 1) withString:@""];
    }
    NSString *selectCity = cityName.length > 0 ? cityName : @"北京";
    UIButton *chooseCityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [chooseCityBtn setTitle:selectCity forState:UIControlStateNormal];
    [chooseCityBtn setImage:[UIImage imageNamed:@"down_arrow"] forState:UIControlStateNormal];
    chooseCityBtn.width = 70;
    chooseCityBtn.height = 35;
    chooseCityBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    chooseCityBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [chooseCityBtn addTarget:self action:@selector(chooseCity) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:chooseCityBtn];
    self.chooseCityBtn = chooseCityBtn;
    [self layoutChooseBtnFrame];
    [self initView];
    
    [[LocationManage sharedInstance] locationWithCompletionBlock:^(NSString *locationCity) {
        
        NSString *cityName = locationCity;
        if ([cityName hasSuffix:@"市"]) {
            cityName = [cityName stringByReplacingCharactersInRange:NSMakeRange(cityName.length - 1, 1) withString:@""];
        }
        
        if ([[CommUtils sharedInstance] fetchCityName].length > 0) {
        
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"当前定位城市是%@，是否切换",cityName] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
            
        } else {
            
            [[CommUtils sharedInstance] saveCityName:locationCity];
            [LocationManage sharedInstance].selectCity = cityName;
            [self.chooseCityBtn setTitle:cityName forState:UIControlStateNormal];
            [self layoutChooseBtnFrame];
        }
    }];
}

- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
    [self.searchBar resignFirstResponder];
}

- (void)initView {
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    searchBtn.backgroundColor = [UIColor colorWithHexString:@"fcbc93"];
    searchBtn.frame = CGRectMake(self.view.width - 20 - 50, 75, 50, 30);
    searchBtn.layer.cornerRadius = 5;
    searchBtn.layer.masksToBounds = YES;
    searchBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [searchBtn addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchBtn];
    
    [[UISearchBar appearance] setSearchFieldBackgroundImage:[UIImage imageNamed:@"search_bg"] forState:UIControlStateNormal];
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, searchBtn.x - 5, 35)];
    searchBar.centerY = searchBtn.centerY;
    searchBar.placeholder = @"搜索关键字或相关地址";
    searchBar.tintColor = [UIColor lightGrayColor];
    UIOffset offect = {5, 0};
    searchBar.searchTextPositionAdjustment = offect;
    UITextField *searchField = [searchBar valueForKey:@"_searchField"];
    [searchField setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
    [searchBar setBackgroundImage:[[UIImage alloc] init]];
    searchBar.delegate = self;
    [self.view addSubview:searchBar];
    self.searchBar = searchBar;
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(searchBar.frame) + 8, self.view.width, 1)];
    line.backgroundColor = kSeparatorLineColor;
    [self.view addSubview:line];

    CustomButton *postBtn = [CustomButton buttonWithType:UIButtonTypeCustom];
    postBtn.backgroundColor = [UIColor colorWithHexString:@"2dbaa6"];
    [postBtn setTitle:@"我要发布" forState:UIControlStateNormal];
    [postBtn setImage:[UIImage imageNamed:@"post"] forState:UIControlStateNormal];
    postBtn.frame = CGRectMake(0, self.view.height - 50, self.view.width / 2, 50);
    postBtn.centerOffset = 10;
    postBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [postBtn addTarget:self action:@selector(postClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:postBtn];
    
    CustomButton *personCenterBtn = [CustomButton buttonWithType:UIButtonTypeCustom];
    personCenterBtn.backgroundColor = [UIColor colorWithHexString:@"2dbaa6"];
    [personCenterBtn setTitle:@"个人中心" forState:UIControlStateNormal];
    [personCenterBtn setImage:[UIImage imageNamed:@"personal_center"] forState:UIControlStateNormal];
    personCenterBtn.frame = CGRectMake(CGRectGetMaxX(postBtn.frame), self.view.height - 50, self.view.width / 2, 50);
    personCenterBtn.centerOffset = 10;
    personCenterBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [personCenterBtn addTarget:self action:@selector(personalClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:personCenterBtn];
    
    UIView *bottomline = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.height - 47, 0.5, 44)];
    bottomline.centerX = self.view.centerX;
    bottomline.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomline];
    
    UIView *categoryView = [[UIView alloc]initWithFrame:CGRectMake(30, line.bottom + 30, self.view.width - 60, self.view.height - 50 - 60 - line.bottom)];
    [self.view addSubview:categoryView];
    
    NSArray *imageArr = @[@"btn_houseproperty",@"btn_traffic",@"btn_fhone",@"btn_household",@"btn_recruit",@"btn_other"];
    CGFloat categoryBtnW = (categoryView.width - 20) / 2;
    CGFloat categoryBtnH = 83*categoryBtnW/109;
    CGFloat hSpace = (categoryView.height - 3*categoryBtnH) / 2;
    for (int i = 0; i < imageArr.count; i++) {
        
        UIButton *categoryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        categoryBtn.frame = CGRectMake((i%2)*(categoryBtnW+20), i/2*(categoryBtnH + hSpace), categoryBtnW, categoryBtnH);
        [categoryBtn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",imageArr[i]]] forState:UIControlStateNormal];
        [categoryBtn addTarget:self action:@selector(categoryClick:) forControlEvents:UIControlEventTouchUpInside];
        categoryBtn.tag = 100+i;
        categoryBtn.adjustsImageWhenHighlighted = NO;
        [categoryView addSubview:categoryBtn];
    }
}

- (void)categoryClick:(UIButton *)sender {

    ContentViewController *contentVC = [[ContentViewController alloc]init];
    contentVC.type = self.categoryArr[sender.tag-100];
    switch (sender.tag) {
        case 100:
            contentVC.subTypeArr = @[@"全部",@"出租",@"出售"];
            break;
        case 101:
            contentVC.subTypeArr = @[@"全部",@"汽车",@"其他"];
            break;
        case 102:
            contentVC.subTypeArr = @[@"全部",@"苹果",@"其他"];
            break;
        case 103:
            contentVC.subTypeArr = @[@"全部",@"冰箱",@"洗衣机",@"电视",@"其他"];
            break;
        case 104:
            contentVC.subTypeArr = @[@"全部",@"全职",@"兼职"];
            break;
        case 105:
            contentVC.subTypeArr = @[@"全部",@"二手交易"];
            break;
        default:
            break;
    }
    [self.navigationController pushViewController:contentVC animated:YES];
}

/**
 * 信息搜索
 */
- (void)searchClick {

    if (self.searchBar.text.length == 0) {
        
        [SVProgressHUD showErrorWithStatus:@"搜索关键字不能为空！"];
        return;
    }
    SearchViewController *searchVC = [[SearchViewController alloc]init];
    searchVC.searchContent = self.searchBar.text;
    [self.navigationController pushViewController:searchVC animated:YES];
}

/**
 * 选择城市
 */
- (void)chooseCity {

    TLCityPickerController *cityPickerVC = [[TLCityPickerController alloc] init];
    [cityPickerVC setDelegate:self];
    
    cityPickerVC.locationCityName = [[LocationManage sharedInstance].locationCity stringByAppendingString:@"市"];
    //最近访问城市，如果不设置，将自动管理
    cityPickerVC.hotCitys = @[@"100010000", @"200010000", @"300210000", @"600010000", @"300110000"];
    
    [self.navigationController pushViewController:cityPickerVC animated:YES];
}

- (void)callClick {

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:18614005553"]];
}

- (void)layoutChooseBtnFrame {

    CGSize size = [self.chooseCityBtn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    self.chooseCityBtn.width = size.width + 18;
    [self.chooseCityBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -self.chooseCityBtn.imageView.size.width, 0, self.chooseCityBtn.imageView.size.width)];
    [self.chooseCityBtn setImageEdgeInsets:UIEdgeInsetsMake(0, self.chooseCityBtn.titleLabel.bounds.size.width, 0, -self.chooseCityBtn.titleLabel.bounds.size.width)];
}

/**
 * 发帖
 */
- (void)postClick {

    if ([[CommUtils sharedInstance] fetchUserId].length > 0) {//已登录
        
        PostViewController *postVC = [[PostViewController alloc]init];
        [self.navigationController pushViewController:postVC animated:YES];
        
    } else { //未登录
        
        LoginViewController *loginVC = [[LoginViewController alloc]init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}

- (void)personalClick {

    if ([[CommUtils sharedInstance] fetchUserId].length > 0) {//已登录
        
        PersonalCenterViewController *personalCenterVC = [[PersonalCenterViewController alloc]init];
        [self.navigationController pushViewController:personalCenterVC animated:YES];
        
    } else { //未登录
    
        LoginViewController *loginVC = [[LoginViewController alloc]init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [self.searchBar resignFirstResponder];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (buttonIndex == 1) {
        
        NSString *cityName = [LocationManage sharedInstance].locationCity;
       
        [[CommUtils sharedInstance] saveCityName:[cityName stringByAppendingString:@"市"]];
        [LocationManage sharedInstance].selectCity = cityName;
        [self.chooseCityBtn setTitle:cityName forState:UIControlStateNormal];
        [self layoutChooseBtnFrame];
    }
}

#pragma mark - TLCityPickerDelegate
- (void)cityPickerController:(TLCityPickerController *)cityPickerViewController didSelectCity:(TLCity *)city
{
    [self.chooseCityBtn setTitle:city.shortName forState:UIControlStateNormal];
    [LocationManage sharedInstance].selectCity = city.shortName;
    [[CommUtils sharedInstance] saveCityName:city.cityName];
    [cityPickerViewController.navigationController popViewControllerAnimated:YES];
    [self layoutChooseBtnFrame];
}

- (void)cityPickerControllerDidCancel:(TLCityPickerController *)cityPickerViewController
{
    [cityPickerViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.searchBar resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
