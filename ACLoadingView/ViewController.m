//
//  ViewController.m
//  ACLoadingView
//
//  Created by Apple on 13-7-22.
//  Copyright (c) 2013年 Albert Chu. All rights reserved.
//

#import "ViewController.h"

#import "ACLoadingView.h"

@interface ViewController () <ACLoadingViewCloseButtonDelegate>
{
    ACLoadingView *_theACLV;
}

@end

@implementation ViewController

- (IBAction)showACLVBtnPressed:(UIButton *)sender
{
    // 如果在导航视图控制器中，建议显示在 self.navigationController.view 上，因为关闭按钮的意义就在于禁用包括导航返回的操作。
    [_theACLV showACLoadingViewInView:self.view withText:@"正在加载..."];
}

#pragma mark - ACLoadingViewCloseButtonDelegate

- (void)closeButtonPressed:(UIButton *)closeButton
{
    DLog(@"取消按钮时相应操作，取消http请求等操作。");
}


#pragma mark - Life Cycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"ACLVSample";
    
    DLog(@"%f", self.view.frame.size.height);
    
    _theACLV = [[ACLoadingView alloc] init];
    _theACLV.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
