//
//  SelectAreaMenu.h
//  SwapSpace
//
//  Created by zzy on 11/09/2017.
//  Copyright © 2017 lanmao. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger ,AreaMenuState){
    AreaExpand, //展开
    AreaShrink, //收起
};

@protocol SelectAreaMenuDelegate <NSObject>

- (void)areaMenuClick:(NSString *)selectArea;

@end

@interface SelectAreaMenu : UIView
/** <##> */
@property(assign,nonatomic)AreaMenuState menuState;
- (void)expand:(CGRect)frame;
- (void)shrink;
@property (nonatomic,weak) id<SelectAreaMenuDelegate> delegate;
@end
