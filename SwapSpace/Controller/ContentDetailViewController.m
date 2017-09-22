//
//  ContentDetailViewController.m
//  SwapSpace
//
//  Created by zzy on 30/08/2017.
//  Copyright © 2017 lanmao. All rights reserved.
//

#import "ContentDetailViewController.h"
#import "ContentService.h"
#import "ContentDetailModel.h"
#import "SDCycleScrollView.h"
#import "HZPhotoBrowser.h"
#import "CommUtils.h"
#import "LoginViewController.h"

@interface ContentDetailViewController ()<SDCycleScrollViewDelegate,HZPhotoBrowserDelegate,UIAlertViewDelegate>
/** <##> */
@property (nonatomic, weak) UIView *phoneView;
/** <##> */
@property(nonatomic,weak)UILabel *phoneLbl;
/** <##> */
@property (nonatomic, weak) UIView *addressView;
/** <##> */
@property (nonatomic, weak)  UILabel *addressLbl;
/** <##> */
@property (nonatomic, weak) UIImageView *locationImg;
/** <##> */
@property (nonatomic, weak) UIScrollView *scroll;
/** <##> */
@property (nonatomic, weak) SDCycleScrollView *imageScrollView;
/** <##> */
@property (nonatomic, weak) UIView *splitView1;
/** <##> */
@property (nonatomic, weak) UIView *contentTopView;
/** <##> */
@property (nonatomic, weak) UILabel *titleLbl;
/** <##> */
@property (nonatomic, weak) UILabel *timeLbl;
/** <##> */
@property (nonatomic, weak) UILabel *browseCountLbl;
/** <##> */
@property (nonatomic, weak) UILabel *priceLbl;
/** <##> */
@property (nonatomic, weak) UIView *splitView2;
/** <##> */
@property (nonatomic, weak) UILabel *contentLbl;
/** <##> */
@property(nonatomic,strong)ContentDetailModel *model;
@end

