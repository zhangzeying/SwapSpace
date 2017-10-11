//
//  ContentViewController.m
//  SwapSpace
//
//  Created by zzy on 28/08/2017.
//  Copyright © 2017 lanmao. All rights reserved.
//

#import "ContentViewController.h"
#import "PostViewController.h"
#import "DropDownButton.h"
#import "PostTableCell.h"
#import "CSCustomRefreshHeader.h"
#import "CSCustomRefreshFooter.h"
#import "ContentService.h"
#import "ContentDetailViewController.h"
#import "ContentModel.h"
#import "DropDownMenu.h"
#import "LocationManage.h"
#import "UITableView+EmptyData.h"
#import "CommUtils.h"
#import "SelectAreaMenu.h"
@interface ContentViewController ()<UITableViewDelegate, UITableViewDataSource, DropDownMenuDelegate, UISearchBarDelegate, SelectAreaMenuDelegate>
/** <##> */
@property (nonatomic, weak) UISearchBar *searchBar;
/** <##> */
@property (nonatomic, weak) DropDownButton *typeBtn;
/** <##> */
@property (nonatomic, weak) UITableView *table;
/** <##> */
@property(assign,nonatomic)NSInteger pageIndex;
/** <##> */
@property(nonatomic,strong)NSMutableArray *dataArr;
/**  */
@property(assign,nonatomic)NSInteger totalCount;
/** <##> */
@property(nonatomic,strong)DropDownMenu *dropDownMenu;
/** <##> */
@property(nonatomic,strong)SelectAreaMenu *areaMenu;
/** <##> */
@property (nonatomic, weak)DropDownButton *areaBtn;
/** <##> */
@property(nonatomic,copy)NSString *selectDistrict;
/** <##> */
@property(nonatomic,copy)NSString *selectStreet;
/** <##> */
@property(assign,nonatomic)BOOL isChooseAddress;
@end

@implementation ContentViewController

- (DropDownMenu *)dropDownMenu {
    
    if (_dropDownMenu == nil) {
        
        _dropDownMenu = [[DropDownMenu alloc]initWithFrame:self.view.frame];
        _dropDownMenu.dataArr = self.subTypeArr;
        _dropDownMenu.delegate = self;
    }
    
    return _dropDownMenu;
}

- (SelectAreaMenu *)areaMenu {
    
    if (_areaMenu == nil) {
        
        _areaMenu = [[SelectAreaMenu alloc]initWithFrame:self.view.frame];
        _areaMenu.delegate = self;
    }
    
    return _areaMenu;
}

