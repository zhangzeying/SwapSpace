//
//  DropDownMenu.m
//  SwapSpace
//
//  Created by zzy on 30/08/2017.
//  Copyright © 2017 lanmao. All rights reserved.
//

#import "DropDownMenu.h"
static NSString *ID = @"TableCell";
@interface DropDownMenu ()<UITableViewDelegate, UITableViewDataSource>
/** <##> */
@property (nonatomic, weak) UITableView *table;
@end

@implementation DropDownMenu

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.menuState = Shrink;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setDataArr:(NSArray *)dataArr {

    _dataArr = dataArr;
}

- (void)expand:(CGRect)frame {

    UITableView *table = [[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain];
    table.tableFooterView = [UIView new];
    table.delegate = self;
    table.dataSource = self;
    table.rowHeight = 30;
    [self addSubview:table];
    table.backgroundColor = [UIColor colorWithHexString:@"f9f9f9"];
    self.table = table;
    
    [UIView animateWithDuration:0.1f animations:^{
        
        self.table.height = MIN(self.dataArr.count*30, self.height - table.y);
    }];
    
    self.menuState = Expand;
}

- (void)shrink {

    [UIView animateWithDuration:0.1f animations:^{
        
        self.table.height = 0;
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
    self.menuState = Shrink;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.textLabel.text = self.dataArr[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if ([self.delegate respondsToSelector:@selector(menuClick:)]) {
        
        [self.delegate menuClick:self.dataArr[indexPath.row]];
    }
    [self shrink];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    [self shrink];
}
@end
