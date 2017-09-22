//
//  SearchViewController.m
//  SwapSpace
//
//  Created by zzy on 27/08/2017.
//  Copyright © 2017 lanmao. All rights reserved.
//

#import "SearchViewController.h"
#import "PostTableCell.h"
#import "ContentDetailViewController.h"
#import "LocationManage.h"
#import "ContentService.h"
#import "ContentModel.h"
#import "CSCustomRefreshHeader.h"
#import "CSCustomRefreshFooter.h"
#import "UITableView+EmptyData.h"
@interface SearchViewController ()<UITableViewDelegate, UITableViewDataSource>
/** <##> */
@property (nonatomic, weak) UISearchBar *searchBar;
/** <##> */
@property (nonatomic, weak) UITableView *table;
/** <##> */
@property(assign,nonatomic)NSInteger pageIndex;
/** <##> */
@property(nonatomic,strong)NSMutableArray *dataArr;
/** <##> */
@property(assign,nonatomic)NSInteger totalCount;
@end

@implementation SearchViewController

- (NSMutableArray *)dataArr {
    
    if (_dataArr == nil) {
        
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationItem.title = @"信息搜索";
    [self initView];
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
    searchBar.text = self.searchContent;
    [self.view addSubview:searchBar];
    self.searchBar = searchBar;
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(searchBar.frame) + 8, self.view.width, 1)];
    line.backgroundColor = kSeparatorLineColor;
    [self.view addSubview:line];
    
    UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(line.frame) + 5, self.view.width, self.view.height - CGRectGetMaxY(line.frame) - 5) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.tableFooterView = [UIView new];
    table.rowHeight = 115;
    [self.view addSubview:table];
    self.table = table;
    
    
    CSCustomRefreshHeader *header = [CSCustomRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    table.mj_header = header;
    
    table.mj_footer = [CSCustomRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    self.pageIndex = 1;
    
    [self loadData:YES showLoading:YES];

}

- (void)loadData:(BOOL)isRefresh showLoading:(BOOL)showLoading {

    NSDictionary *dict = @{@"key":self.searchBar.text,
                           @"longitude":@([LocationManage sharedInstance].longitude),
                           @"latitude":@([LocationManage sharedInstance].latitude),
                           @"district":@"",
                           @"street":@"",
                           @"pageno":@(self.pageIndex),
                           @"pagesize":@(10)
                           };
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    if (!error) {
        
        NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        if (showLoading) {
            [SVProgressHUD showWithStatus:@"数据加载中..."];
        }
        [ContentService searchPostList:jsonStr completion:^(NSMutableArray *dataArr,NSInteger total) {
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

- (void)loadNewData {
    
    self.pageIndex = 1;
    [self loadData:YES showLoading:NO];
}

- (void)loadMoreData {
    
    self.pageIndex++;
    [self loadData:NO showLoading:NO];
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

-(void)viewDidLayoutSubviews
{
    if ([self.table respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.table setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self.table respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.table setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)searchClick {

    if (self.searchBar.text.length == 0) {
        
        [SVProgressHUD showErrorWithStatus:@"搜索关键字不能为空！"];
        return;
    }
    
    self.pageIndex = 1;
    [self loadData:YES showLoading:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    [self checkTableFooterStatus];
    [tableView tableViewDisplayWitMsg:@"暂无数据" ifNecessaryForRowCount:self.dataArr.count];
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    PostTableCell *cell = [PostTableCell cellWithTableView:tableView];
    cell.model = self.dataArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ContentModel *model = self.dataArr[indexPath.row];
    ContentDetailViewController *contentDetailVC = [[ContentDetailViewController alloc]init];
    contentDetailVC.postId = model.pid;
    [self.navigationController pushViewController:contentDetailVC animated:YES];
}

- (void)setSearchContent:(NSString *)searchContent {

    _searchContent = searchContent;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

@end
