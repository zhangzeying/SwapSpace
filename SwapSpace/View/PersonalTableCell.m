//
//  PersonalTableCell.m
//  SwapSpace
//
//  Created by zzy on 04/09/2017.
//  Copyright © 2017 lanmao. All rights reserved.
//

#import "PersonalTableCell.h"
#import "ContentModel.h"
#import "PersonalService.h"
#import "EditPostViewController.h"
#import "PersonalCenterViewController.h"
#import "CommUtils.h"
static NSString *ID = @"TableCell";

@interface PersonalTableCell ()<UIAlertViewDelegate>
@property (strong, nonatomic) UIImageView *imgView;
@property (strong, nonatomic) UILabel *titleLbl;
@property (strong, nonatomic) UILabel *addressLbl;
@property (strong, nonatomic) UILabel *priceLbl;
@property (strong, nonatomic) UILabel *browseCountLbl;
/** <##> */
@property(nonatomic,strong)UIView *line;
/** <##> */
@property(nonatomic,strong)UIButton *stickBtn;
/** <##> */
@property(nonatomic,strong)UIButton *editBtn;
/** <##> */
@property(nonatomic,strong)UIButton *deleteBtn;
/** <##> */
@property(nonatomic,strong)UIView *operatorBgView;
@end

@implementation PersonalTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.imgView = [[UIImageView alloc]init];
        [self addSubview:self.imgView];
        
        self.titleLbl = [[UILabel alloc]init];
        self.titleLbl.font = [UIFont systemFontOfSize:14];
        self.titleLbl.numberOfLines = 2;
        [self addSubview:self.titleLbl];
        
        self.addressLbl = [[UILabel alloc]init];
        self.addressLbl.textColor = [UIColor lightGrayColor];
        self.addressLbl.font = [UIFont systemFontOfSize:12];
        [self addSubview:self.addressLbl];
        
        self.priceLbl = [[UILabel alloc]init];
        self.priceLbl.textColor = [UIColor redColor];
        self.priceLbl.font = [UIFont systemFontOfSize:12];
        [self addSubview:self.priceLbl];
        
        self.browseCountLbl = [[UILabel alloc]init];
        self.browseCountLbl.textColor = [UIColor darkGrayColor];
        self.browseCountLbl.font = [UIFont systemFontOfSize:12];
        [self addSubview:self.browseCountLbl];
        
        self.operatorBgView = [[UIView alloc]init];
        [self addSubview:self.operatorBgView];
        
        self.line = [[UIView alloc]init];
        self.line.backgroundColor = kSeparatorLineColor;
        [self.operatorBgView addSubview:self.line];
        
        self.stickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.stickBtn.backgroundColor = [UIColor colorWithHexString:@"2dbaa6"];
        [self.stickBtn setTitle:@"置顶" forState:UIControlStateNormal];
        self.stickBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [self.stickBtn addTarget:self action:@selector(stickClick) forControlEvents:UIControlEventTouchUpInside];
        [self.operatorBgView addSubview:self.stickBtn];
        
        self.editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.editBtn.backgroundColor = [UIColor colorWithHexString:@"fbba91"];
        [self.editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        self.editBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [self.editBtn addTarget:self action:@selector(editClick) forControlEvents:UIControlEventTouchUpInside];
        [self.operatorBgView addSubview:self.editBtn];
        
        self.deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.deleteBtn.backgroundColor = [UIColor colorWithHexString:@"f41226"];
        [self.deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        self.deleteBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [self.deleteBtn addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
        [self.operatorBgView addSubview:self.deleteBtn];
    }
    
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    self.imgView.frame = CGRectMake(18, 0, 85, 70);
    self.imgView.centerY = (self.height - 40)/2;
    
    CGFloat titleLblX = self.imgView.right+8;
    self.titleLbl.frame = CGRectMake(self.imgView.right+8, self.imgView.y, self.width - titleLblX - 10, 34);
    
    [self.addressLbl sizeToFit];
    self.addressLbl.frame = CGRectMake(self.titleLbl.x, self.titleLbl.bottom + 4, self.titleLbl.width, self.addressLbl.height);
    
    [self.browseCountLbl sizeToFit];
    self.browseCountLbl.frame = CGRectMake(self.width - self.browseCountLbl.width - 10, self.addressLbl.bottom + 4, self.browseCountLbl.width, self.browseCountLbl.height);
    
    [self.priceLbl sizeToFit];
    self.priceLbl.frame = CGRectMake(self.addressLbl.x, self.addressLbl.bottom + 4, self.priceLbl.width, self.priceLbl.height);
    
    CGRect titleRect = [self.titleLbl.text boundingRectWithSize:CGSizeMake(self.titleLbl.width, MAXFLOAT)
                                                        options:NSStringDrawingUsesLineFragmentOrigin
                                                     attributes:@{NSFontAttributeName: self.titleLbl.font}
                                                        context:nil];
    if (titleRect.size.height == self.titleLbl.font.lineHeight) {
        
        self.titleLbl.height = titleRect.size.height;
        self.titleLbl.y = self.imgView.y + 5;
        self.addressLbl.y = self.titleLbl.bottom + 10;
        self.browseCountLbl.y = self.addressLbl.bottom + 10;
        self.priceLbl.y = self.browseCountLbl.y;
        
    }
    self.operatorBgView.frame = CGRectMake(0, self.imgView.bottom + 7, self.width, 40);
    self.line.frame = CGRectMake(0, 0, self.width, 1);
    self.stickBtn.frame = CGRectMake(self.width - 15 - 70, 5, 70, 30);
    self.editBtn.frame = CGRectMake(self.stickBtn.x - 70 - 5, 5, 70, 30);
    self.deleteBtn.frame = CGRectMake(self.editBtn.x - 5 - 70, 5, 70, 30);
    self.stickBtn.layer.cornerRadius = 4;
    self.editBtn.layer.cornerRadius = 4;
    self.deleteBtn.layer.cornerRadius = 4;
}

+ (instancetype)cellWithTableView:(UITableView *)table {
    
    PersonalTableCell *cell = [table dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        
        cell = [[PersonalTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)stickClick {

    
    NSMutableArray *array = [[CommUtils sharedInstance] getMyStickPostCache];
    if (array == nil) {
        array = [NSMutableArray array];
    }
    BOOL flag = NO;
    for (NSDictionary *dict in array) {
        
        if ([dict[@"PostId"] isEqualToString:self.model.pid]) {
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:[dict[@"Time"] longLongValue]];
            NSTimeInterval intervalTime = [[NSDate date] timeIntervalSinceDate:date];
            if (intervalTime > 60*60*24) {
                flag = YES;
                break;
            }
        }
    }
    if (!flag) {
        
        [SVProgressHUD showErrorWithStatus:@"每条每天只能置顶一次！"];
        return;
    }
    NSDictionary *dict = @{@"pid":self.model.pid};
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    if (!error) {
        
        [SVProgressHUD show];
        NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        [PersonalService stickPostById:jsonStr completion:^{
            
            NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
            long long currentTime = [[NSNumber numberWithDouble:time] longLongValue];
            NSDictionary *dict = @{@"PostId":self.model.pid,
                                   @"Time":[NSNumber numberWithLongLong:currentTime]
                                   };
            [array addObject:dict];
            
            NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:MyStickFileName];
            
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:array];
            [data writeToFile:path atomically:YES];
            
        }];
    }
}

- (void)editClick {
    
    if ([self.delegate respondsToSelector:@selector(editPost:)]) {
        
        [self.delegate editPost:self.model];
    }
}

- (void)deleteClick {
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定删除吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        
        NSDictionary *dict = @{@"pid":self.model.pid};
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
        if (!error) {
            
            [SVProgressHUD show];
            NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            [PersonalService deletePostById:jsonStr completion:^() {
                
                if ([self.delegate respondsToSelector:@selector(deletePostSuccess:)]) {
                    
                    [self.delegate deletePostSuccess:self.model];
                }
            }];
        }
    }
}

- (void)setModel:(ContentModel *)model {
    
    _model = model;
    self.titleLbl.text = model.title;
    self.addressLbl.text = model.address;
    self.browseCountLbl.text = [NSString stringWithFormat:@"%ld人浏览",(long)model.readernum];
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:model.url] placeholderImage:[UIImage imageNamed:@"placeholder"] options:SDWebImageRetryFailed|SDWebImageContinueInBackground];
    self.priceLbl.text = [NSString stringWithFormat:@"¥ %@",model.price];
}

- (void)setFrame:(CGRect)frame {

    frame.size.height -= 6;
    [super setFrame:frame];
}
@end
