//
//  UIButton+CXDCategory.h
//  AgentApplication
//
//  Created by 陈雪丹 on 2017/4/13.
//  Copyright © 2017年 cxd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (CXDCategory)

@property (nonatomic, strong)NSIndexPath *indexPath;

- (void)setLeftSideRadius:(CGFloat)radius;
- (void)setRightSideRadius:(CGFloat)radius;
- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;


//按钮点击区域
@property (nonatomic, assign)UIEdgeInsets cxd_hitTestEdgeInsets;
//BOOL类型 YES: 不允许点击   NO：允许点击  设置是否执行点击方法
@property (nonatomic, assign)BOOL cxd_isIgnoreEvent;
//按钮可点击时间间隔
@property (nonatomic, assign)NSTimeInterval cxd_timeInterval;



@end
