//
//  EditPostViewController.m
//  SwapSpace
//
//  Created by zzy on 10/09/2017.
//  Copyright © 2017 lanmao. All rights reserved.
//

#import "EditPostViewController.h"
#import "SDCycleScrollView.h"
#import "ContentService.h"
#import "ContentModel.h"
#import "ContentDetailModel.h"
#import "CustomTextView.h"
#import "PersonalService.h"
@interface EditPostViewController ()<SDCycleScrollViewDelegate>
/** <##> */
@property(nonatomic,strong)UIScrollView *scroll;
/** <##> */
@property (nonatomic, strong) SDCycleScrollView *imageScrollView;
/** <##> */
@property(nonatomic,strong)UIView *centerBgView;
/** <##> */
@property(nonatomic,strong)UITextField *titleTxt;
/** <##> */
@property(nonatomic,strong)UIView *line1;
/** <##> */
@property(nonatomic,strong)UILabel *priceLbl;
/** <##> */
@property(nonatomic,strong)UITextField *priceTxt;
/** <##> */
@property(nonatomic,strong)UILabel *priceUnitLbl;
/** <##> */
@property(nonatomic,strong)UIView *line2;
/** <##> */
@property(nonatomic,strong)UILabel *nameLbl;
/** <##> */
@property(nonatomic,strong)UITextField *nameTxt;
/** <##> */
@property(nonatomic,strong)UIView *line3;
/** <##> */
@property(nonatomic,strong)UILabel *phoneLbl;
/** <##> */
@property(nonatomic,strong)UITextField *phoneTxt;
/** <##> */
@property(nonatomic,strong)UIView *line4;
/** <##> */
@property(nonatomic,strong)UILabel *addressLbl;
/** <##> */
@property(nonatomic,strong)UITextField *addressTxt;
/** <##> */
@property(nonatomic,strong)UIView *line5;
/** <##> */
@property(nonatomic,strong)UILabel *contentLbl;
/** <##> */
@property(nonatomic,strong)UIView *line6;
/** <##> */
@property(nonatomic,strong)CustomTextView *contentTxtView;
/** <##> */
@property(nonatomic,strong)ContentDetailModel *detailModel;
@end

@implementation EditPostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"信息编辑";
    UIButton *publickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [publickBtn setTitle:@"提交" forState:UIControlStateNormal];
    publickBtn.width = 70;
    publickBtn.height = 35;
    publickBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    publickBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [publickBtn addTarget:self action:@selector(editClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:publickBtn];
    
    [self initView];
    [self loadData];
}

