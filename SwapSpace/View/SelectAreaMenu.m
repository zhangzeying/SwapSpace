//
//  SelectAreaMenu.m
//  SwapSpace
//
//  Created by zzy on 11/09/2017.
//  Copyright © 2017 lanmao. All rights reserved.
//

#import "SelectAreaMenu.h"
#import "Utils.h"
static NSString *DistrictID = @"DistrictTableCell";
static NSString *StreetID = @"StreetTableCell";
@interface SelectAreaMenu ()<UITableViewDelegate, UITableViewDataSource>
/** <##> */
@property (nonatomic, strong) UITableView *districtTable;
/** <##> */
@property (nonatomic, strong) UITableView *streetTable;
/** <##> */
@property(nonatomic,strong)NSMutableArray *districtArr;
/** <##> */
@property(nonatomic,strong)NSMutableArray *streetArr;
/** <##> */
@property(assign,nonatomic)NSInteger selectedIndex;
@end

@implementation SelectAreaMenu

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.menuState = AreaShrink;
        self.backgroundColor = [UIColor clearColor];
        self.districtArr = [NSMutableArray arrayWithArray:[Utils getDistrictArr:YES]];
        self.streetArr = [NSMutableArray arrayWithArray:[Utils getStreetArr:YES].firstObject];
        self.selectedIndex = 1;
    }
    return self;
}

- (void)expand:(CGRect)frame {
    
    self.districtTable = [[UITableView alloc]initWithFrame:CGRectMake(0, frame.origin.y, frame.size.width/2, frame.size.height) style:UITableViewStylePlain];
    self.districtTable.tableFooterView = [UIView new];
    self.districtTable.delegate = self;
    self.districtTable.dataSource = self;
    self.districtTable.rowHeight = 45;
    [self addSubview:self.districtTable];
    self.districtTable.backgroundColor = [UIColor whiteColor];
    
    self.streetTable = [[UITableView alloc]initWithFrame:CGRectMake(frame.size.width/2, frame.origin.y, frame.size.width/2, frame.size.height) style:UITableViewStylePlain];
    self.streetTable.tableFooterView = [UIView new];
    self.streetTable.delegate = self;
    self.streetTable.dataSource = self;
    self.streetTable.rowHeight = 45;
    [self addSubview:self.streetTable];
    self.streetTable.backgroundColor = [UIColor colorWithHexString:@"d9d9d9"];
    
    [UIView animateWithDuration:0.1f animations:^{
        
        self.districtTable.height = self.height - self.districtTable.y;
        self.streetTable.height = self.height - self.streetTable.y;
    }];
    self.menuState = AreaExpand;
}

- (void)shrink {
    
    [UIView animateWithDuration:0.1f animations:^{
        
        self.districtTable.height = 0;
        self.streetTable.height = 0;
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
    self.menuState = AreaShrink;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == self.districtTable) {
        
        return self.districtArr.count;
        
    } else {
    
        return self.streetArr.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.districtTable) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DistrictID];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DistrictID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.textLabel.text = self.districtArr[indexPath.row];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        if (indexPath.row == self.selectedIndex) {
            
            cell.backgroundColor = [UIColor colorWithHexString:@"d9d9d9"];
            
        } else {
        
            cell.backgroundColor = [UIColor clearColor];
        }
        return cell;
        
    } else {
    
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:StreetID];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:StreetID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.text = self.streetArr[indexPath.row];
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.districtTable) {
        
        if (indexPath.row > 0) {
            
            self.selectedIndex = indexPath.row;
            [tableView reloadData];
            
            self.streetArr = [NSMutableArray arrayWithArray:[Utils getStreetArr:YES][indexPath.row-1]];
            [self.streetTable reloadData];
            
        } else {
        
            if ([self.delegate respondsToSelector:@selector(areaMenuClick:)]) {
                
                [self.delegate areaMenuClick:self.districtArr[0]];
            }
            [self shrink];
        }
        
    } else {
    
        NSString *area = [NSString stringWithFormat:@"%@-%@",self.districtArr[self.selectedIndex],self.streetArr[indexPath.row]];
        if ([self.delegate respondsToSelector:@selector(areaMenuClick:)]) {
            
            [self.delegate areaMenuClick:area];
        }
        [self shrink];
    }

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self shrink];
}

@end
