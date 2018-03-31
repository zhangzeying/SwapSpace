//
//  PostViewController.m
//  SwapSpace
//
//  Created by zzy on 27/08/2017.
//  Copyright © 2017 lanmao. All rights reserved.
//

#import "PostViewController.h"
#import "CustomButton.h"
#import "CustomTextView.h"
#import "DropDownButton.h"
#import "TZImagePickerController.h"
#import "PostPhotoWall.h"
#import "TLCityPickerController.h"
#import "LocationManage.h"
#import "DropDownMenu.h"
#import "Utils.h"
#import "CommUtils.h"
#import "ContentService.h"
@interface PostViewController ()<TZImagePickerControllerDelegate,PostPhotoWallDelegate, TLCityPickerDelegate,DropDownMenuDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeight;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIView *line1;
@property (weak, nonatomic) IBOutlet UIView *line2;
@property (weak, nonatomic) IBOutlet UIView *line3;
@property (weak, nonatomic) IBOutlet UIView *line4;
@property (weak, nonatomic) IBOutlet UIView *line5;
@property (weak, nonatomic) IBOutlet UIView *line6;
@property (weak, nonatomic) IBOutlet UIView *line7;
@property (weak, nonatomic) IBOutlet UIView *line8;
@property (weak, nonatomic) IBOutlet UIView *line9;
@property (weak, nonatomic) IBOutlet UIView *line10;
@property (weak, nonatomic) IBOutlet UIView *line11;

@property (weak, nonatomic) IBOutlet UITextField *titleTxt;
@property (weak, nonatomic) IBOutlet UITextField *priceTxt;
@property (weak, nonatomic) IBOutlet UITextField *nameTxt;
@property (weak, nonatomic) IBOutlet UITextField *phoneTxt;
@property (weak, nonatomic) IBOutlet CustomTextView *contentTextView;
@property (weak, nonatomic) IBOutlet UIButton *typeBtn;
@property (weak, nonatomic) IBOutlet UIButton *subTypeBtn;
@property (weak, nonatomic) IBOutlet UIButton *districtBtn;
@property (weak, nonatomic) IBOutlet UIButton *streetBtn;

@property (weak, nonatomic) IBOutlet UIView *cityBgView;

@property (weak, nonatomic) IBOutlet UILabel *cityLbl;

@property (weak, nonatomic) IBOutlet UITextField *addressTxt;

@property (weak, nonatomic) IBOutlet UIButton *addPhotoBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addPhotoBtnY;
@property (weak, nonatomic) IBOutlet CustomButton *postBtn;
/** <##> */
@property(nonatomic,strong)PostPhotoWall *photoWall;

/** <##> */
@property(assign,nonatomic)CGFloat scrollContentH;
/** <##> */
@property(assign,nonatomic)CGFloat addPhotoButtonY;
/** <##> */
@property(nonatomic,strong)NSMutableArray *selectedAssets;
/** <##> */
@property(nonatomic,strong)NSMutableArray *selectedPhotoArr;
/** <##> */
@property(nonatomic,strong)DropDownMenu *typeDropDownMenu;
/** <##> */
@property(nonatomic,strong)DropDownMenu *subTypeDropDownMenu;
/** <##> */
@property(nonatomic,strong)DropDownMenu *districtDropDownMenu;
/** <##> */
@property(nonatomic,strong)DropDownMenu *streetDropDownMenu;
/** <##> */
@property(copy,nonatomic)NSString *selectedType;
/** <##> */
@property(nonatomic,strong)DropDownMenu *selectedMenu;
/** <##> */
@property(nonatomic,copy)NSString *selectedDistrict;
/** <##> */
@property(nonatomic,copy)NSString *selectedStreet;
@end

@implementation PostViewController

- (DropDownMenu *)typeDropDownMenu {
    
    if (_typeDropDownMenu == nil) {
        
        _typeDropDownMenu = [[DropDownMenu alloc]initWithFrame:self.view.frame];
        _typeDropDownMenu.dataArr = @[@"房产",@"手机",@"招聘",@"家电",@"交通工具",@"二手交易"];
        _typeDropDownMenu.delegate = self;
    }
    
    return _typeDropDownMenu;
}

- (DropDownMenu *)subTypeDropDownMenu {
    
    if (_subTypeDropDownMenu == nil) {
        
        _subTypeDropDownMenu = [[DropDownMenu alloc]initWithFrame:self.view.frame];
        _subTypeDropDownMenu.delegate = self;
    }
    
    return _subTypeDropDownMenu;
}