- (void)initView {

    self.scroll = [[UIScrollView alloc]initWithFrame:self.view.frame];
    self.scroll.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    [self.view addSubview:self.scroll];
    
    //轮播图
    self.imageScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    self.imageScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    self.imageScrollView.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    self.imageScrollView.autoScrollTimeInterval = 4.0;
    [self.scroll addSubview:self.imageScrollView];
    
    self.centerBgView = [[UIView alloc]init];
    self.centerBgView.backgroundColor = [UIColor whiteColor];
    [self.scroll addSubview:self.centerBgView];
    
    self.titleTxt = [[UITextField alloc]init];
    self.titleTxt.placeholder = @"请输入标题";
    self.titleTxt.borderStyle = UITextBorderStyleNone;
    self.titleTxt.font = [UIFont systemFontOfSize:14];
    self.titleTxt.textColor = [UIColor darkGrayColor];
    self.titleTxt.clearButtonMode = UITextFieldViewModeAlways;
    [self.centerBgView addSubview:self.titleTxt];
    
    self.line1 = [[UIView alloc]init];
    self.line1.backgroundColor = kSeparatorLineColor;
    [self.centerBgView addSubview:self.line1];
    
    self.priceLbl = [[UILabel alloc]init];
    self.priceLbl.text = @"价格：";
    self.priceLbl.font = [UIFont systemFontOfSize:14];
    self.priceLbl.textColor = [UIColor darkGrayColor];
    [self.centerBgView addSubview:self.priceLbl];
    
    self.priceUnitLbl = [[UILabel alloc]init];
    self.priceUnitLbl.text = @"元";
    self.priceUnitLbl.font = [UIFont systemFontOfSize:14];
    self.priceUnitLbl.textColor = [UIColor redColor];
    [self.centerBgView addSubview:self.priceUnitLbl];
    
    self.priceTxt = [[UITextField alloc]init];
    self.priceTxt.placeholder = @"请输入价格";
    self.priceTxt.borderStyle = UITextBorderStyleNone;
    self.priceTxt.font = [UIFont systemFontOfSize:14];
    self.priceTxt.textColor = [UIColor darkGrayColor];
    self.phoneTxt.keyboardType = UIKeyboardTypeDecimalPad;
    self.priceTxt.clearButtonMode = UITextFieldViewModeAlways;
    [self.centerBgView addSubview:self.priceTxt];
    
    self.line2 = [[UIView alloc]init];
    self.line2.backgroundColor = kSeparatorLineColor;
    [self.centerBgView addSubview:self.line2];
    
    self.nameLbl = [[UILabel alloc]init];
    self.nameLbl.text = @"姓名：";
    self.nameLbl.font = [UIFont systemFontOfSize:14];
    self.nameLbl.textColor = [UIColor darkGrayColor];
    [self.centerBgView addSubview:self.nameLbl];
    
    self.nameTxt = [[UITextField alloc]init];
    self.nameTxt.placeholder = @"请输入姓名";
    self.nameTxt.borderStyle = UITextBorderStyleNone;
    self.nameTxt.font = [UIFont systemFontOfSize:14];
    self.nameTxt.textColor = [UIColor darkGrayColor];
    self.nameTxt.clearButtonMode = UITextFieldViewModeAlways;
    [self.centerBgView addSubview:self.nameTxt];
    
    self.line3 = [[UIView alloc]init];
    self.line3.backgroundColor = kSeparatorLineColor;
    [self.centerBgView addSubview:self.line3];
    
    self.phoneLbl = [[UILabel alloc]init];
    self.phoneLbl.text = @"电话：";
    self.phoneLbl.font = [UIFont systemFontOfSize:14];
    self.phoneLbl.textColor = [UIColor darkGrayColor];
    [self.centerBgView addSubview:self.phoneLbl];
    
    self.phoneTxt = [[UITextField alloc]init];
    self.phoneTxt.placeholder = @"请输入电话";
    self.phoneTxt.keyboardType = UIKeyboardTypePhonePad;
    self.phoneTxt.borderStyle = UITextBorderStyleNone;
    self.phoneTxt.font = [UIFont systemFontOfSize:14];
    self.phoneTxt.textColor = [UIColor darkGrayColor];
    self.phoneTxt.clearButtonMode = UITextFieldViewModeAlways;
    [self.centerBgView addSubview:self.phoneTxt];
    
    self.line4 = [[UIView alloc]init];
    self.line4.backgroundColor = kSeparatorLineColor;
    [self.centerBgView addSubview:self.line4];
    
    self.addressLbl = [[UILabel alloc]init];
    self.addressLbl.text = @"地址：";
    self.addressLbl.font = [UIFont systemFontOfSize:14];
    self.addressLbl.textColor = [UIColor darkGrayColor];
    [self.centerBgView addSubview:self.addressLbl];
    
    self.addressTxt = [[UITextField alloc]init];
    self.addressTxt.placeholder = @"请输入地址";
    self.addressTxt.borderStyle = UITextBorderStyleNone;
    self.addressTxt.font = [UIFont systemFontOfSize:14];
    self.addressTxt.textColor = [UIColor darkGrayColor];
    self.addressTxt.clearButtonMode = UITextFieldViewModeAlways;
    [self.centerBgView addSubview:self.addressTxt];
    
    self.line5 = [[UIView alloc]init];
    self.line5.backgroundColor = kSeparatorLineColor;
    [self.centerBgView addSubview:self.line5];

    self.contentLbl = [[UILabel alloc]init];
    self.contentLbl.text = @"填写内容";
    self.contentLbl.font = [UIFont systemFontOfSize:14];
    self.contentLbl.textColor = [UIColor darkGrayColor];
    [self.scroll addSubview:self.contentLbl];
    
    self.line6 = [[UIView alloc]init];
    self.line6.backgroundColor = kSeparatorLineColor;
    [self.scroll addSubview:self.line6];
    
    self.contentTxtView = [[CustomTextView alloc]init];
    self.contentTxtView.placeholder = @"至少10字，如房屋，请填写区域，户型，面积，等基本信息";
    self.contentTxtView.placeholderColor = [UIColor lightGrayColor];
    self.contentTxtView.textContainerInset = UIEdgeInsetsMake(12,10, 0, 0);
    self.contentTxtView.font = [UIFont systemFontOfSize:14];
    self.contentTxtView.textColor = [UIColor darkGrayColor];
    [self.scroll addSubview:self.contentTxtView];
    
}