- (NSMutableArray *)dataArr {
    
    if (_dataArr == nil) {
        
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"信息列表";
    UIButton *publickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [publickBtn setTitle:@"我要发布" forState:UIControlStateNormal];
    publickBtn.width = 70;
    publickBtn.height = 35;
    publickBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    publickBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [publickBtn addTarget:self action:@selector(postClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:publickBtn];
    
    [[UISearchBar appearance] setSearchFieldBackgroundImage:[UIImage imageNamed:@"search_bg"] forState:UIControlStateNormal];
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(8, 75, self.view.width - 16, 35)];
    searchBar.placeholder = @"搜索关键字或相关地址";
    searchBar.tintColor = [UIColor lightGrayColor];
    UIOffset offect = {5, 0};
    searchBar.searchTextPositionAdjustment = offect;
    UITextField *searchField = [searchBar valueForKey:@"_searchField"];
    [searchField setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
    [searchBar setBackgroundImage:[[UIImage alloc] init]];
    [self.view addSubview:searchBar];
    searchBar.delegate = self;
    self.searchBar = searchBar;
    
    DropDownButton *typeBtn = [DropDownButton buttonWithType:UIButtonTypeCustom];
    typeBtn.frame = CGRectMake(searchBar.right - 100 - 8, searchBar.bottom+8, 100, 30);
    [typeBtn setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
    [typeBtn setTitle:@"全部" forState:UIControlStateNormal];
    typeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [typeBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    typeBtn.layer.borderColor = [UIColor colorWithHexString:@"e6e6e6"].CGColor;
    typeBtn.layer.borderWidth = 0.8;
    typeBtn.layer.cornerRadius = 8;
    [typeBtn addTarget:self action:@selector(typeClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:typeBtn];
    self.typeBtn = typeBtn;
    
    
    DropDownButton *areaBtn = [DropDownButton buttonWithType:UIButtonTypeCustom];
    areaBtn.frame = CGRectMake(searchBar.x + 8, searchBar.bottom+8, typeBtn.x - 8 - searchBar.x - 8, 30);
    [areaBtn setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
    [areaBtn setTitle:@"选择区域" forState:UIControlStateNormal];
    [areaBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    areaBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    areaBtn.layer.borderColor = [UIColor colorWithHexString:@"e6e6e6"].CGColor;
    areaBtn.layer.borderWidth = 0.8;
    areaBtn.layer.cornerRadius = 8;
    [areaBtn addTarget:self action:@selector(areaClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:areaBtn];
    self.areaBtn = areaBtn;
    
    UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(0, areaBtn.bottom+8, self.view.width, self.view.height - areaBtn.bottom - 8) style:UITableViewStylePlain];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.delegate = self;
    table.dataSource = self;
    table.rowHeight = 115;
    [self.view addSubview:table];
    self.table = table;
    
    CSCustomRefreshHeader *header = [CSCustomRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    table.mj_header = header;
    
    table.mj_footer = [CSCustomRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    self.pageIndex = 1;
    
    [self loadData:YES showLoading:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reportSuccess:) name:@"ReportSuccess" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [self.searchBar resignFirstResponder];
}

- (void)reportSuccess:(NSNotification *)sender {
    
    ContentModel *model = (ContentModel *)sender.object;
    [self.dataArr removeObject:model];
    [self.table reloadData];
}

/**
 * 发帖
 */
- (void)postClick {
    
    PostViewController *postVC = [[PostViewController alloc]init];
    [self.navigationController pushViewController:postVC animated:YES];
}

- (void)loadData:(BOOL)isRefresh showLoading:(BOOL)showLoading {

    NSDictionary *dict;
    
    if (self.isChooseAddress) {//如果选择了地址
        
        dict = @{@"key":@"",
                 @"type":self.type,
                 @"type2":self.typeBtn.titleLabel.text,
                 @"pagesize":@10,
                 @"pageno":@(self.pageIndex),
                 @"city":[LocationManage sharedInstance].selectCity?:@"",
                 @"district":self.selectDistrict?:@"",
                 @"street":self.selectStreet?:@""
                 };
    } else {
    
        dict = @{@"key":self.searchBar.text?:@"",
                 @"type":self.type,
                 @"type2":self.typeBtn.titleLabel.text,
                 @"pagesize":@10,
                 @"pageno":@(self.pageIndex),
                 @"city":[LocationManage sharedInstance].selectCity?:@"",
                 @"district":@"",
                 @"street":@""
                 };
    }
    
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    if (!error) {
        
        NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        if (showLoading) {
            
            [SVProgressHUD showWithStatus:@"数据加载中..."];
        }
        [ContentService getPostList:jsonStr completion:^(NSMutableArray *dataArr,NSInteger total) {
            
            if (total != -1) {
                
                [SVProgressHUD dismiss];
                if (isRefresh) {
                    
                    [self.dataArr removeAllObjects];
                    self.dataArr = dataArr;
                    [self.table.mj_header endRefreshing];
                    
                } else {
                    
                    [self.dataArr addObjectsFromArray:dataArr];
                    [self.table.mj_footer endRefreshing];
                }
                self.totalCount = total;
            } else {
            
                if (isRefresh) {
                    [self.table.mj_header endRefreshing];
                } else {
                    self.pageIndex--;
                    [self.table.mj_footer endRefreshing];
                }
            }
            [self.table reloadData];
        }];
    }
}

- (void)typeClick {

    if (self.dropDownMenu.menuState == Shrink) {
        
        [self.view addSubview:self.dropDownMenu];
        [self.dropDownMenu expand:CGRectMake(self.typeBtn.x, self.typeBtn.bottom, self.typeBtn.width, 0)];
        
    } else {
    
        [self.dropDownMenu shrink];
    }
}

- (void)menuClick:(NSString *)type {

    self.pageIndex = 1;
    if (![type isEqualToString:self.typeBtn.titleLabel.text]) {
        
        [self.typeBtn setTitle:type forState:UIControlStateNormal];
        [self loadData:YES showLoading:YES];
    }
}

- (void)areaClick {

    if (self.areaMenu.menuState == Shrink) {
        
        [self.view addSubview:self.areaMenu];
        [self.areaMenu expand:CGRectMake(self.areaBtn.x, self.areaBtn.bottom, self.view.width, 0)];
        
    } else {
        
        [self.areaMenu shrink];
    }
}

- (void)areaMenuClick:(NSString *)selectArea {
    
    self.selectDistrict = @"";
    self.selectStreet = @"";
    if (selectArea.length>0) {
        self.isChooseAddress = YES;
        [self.areaBtn setTitle:selectArea forState:UIControlStateNormal];
        NSArray *array = [selectArea componentsSeparatedByString:@"-"];
        for (int i = 0; i < array.count; i++) {
            
            if (i == 0) {
                self.selectDistrict = [array[i] containsString:@"全"] ? @"" : array[i];
            } else if (i == 1) {
                self.selectStreet = [array[i] containsString:@"全"] ? @"" : array[i];
            }
        }
        self.pageIndex = 1;
        [self loadData:YES showLoading:YES];
    }
}

- (void)loadNewData {

    self.pageIndex = 1;
    [self loadData:YES showLoading:NO];
}

- (void)loadMoreData {

    self.pageIndex++;
    [self loadData:NO showLoading:NO];
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [self.searchBar resignFirstResponder];
    self.pageIndex = 1;
    self.isChooseAddress = NO;
    [self loadData:YES showLoading:YES];
}

/**
 * 判断footer是否隐藏，判断footer停止刷新时显示加载更多还是全部数据已加载完成"
 */
-(void)checkTableFooterStatus {
    
    self.table.mj_footer.hidden = self.dataArr.count == 0;
    if (self.dataArr.count == self.totalCount) { //数据全部加载完毕
        [self.table.mj_footer endRefreshingWithNoMoreData];
    } else {
        [self.table.mj_footer endRefreshing];
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    [self checkTableFooterStatus];
    [tableView tableViewDisplayWitMsg:@"暂无数据" ifNecessaryForRowCount:self.dataArr.count];
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    PostTableCell *cell = [PostTableCell cellWithTableView:tableView];
    cell.vc = self;
    cell.model = self.dataArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    ContentModel *model = self.dataArr[indexPath.row];
    ContentDetailViewController *contentDetailVC = [[ContentDetailViewController alloc]init];
    contentDetailVC.contentModel = model;
    [self.navigationController pushViewController:contentDetailVC animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    [self.searchBar resignFirstResponder];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    [self.searchBar resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
