//
//  PostTableCell.m
//  SwapSpace
//
//  Created by zzy on 02/09/2017.
//  Copyright © 2017 lanmao. All rights reserved.
//

#import "PostTableCell.h"
#import "ContentModel.h"
#import "CommUtils.h"
#import "ContentService.h"
#import "LoginViewController.h"
static NSString *ID = @"TableCell";

@interface PostTableCell ()<UIAlertViewDelegate>
@property (strong, nonatomic) UIImageView *imgView;
@property (strong, nonatomic) UILabel *titleLbl;
@property (strong, nonatomic) UILabel *addressLbl;
@property (strong, nonatomic) UILabel *priceLbl;
@property (strong, nonatomic) UILabel *browseCountLbl;
/** <##> */
@property(nonatomic,strong)UIButton *reportBtn;
@end

@implementation PostTableCell

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
//        self.titleLbl.textColor = [UIColor darkGrayColor];
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
        
        self.reportBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.reportBtn setTitle:@"举报中介，一次删帖" forState:UIControlStateNormal];
        [self.reportBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        self.reportBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        self.reportBtn.layer.borderColor = [UIColor redColor].CGColor;
        self.reportBtn.layer.borderWidth = 0.5;
        self.reportBtn.layer.cornerRadius = 5;
        [self.reportBtn addTarget:self action:@selector(reportClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.reportBtn];
        
    }
    
    return self;
}

+ (instancetype)cellWithTableView:(UITableView *)table {
    
    PostTableCell *cell = [table dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        
        cell = [[PostTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)layoutSubviews {
 
    [super layoutSubviews];
    self.imgView.frame = CGRectMake(18, 0, 85, 70);
    self.imgView.centerY = (self.height - 36)/2;
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
    self.reportBtn.frame = CGRectMake(self.imgView.x, self.imgView.bottom + 12, 130, 20);
    
}

- (void)setModel:(ContentModel *)model {

    _model = model;
    self.titleLbl.text = model.title;
    self.addressLbl.text = model.address;
    self.browseCountLbl.text = [NSString stringWithFormat:@"%ld人浏览",(long)model.readernum];
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:model.url] placeholderImage:[UIImage imageNamed:@"placeholder"] options:SDWebImageRetryFailed|SDWebImageContinueInBackground];

    self.priceLbl.text = [NSString stringWithFormat:@"¥ %@",model.price];
}

- (void)reportClick {
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定举报吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        
        NSDictionary *dict = @{@"pid":self.model.pid };
                              
        [ContentService report:dict completion:^() {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ReportSuccess" object:self.model];
        }];
    }
}
@end