- (DropDownMenu *)districtDropDownMenu {
    
    if (_districtDropDownMenu == nil) {
        
        _districtDropDownMenu = [[DropDownMenu alloc]initWithFrame:self.view.frame];
        _districtDropDownMenu.dataArr = [Utils getDistrictArr:NO];
        _districtDropDownMenu.delegate = self;
    }
    
    return _districtDropDownMenu;
}


- (DropDownMenu *)streetDropDownMenu {
    
    if (_streetDropDownMenu == nil) {
        
        _streetDropDownMenu = [[DropDownMenu alloc]initWithFrame:self.view.frame];
        _streetDropDownMenu.dataArr = @[@"房产",@"手机",@"招聘",@"家电",@"交通工具",@"二手交易"];
        _streetDropDownMenu.delegate = self;
    }
    
    return _streetDropDownMenu;
}


- (NSMutableArray *)selectedAssets {
    
    if (_selectedAssets == nil) {
        
        _selectedAssets = [NSMutableArray array];
    }
    
    return _selectedAssets;
}

- (NSMutableArray *)selectedPhotoArr {
    
    if (_selectedPhotoArr == nil) {
        
        _selectedPhotoArr = [NSMutableArray array];
    }
    
    return _selectedPhotoArr;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationItem.title = @"添加发布";
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    self.line1.backgroundColor = kSeparatorLineColor;
    self.line2.backgroundColor = kSeparatorLineColor;
    self.line3.backgroundColor = kSeparatorLineColor;
    self.line4.backgroundColor = kSeparatorLineColor;
    self.line5.backgroundColor = kSeparatorLineColor;
    self.line6.backgroundColor = kSeparatorLineColor;
    self.line7.backgroundColor = kSeparatorLineColor;
    self.line8.backgroundColor = kSeparatorLineColor;
    self.line9.backgroundColor = kSeparatorLineColor;
    self.line10.backgroundColor = kSeparatorLineColor;
    self.line11.backgroundColor = kSeparatorLineColor;
    
    self.addPhotoBtn.backgroundColor = [UIColor colorWithHexString:@"fbcb92"];
    
    self.postBtn.backgroundColor = NavgationBarColor;
    self.postBtn.centerOffset = 10;
    
    self.contentTextView.placeholder = @"至少10字，如房屋，请填写区域，户型，面积，等基本信息";
    self.contentTextView.placeholderColor = [UIColor lightGrayColor];
    self.contentTextView.textContainerInset = UIEdgeInsetsMake(12,10, 0, 0);
    
    self.typeBtn.layer.borderColor = [UIColor colorWithHexString:@"e6e6e6"].CGColor;
    self.typeBtn.layer.borderWidth = 0.8;
    self.typeBtn.layer.cornerRadius = 5;
    
    self.subTypeBtn.layer.borderColor = [UIColor colorWithHexString:@"e6e6e6"].CGColor;
    self.subTypeBtn.layer.borderWidth = 0.8;
    self.subTypeBtn.layer.cornerRadius = 5;
    
    self.districtBtn.layer.borderColor = [UIColor colorWithHexString:@"e6e6e6"].CGColor;
    self.districtBtn.layer.borderWidth = 0.8;
    self.districtBtn.layer.cornerRadius = 5;
    
    self.streetBtn.layer.borderColor = [UIColor colorWithHexString:@"e6e6e6"].CGColor;
    self.streetBtn.layer.borderWidth = 0.8;
    self.streetBtn.layer.cornerRadius = 5;
    
    self.addPhotoButtonY = self.addPhotoBtnY.constant;
    self.scrollContentH = self.viewHeight.constant;

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseCity)];
    tap.numberOfTapsRequired = 1;
    [self.cityBgView addGestureRecognizer:tap];
    
    self.cityLbl.text = [LocationManage sharedInstance].selectCity;
    self.addressTxt.text = [LocationManage sharedInstance].address;

    self.selectedType = @"房产";
}
- (IBAction)addPhotoClick:(id)sender {
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:12 delegate:self];
    imagePickerVc.selectedAssets = self.selectedAssets;
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
        [self layoutPhotoWall:photos];
        self.selectedPhotoArr = [NSMutableArray arrayWithArray:photos];
        self.selectedAssets = [NSMutableArray arrayWithArray:assets];
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

- (void)chooseCity {

    TLCityPickerController *cityPickerVC = [[TLCityPickerController alloc] init];
    [cityPickerVC setDelegate:self];
    cityPickerVC.locationCityName = [[LocationManage sharedInstance].locationCity stringByAppendingString:@"市"];
    //最近访问城市，如果不设置，将自动管理
    cityPickerVC.hotCitys = @[@"100010000", @"200010000", @"300210000", @"600010000", @"300110000"];
    
    [self.navigationController pushViewController:cityPickerVC animated:YES];
}