@implementation ContentDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"efefef"];
    self.navigationItem.title = @"信息详情";
    
    UIButton *publickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [publickBtn setTitle:@"举报中介" forState:UIControlStateNormal];
    publickBtn.width = 70;
    publickBtn.height = 35;
    publickBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    publickBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [publickBtn addTarget:self action:@selector(reportClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:publickBtn];
    
    UIView *phoneView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.height - 45, self.view.width, 45)];
    phoneView.backgroundColor = [UIColor colorWithHexString:@"38424c"];
    [self.view addSubview:phoneView];
    self.phoneView = phoneView;
    
    UIButton *callBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [callBtn setImage:[UIImage imageNamed:@"content_call"] forState:UIControlStateNormal];
    callBtn.frame = CGRectMake(10, 0, 45, 45);
    callBtn.centerY = phoneView.height/2;
    [callBtn addTarget:self action:@selector(callClick) forControlEvents:UIControlEventTouchUpInside];
    [phoneView addSubview:callBtn];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(callBtn.right, 0, 1, phoneView.height)];
    line.backgroundColor = [UIColor whiteColor];
    [phoneView addSubview:line];
    
    UILabel *phoneLbl = [[UILabel alloc]initWithFrame:CGRectMake(line.right + 10, 0, self.view.width - line.right - 10 - 5, phoneView.height)];
    phoneLbl.textColor = [UIColor whiteColor];
    phoneLbl.font = [UIFont systemFontOfSize:14];
    phoneLbl.numberOfLines = 2;
    [phoneView addSubview:phoneLbl];
    self.phoneLbl = phoneLbl;
    
    UIView *addressView = [[UIView alloc]init];
    addressView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:addressView];
    self.addressView = addressView;
    
    UIImageView *locationImg = [[UIImageView alloc]init];
    locationImg.image = [UIImage imageNamed:@"location"];
    [addressView addSubview:locationImg];
    self.locationImg = locationImg;
    
    UILabel *addressLbl = [[UILabel alloc]init];
    addressLbl.textColor = [UIColor darkGrayColor];
    addressLbl.font = [UIFont systemFontOfSize:13];
    addressLbl.numberOfLines = 0;
    [addressView addSubview:addressLbl];
    self.addressLbl = addressLbl;
    
    UIScrollView *scroll = [[UIScrollView alloc]init];
    scroll.backgroundColor = [UIColor whiteColor];
    scroll.showsVerticalScrollIndicator = YES;
    self.scroll = scroll;
    
    //轮播图
    SDCycleScrollView *imageScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    imageScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    imageScrollView.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    imageScrollView.autoScrollTimeInterval = 4.0;
    [scroll addSubview:imageScrollView];
    self.imageScrollView = imageScrollView;
    [self.view addSubview:scroll];
    
    UIView *splitView1 = [[UIView alloc]init];
    splitView1.backgroundColor = [UIColor colorWithHexString:@"efefef"];
    [scroll addSubview:splitView1];
    self.splitView1 = splitView1;
    
    UIView *contentTopView = [[UIView alloc]init];
    [scroll addSubview:contentTopView];
    self.contentTopView = contentTopView;
    
    UILabel *titleLbl = [[UILabel alloc]init];
    titleLbl.font = [UIFont systemFontOfSize:14];
    titleLbl.numberOfLines = 0;
    [self.contentTopView addSubview:titleLbl];
    self.titleLbl = titleLbl;
    
    UILabel *timeLbl = [[UILabel alloc]init];
    timeLbl.textColor = [UIColor lightGrayColor];
    timeLbl.font = [UIFont systemFontOfSize:13];
    [self.contentTopView addSubview:timeLbl];
    self.timeLbl = timeLbl;
    
    UILabel *browseCountLbl = [[UILabel alloc]init];
    browseCountLbl.textColor = [UIColor lightGrayColor];
    browseCountLbl.font = [UIFont systemFontOfSize:13];
    [self.contentTopView addSubview:browseCountLbl];
    self.browseCountLbl = browseCountLbl;
    
    UILabel *priceLbl = [[UILabel alloc]init];
    priceLbl.textColor = [UIColor redColor];
    priceLbl.font = [UIFont systemFontOfSize:13];
    [self.contentTopView addSubview:priceLbl];
    self.priceLbl = priceLbl;
    
    UIView *splitView2 = [[UIView alloc]initWithFrame:CGRectMake(0, contentTopView.bottom, scroll.width, 8)];
    splitView2.backgroundColor = [UIColor colorWithHexString:@"efefef"];
    [scroll addSubview:splitView2];
    self.splitView2 = splitView2;
    
    UILabel *contentLbl = [[UILabel alloc]init];
    contentLbl.textColor = [UIColor darkGrayColor];
    contentLbl.font = [UIFont systemFontOfSize:14];
    contentLbl.numberOfLines = 0;
    [scroll addSubview:contentLbl];
    self.contentLbl = contentLbl;
    [self loadData];
}

