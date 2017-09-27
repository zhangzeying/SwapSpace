//
//  PersonalCenterViewController.m
//  SwapSpace
//
//  Created by zzy on 03/09/2017.
//  Copyright © 2017 lanmao. All rights reserved.
//

#import "PersonalCenterViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "PersonalService.h"
#import "CommUtils.h"
#import "UserModel.h"
#import "PersonalTableCell.h"
#import "PostViewController.h"
#import "CSCustomRefreshHeader.h"
#import "CSCustomRefreshFooter.h"
#import "UITableView+EmptyData.h"
#import "EditPostViewController.h"
#import "ContentModel.h"
@interface PersonalCenterViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate, PersonalTableCellDelegate, EditPostDelegate>
/** <##> */
@property(nonatomic,strong)NSMutableArray *dataArr;
/** <##> */
@property(assign,nonatomic)NSInteger pageIndex;
/** <##> */
@property(assign,nonatomic)NSInteger totalCount;
/** <##> */
@property (nonatomic, weak)UITableView *table;
@end

@implementation PersonalCenterViewController

- (NSMutableArray *)dataArr {
    
    if (_dataArr == nil) {
        
        _dataArr = [NSMutableArray array];
    }
    
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    self.navigationItem.title = @"个人中心";
    UIButton *quitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [quitBtn setTitle:@"退出" forState:UIControlStateNormal];
    quitBtn.width = 70;
    quitBtn.height = 35;
    quitBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    quitBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [quitBtn addTarget:self action:@selector(quitBtn) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:quitBtn];
    UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 50) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.rowHeight = 130;
    table.backgroundColor = [UIColor clearColor];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:table];
    self.table = table;
    
    UIButton *postBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    postBtn.frame = CGRectMake(0, self.view.height - 50, self.view.width, 50);
    postBtn.backgroundColor = [UIColor colorWithHexString:@"3a424d"];
    postBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [postBtn setTitle:@"我要发布" forState:UIControlStateNormal];
    [postBtn addTarget:self action:@selector(postClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:postBtn];
    
    CSCustomRefreshHeader *header = [CSCustomRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    table.mj_header = header;
    
    table.mj_footer = [CSCustomRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    self.pageIndex = 1;
    [self loadData:YES showLoading:YES];
}

- (void)quitBtn {

    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定退出吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)postClick {

    PostViewController *postVC = [[PostViewController alloc]init];
    [self.navigationController pushViewController:postVC animated:YES];
}

- (void)loadData:(BOOL)isRefresh showLoading:(BOOL)showLoading {

    NSDictionary *dict = @{@"uid":[[CommUtils sharedInstance] fetchUserId],
                           @"pageno":@(self.pageIndex),
                           @"pagesize":@(10)
                           };
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    if (!error) {
        
        if (showLoading) {
            
            [SVProgressHUD showWithStatus:@"数据加载中..."];
        }
        NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        [PersonalService getMyPostList:jsonStr completion:^(NSMutableArray *dataArr,NSInteger total) {

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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (buttonIndex == 1) {
        
        [[CommUtils sharedInstance] removeUserId];
        [[CommUtils sharedInstance] removeUserName];
        [ShareSDK cancelAuthorize:SSDKPlatformSubTypeQZone];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    [self checkTableFooterStatus];
    [tableView tableViewDisplayWitMsg:@"暂无数据" ifNecessaryForRowCount:self.dataArr.count];
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    PersonalTableCell *cell = [PersonalTableCell cellWithTableView:tableView];
    ContentModel *model = self.dataArr[indexPath.row];
    model.indexPathRow = indexPath.row;
    cell.model = model;
    cell.delegate = self;
    return cell;
}

- (void)deletePostSuccess:(ContentModel *)model {

    [self.dataArr removeObject:model];
    [self.table reloadData];
}

- (void)editPost:(ContentModel *)model{

    EditPostViewController *editPostVC = [[EditPostViewController alloc]init];
    editPostVC.model = model;
    editPostVC.delegate = self;
    [self.navigationController pushViewController:editPostVC animated:YES];
}

- (void)editPostSuccess:(ContentModel *)model {

    [self.dataArr replaceObjectAtIndex:model.indexPathRow withObject:model];
    [self.table reloadData];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}
@end