- (IBAction)typeClick:(id)sender {
    
    if (self.typeDropDownMenu.menuState == Shrink) {
        
        [self.view addSubview:self.typeDropDownMenu];
        [self.typeDropDownMenu expand:CGRectMake(60, 162-(self.scroll.contentOffset.y+64), 120, 0)];
        self.selectedMenu = self.typeDropDownMenu;
        
    } else {
        
        [self.typeDropDownMenu shrink];
    }
}

- (IBAction)subTypeClick:(id)sender {
    
    if (self.subTypeDropDownMenu.menuState == Shrink) {
        [self.view addSubview:self.subTypeDropDownMenu];
        if ([self.selectedType isEqualToString:@"房产"]) {
            self.subTypeDropDownMenu.dataArr = @[@"出租",@"出售"];
        } else if ([self.selectedType isEqualToString:@"手机"]) {
            
            self.subTypeDropDownMenu.dataArr = @[@"苹果",@"其他"];
        } else if ([self.selectedType isEqualToString:@"招聘"]) {
            
            self.subTypeDropDownMenu.dataArr = @[@"全职",@"兼职"];
        } else if ([self.selectedType isEqualToString:@"家电"]) {
            
            self.subTypeDropDownMenu.dataArr = @[@"冰箱",@"洗衣机",@"电视",@"其他"];
        } else if ([self.selectedType isEqualToString:@"交通工具"]) {
            
            self.subTypeDropDownMenu.dataArr = @[@"汽车",@"其他"];
        } else if ([self.selectedType isEqualToString:@"二手交易"]) {
            
            self.subTypeDropDownMenu.dataArr = @[@"二手交易"];
        }
        [self.subTypeDropDownMenu expand:CGRectMake(190, 162-(self.scroll.contentOffset.y+64), 120, 0)];
        self.selectedMenu = self.subTypeDropDownMenu;
        
    } else {
        
        [self.subTypeDropDownMenu shrink];
    }
}

- (IBAction)chooseDistrict:(id)sender {
    
    [self.view endEditing:YES];
    
    if (self.districtDropDownMenu.menuState == Shrink) {
        
        [self.view addSubview:self.districtDropDownMenu];
        [self.districtDropDownMenu expand:CGRectMake(60, 162-(self.scroll.contentOffset.y+64)+205, 120, 0)];
        self.selectedMenu = self.districtDropDownMenu;
        
    } else {
        
        [self.districtDropDownMenu shrink];
    }
    
}

- (IBAction)chooseStreet:(id)sender {
    
    [self.view endEditing:YES];
    
    if (self.streetDropDownMenu.menuState == Shrink) {
        
        if (self.selectedDistrict.length == 0) {
            
            [SVProgressHUD showErrorWithStatus:@"请先选择区域！"];
            return;
        }
        
        [self.view addSubview:self.streetDropDownMenu];
        NSArray *streetArr = [Utils getStreetArr:NO];
        self.streetDropDownMenu.dataArr = [streetArr objectAtIndex:[[Utils getDistrictArr:NO] indexOfObject:self.selectedDistrict]];
        [self.streetDropDownMenu expand:CGRectMake(60+130, 162-(self.scroll.contentOffset.y+64)+205, 120, 0)];
        self.selectedMenu = self.streetDropDownMenu;
        
    } else {
        
        [self.streetDropDownMenu shrink];
    }
}