- (void)loadData {

    NSDictionary *dict = @{@"pid":self.postId};
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    if (!error) {
        
        NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        [self openLoading];
        [ContentService getPostDetailById:jsonStr completion:^(ContentDetailModel *model) {
            [self closeLoading];
            self.model = model;
            self.phoneLbl.text = [NSString stringWithFormat:@"%@ : %@",model.contact,model.phone];
            NSMutableArray *photoArr = [NSMutableArray array];
            NSString *photoPath = [NSString stringWithFormat:@"%@/upload",BaseUrl];
            for (NSDictionary *dict in model.photoArray) {
                NSString *suffix = dict[@"attachment"][@"suffix"];
                NSString *photoName = [NSString stringWithFormat:@"%@.%@",dict[@"attachment"][@"name"],suffix];
                NSString *photoUrl = [NSString stringWithFormat:@"%@/%@",photoPath,photoName];
                [photoArr addObject:photoUrl];
            }
            
            if (photoArr.count > 0) {
                
                self.imageScrollView.frame = CGRectMake(0, 0, ScreenW, 240);
                self.imageScrollView.imageURLStringsGroup = photoArr;
                self.splitView1.frame = CGRectMake(0, self.imageScrollView.bottom, self.view.width, 8);
            }
            
            self.titleLbl.text = model.title;
            CGSize titleLblSize = [model.title boundingRectWithSize:CGSizeMake(self.view.width - 30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.titleLbl.font} context:nil].size;
            self.titleLbl.frame = CGRectMake(15, 10, self.view.width - 30, titleLblSize.height);
            
            self.timeLbl.text = model.pcreatetime;
            [self.timeLbl sizeToFit];
            self.timeLbl.frame = CGRectMake(self.titleLbl.x, self.titleLbl.bottom + 8, self.timeLbl.width, self.timeLbl.height);
            
            self.browseCountLbl.text = [NSString stringWithFormat:@"%@人浏览",model.readernum.length == 0 ? @"0" : model.readernum];
            [self.browseCountLbl sizeToFit];
            self.browseCountLbl.frame = CGRectMake(self.timeLbl.right + 5, self.timeLbl.y, self.browseCountLbl.width, self.browseCountLbl.height);
            
            self.priceLbl.text = [NSString stringWithFormat:@"¥ %@",model.price];
            [self.priceLbl sizeToFit];
            self.priceLbl.frame = CGRectMake(self.view.width - self.priceLbl.width - 10, self.timeLbl.y, self.priceLbl.width, self.priceLbl.height);
            
            self.contentTopView.frame = CGRectMake(0, self.splitView1.bottom, self.view.width, self.priceLbl.bottom+10);
            
            self.splitView2.frame = CGRectMake(0, self.contentTopView.bottom, self.view.width, 8);
            
            self.contentLbl.text = model.content;
            CGSize contentLblSize = [model.content boundingRectWithSize:CGSizeMake(self.titleLbl.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.contentLbl.font} context:nil].size;
            self.contentLbl.frame = CGRectMake(self.titleLbl.x, self.splitView2.bottom + 8, self.titleLbl.width , contentLblSize.height);
            
            self.locationImg.frame = CGRectMake(20, 0, 18, 18);

            self.addressLbl.text = model.address;
            CGFloat addressLblX = self.view.width - self.locationImg.right - 2 - 5;
            CGSize addressLblSize = [model.address boundingRectWithSize:CGSizeMake(addressLblX, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.addressLbl.font} context:nil].size;
            self.addressLbl.frame = CGRectMake(self.locationImg.right+2, 10, addressLblX, addressLblSize.height);
            self.locationImg.centerY = self.addressLbl.centerY;
            
            self.addressView.frame = CGRectMake(0, self.phoneView.y - self.addressLbl.bottom - 10, self.view.width, self.addressLbl.bottom + 10);
            
            self.scroll.frame = CGRectMake(0, 64, self.view.width, self.addressView.y - 8 - 64);
            self.scroll.contentSize = CGSizeMake(0, self.contentLbl.bottom + 5);
            
        }];
        
        
        [ContentService addPostReadNum:jsonStr];
    }

}

- (void)reportClick {

    if ([[CommUtils sharedInstance] fetchUserId].length > 0) {//已登录
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定举报吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        
    } else { //未登录
        
        LoginViewController *loginVC = [[LoginViewController alloc]init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
    
}

- (void)callClick {

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",self.model.phone]]];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        
        NSDictionary *dict = @{@"pid":self.model.pid,
                               @"userId":[[CommUtils sharedInstance] fetchUserId]?:@""
                               };
        [ContentService report:dict completion:^(NSString *str) {
            
            
        }];
    }
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    
    //启动图片浏览器
    HZPhotoBrowser *browserVc = [[HZPhotoBrowser alloc] init];
    browserVc.imageCount = cycleScrollView.imageURLStringsGroup.count; // 图片总数
    browserVc.currentImageIndex = index;
    browserVc.delegate = self;
    [browserVc show];
}

#pragma mark - photobrowser代理方法
- (UIImage *)photoBrowser:(HZPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    return [UIImage imageNamed:@"placeholder"];
}

- (NSURL *)photoBrowser:(HZPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSString *urlStr = self.imageScrollView.imageURLStringsGroup[index];
    return [NSURL URLWithString:urlStr];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
