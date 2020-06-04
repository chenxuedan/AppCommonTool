//
//  CXDViewController.m
//  AppCommonTool
//
//  Created by chenxuedan on 06/04/2020.
//  Copyright (c) 2020 chenxuedan. All rights reserved.
//

#import "CXDViewController.h"
#import "CXDNoticeView.h"
#import "CXDHeaderMacro.h"
#import "UIButton+CXDCategory.h"
#import "UIView+CXDAdd.h"

@interface CXDViewController ()

@end

@implementation CXDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = CXDBlueLineColor;
    button.frame = CGRectMake(80, 80, 100, 100);
    button.indexPath = [NSIndexPath indexPathForRow:10 inSection:0];
    [button addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)buttonClickAction:(UIButton *)sender {
    [CXDNoticeView showNoticeViewWithString:@"弹窗提示效果展示"];
    NSLog(@"弹窗提示效果展示");
    NSLog(@"%ld, %f",sender.indexPath.row, sender.y);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