- (IBAction)postClick:(id)sender {
    
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
    
    if (![Utils checkPhoneNum:self.phoneTxt.text]) {
        
        [SVProgressHUD showErrorWithStatus:@"手机号格式不正确！"];
        return;
    }
    
    if (self.selectedDistrict.length == 0) {
        
        [SVProgressHUD showErrorWithStatus:@"区域不能为空！"];
        return;
    }
    
    if (self.selectedStreet.length == 0) {
        
        [SVProgressHUD showErrorWithStatus:@"街道不能为空！"];
        return;
    }
    
    if (self.addressTxt.text.length == 0) {
        
        [SVProgressHUD showErrorWithStatus:@"地址不能为空！"];
        return;
    }
    
    if (self.contentTextView.text.length < 10) {
        
        [SVProgressHUD showErrorWithStatus:@"内容至少输入10字符！"];
        return;
    }
    
    if (self.selectedPhotoArr.count == 0) {
        
        [SVProgressHUD showErrorWithStatus:@"请至少上传一张图片！"];
        return;
    }
    
    NSDictionary *dict = @{@"uid":[[CommUtils sharedInstance] fetchUserId]?:@"",
                                 @"title":self.titleTxt.text,
                                 @"type":self.typeBtn.titleLabel.text,
                                 @"type2":self.subTypeBtn.titleLabel.text,
                                 @"price":self.priceTxt.text,
                                 @"contact":self.nameTxt.text,
                                 @"phone":self.phoneTxt.text,
                                 @"address":self.addressTxt.text,
                                 @"content":self.contentTextView.text,
                                 @"longitude":@([LocationManage sharedInstance].longitude),
                                 @"latitude":@([LocationManage sharedInstance].latitude),
                                 @"city":[LocationManage sharedInstance].selectCity,
                                 @"district":self.selectedDistrict,
                                 @"street":self.selectedStreet,
                                 @"from":@"IOS"
                                 };
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    if (!error) {
        
        NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
   
        [ContentService post:jsonStr photoArr:self.selectedPhotoArr completion:^() {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PostSuccess" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
    
    
}

- (void)layoutPhotoWall:(NSArray *)photoArr {

    if (photoArr.count>0) {
        
        if (self.photoWall) {
            
            [self.photoWall removeFromSuperview];
            self.photoWall = nil;
        }
        self.photoWall = [[PostPhotoWall alloc]initWithFrame:CGRectMake(0, self.contentTextView.bottom + 15, self.view.width, 0)];
        self.photoWall.delegate = self;
        [self.contentView addSubview:_photoWall];
        self.photoWall.photoArr = [NSMutableArray arrayWithArray:photoArr];
        self.addPhotoBtnY.constant = self.addPhotoButtonY + self.photoWall.height + 20;
        self.viewHeight.constant = self.scrollContentH+self.photoWall.height + 5;
        
    } else {
        
        self.addPhotoBtnY.constant = self.addPhotoButtonY;
        self.viewHeight.constant = self.scrollContentH;
    }
}

- (void)deletePhoto:(NSInteger)index {

    [self.selectedPhotoArr removeObjectAtIndex:index];
    [self.selectedAssets removeObjectAtIndex:index];
    if (self.selectedPhotoArr.count > 0) {
        
        [self layoutPhotoWall:self.selectedPhotoArr];
        
    } else {
    
        [self.photoWall removeFromSuperview];
        self.photoWall = nil;
        self.addPhotoBtnY.constant = self.addPhotoButtonY;
        self.viewHeight.constant = self.scrollContentH;
    }
    
}

- (void)menuClick:(NSString *)type {

    if (![type isEqualToString:self.typeBtn.titleLabel.text]) {
        
        if (self.selectedMenu == self.typeDropDownMenu) {
            
            [self.typeBtn setTitle:type forState:UIControlStateNormal];
            self.selectedType = type;
            if ([self.selectedType isEqualToString:@"房产"]) {
                [self.subTypeBtn setTitle:@"出租" forState:UIControlStateNormal];
            } else if ([self.selectedType isEqualToString:@"手机"]) {
                
                [self.subTypeBtn setTitle:@"苹果" forState:UIControlStateNormal];
                
            } else if ([self.selectedType isEqualToString:@"招聘"]) {
                
                [self.subTypeBtn setTitle:@"全职" forState:UIControlStateNormal];
                
            } else if ([self.selectedType isEqualToString:@"家电"]) {
                
                [self.subTypeBtn setTitle:@"冰箱" forState:UIControlStateNormal];
                
            } else if ([self.selectedType isEqualToString:@"交通工具"]) {
                
                [self.subTypeBtn setTitle:@"汽车" forState:UIControlStateNormal];
                
            } else if ([self.selectedType isEqualToString:@"二手交易"]) {
                
                [self.subTypeBtn setTitle:@"二手交易" forState:UIControlStateNormal];
            }
            
        } else if (self.selectedMenu == self.subTypeDropDownMenu) {
        
            [self.subTypeBtn setTitle:type forState:UIControlStateNormal];
            
        } else if (self.selectedMenu == self.districtDropDownMenu) {
            
            [self.districtBtn setTitle:type forState:UIControlStateNormal];
            self.selectedDistrict = type;
            
        } else if (self.selectedMenu == self.streetDropDownMenu) {
            
            [self.streetBtn setTitle:type forState:UIControlStateNormal];
            self.selectedStreet = type;
        }
    }
}

#pragma mark - TLCityPickerDelegate
- (void)cityPickerController:(TLCityPickerController *)cityPickerViewController didSelectCity:(TLCity *)city
{
    self.cityLbl.text = city.shortName;
    [cityPickerViewController.navigationController popViewControllerAnimated:YES];
}

- (void)cityPickerControllerDidCancel:(TLCityPickerController *)cityPickerViewController
{
    [cityPickerViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
