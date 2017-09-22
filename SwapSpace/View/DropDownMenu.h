//
//  DropDownMenu.h
//  SwapSpace
//
//  Created by zzy on 30/08/2017.
//  Copyright © 2017 lanmao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger ,MenuState){
    Expand, //展开
    Shrink, //收起
};

@protocol DropDownMenuDelegate <NSObject>

- (void)menuClick:(NSString *)type;

@end

@interface DropDownMenu : UIView
/** <##> */
@property(nonatomic,strong)NSArray *dataArr;
@property (nonatomic,weak) id<DropDownMenuDelegate> delegate;
/** <##> */
@property(assign,nonatomic)MenuState menuState;
- (void)expand:(CGRect)frame;
- (void)shrink;
@end