- (void)loadData {
    
    NSDictionary *dict = @{@"pid":self.model.pid};
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    if (!error) {
        
        NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        [self openLoading];
        [ContentService getPostDetailById:jsonStr completion:^(ContentDetailModel *model) {
            [self closeLoading];
            self.detailModel = model;
            
            NSMutableArray *photoArr = [NSMutableArray array];
            NSString *photoPath = [NSString stringWithFormat:@"%@/upload",BaseUrl];
            for (NSDictionary *dict in model.photoArray) {
                NSString *suffix = dict[@"attachment"][@"suffix"];
                NSString *photoName = [NSString stringWithFormat:@"%@.%@",dict[@"attachment"][@"name"],suffix];
                NSString *photoUrl = [NSString stringWithFormat:@"%@/%@",photoPath,photoName];
                [photoArr addObject:photoUrl];
            }
            
            CGFloat centerBgViewY = 0;
            if (photoArr.count > 0) {
                
                self.imageScrollView.frame = CGRectMake(0, 0, ScreenW, 240);
                self.imageScrollView.imageURLStringsGroup = photoArr;
                centerBgViewY = self.imageScrollView.bottom+8;
            }
            
            self.titleTxt.frame = CGRectMake(12, 0, self.view.width - 12 - 10, 40);
            self.titleTxt.text = model.title;
            
            self.line1.frame = CGRectMake(0, self.titleTxt.bottom, self.view.width, 1);

            [self.priceLbl sizeToFit];
            self.priceLbl.frame = CGRectMake(12, self.line1.bottom, self.priceLbl.width, 40);
            
            [self.priceUnitLbl sizeToFit];
            self.priceUnitLbl.frame = CGRectMake(self.view.width - self.priceUnitLbl.width - 12, self.priceLbl.y, self.priceUnitLbl.width, 40);
            self.priceTxt.frame = CGRectMake(self.priceLbl.right+5, self.priceLbl.y, self.priceUnitLbl.x - 5 - self.priceLbl.right - 5, 40);
            self.priceTxt.text = model.price;
            self.line2.frame = CGRectMake(0, self.priceTxt.bottom, self.view.width, 1);
            
            [self.nameLbl sizeToFit];
            self.nameLbl.frame = CGRectMake(self.priceLbl.x, self.line2.bottom, self.nameLbl.width, 40);
            self.nameTxt.frame = CGRectMake(self.priceLbl.right+5, self.nameLbl.y, self.view.width - 12 - self.priceLbl.right - 5, 40);
            self.nameTxt.text = model.contact;
            self.line3.frame = CGRectMake(0, self.nameTxt.bottom, self.view.width, 1);
            
            [self.phoneLbl sizeToFit];
            self.phoneLbl.frame = CGRectMake(self.priceLbl.x, self.line3.bottom, self.phoneLbl.width, 40);
            self.phoneTxt.frame = CGRectMake(self.phoneLbl.right+5, self.phoneLbl.y, self.view.width - 12 - self.phoneLbl.right - 5, 40);
            self.phoneTxt.text = model.phone;
            self.line4.frame = CGRectMake(0, self.phoneTxt.bottom, self.view.width, 1);
            
            [self.addressLbl sizeToFit];
            self.addressLbl.frame = CGRectMake(self.priceLbl.x, self.line4.bottom, self.addressLbl.width, 40);
            self.addressTxt.frame = CGRectMake(self.addressLbl.right+5, self.addressLbl.y, self.view.width - 12 - self.addressLbl.right - 5, 40);
            self.addressTxt.text = model.address;
            
            self.line5.frame = CGRectMake(0, self.addressTxt.bottom, self.view.width, 1);
            self.centerBgView.frame = CGRectMake(0, centerBgViewY, self.view.width, 5*40+4);

            [self.contentLbl sizeToFit];
            self.contentLbl.frame = CGRectMake(self.priceLbl.x, self.centerBgView.bottom + 5, self.contentLbl.width, self.contentLbl.height);
            
            self.line6.frame = CGRectMake(0, self.contentLbl.bottom + 5, self.view.width, 1);
            
            self.contentTxtView.frame = CGRectMake(0, self.line6.bottom, self.view.width, 130);
            self.contentTxtView.text = model.content;
            self.scroll.contentSize = CGSizeMake(0, self.contentTxtView.bottom + 10);
        }];
    }
    
}


- (void)editClick {

    if (self.titleTxt.text.length == 0) {
        
        [SVProgressHUD showErrorWithStatus:@"标题不能为空！"];
        return;
    }
    
    if (self.priceTxt.text.length == 0) {
        
        [SVProgressHUD showErrorWithStatus:@"价格不能为空！"];
        return;
    }
    
    if (self.nameTxt.text.length == 0) {
        
        [SVProgressHUD showErrorWithStatus:@"姓名不能为空！"];
        return;
    }
    
    if (self.phoneTxt.text.length == 0) {
        
        [SVProgressHUD showErrorWithStatus:@"手机号不能为空！"];
        return;
    }
    
    if (self.addressTxt.text.length == 0) {
        
        [SVProgressHUD showErrorWithStatus:@"地址不能为空！"];
        return;
    }
    
    if (self.contentTxtView.text.length < 10) {
        
        [SVProgressHUD showErrorWithStatus:@"内容至少输入10字符！"];
        return;
    }
    
    NSDictionary *dict = @{@"pid":self.model.pid,
                           @"title":self.titleTxt.text,
                           @"price":self.priceTxt.text,
                           @"contact":self.nameTxt.text,
                           @"phone":self.phoneTxt.text,
                           @"address":self.addressTxt.text,
                           @"content":self.contentTxtView.text
                           };
    [SVProgressHUD show];
    
    self.model.title = self.titleTxt.text;
    self.model.price = self.priceTxt.text;
    self.model.address = self.addressTxt.text;

    [PersonalService editPostById:dict completion:^{
        
        if ([self.delegate respondsToSelector:@selector(editPostSuccess:)]) {
            
            [self.delegate editPostSuccess:self.model];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }];

}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
