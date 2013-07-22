//
//  ACLoadingView.m
//  ACBaseProject
//
//  Created by Albert Chu on 13-7-22.
//  Copyright (c) 2013年 Albert Chu. All rights reserved.
//

#import "ACLoadingView.h"

#define ACLV_FontSize 16.f

#define ACLF_View_Height 50.f

@interface ACLoadingView ()
{
    /** 背景遮罩 */
    UIControl               *_mask;
    
    /** 菊花 */
    UIActivityIndicatorView *_theIndicatorAV;
    
    /** 文字标签 */
    UILabel                 *_textLabel;
    
    /** 分割线 */
    UIView                  *_separateLine;
    
    /** 关闭按钮 */
    UIButton                *_closeButton;
}

@end


@implementation ACLoadingView

#pragma mark - Action Method

- (void)closeBtnPressed:(UIButton *)closeBtn
{
    if (nil != _delegate && [_delegate respondsToSelector:@selector(closeButtonPressed:)])
    {
        [_delegate closeButtonPressed:closeBtn];
        // dismiss self
        [self dismissPopupView];
    }
}

- (void)showACLoadingViewInView:(UIView *)theView withText:(NSString *)theText
{
    // 字符串显示的宽度
    CGSize lableSize = [theText sizeWithFont:[UIFont systemFontOfSize:ACLV_FontSize]
                                 constrainedToSize:CGSizeMake(200.f, MAXFLOAT)
                                     lineBreakMode:LINE_BREAK_WORD_WRAP];
    
    
    //NSLog(@"W:%f-----H:%f", lableSize.width, lableSize.height);
    
    
    //  10   20   3    lableSize.width   15      50              |
    //  [ ]  *   []    _______________   [ ]      x              |>  高度 50
    //  间距 菊花  间距   字符显示长度      间距     关闭按钮         |
    
    // 得出 self 的 显示宽度
    CGFloat view_width = 10 + 20 + 8 + lableSize.width + 10 + ACLF_View_Height;
    [self setBounds:CGRectMake(0,
                               0,
                               view_width,
                               ACLF_View_Height)];
    
    //-- 旋转动画 -----------------------------------------------------------------------------------
    _theIndicatorAV.frame = CGRectMake(10.f,
                                       (ACLF_View_Height - 20) / 2.f,
                                       20.f,
                                       20.f);
    
    [_theIndicatorAV setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    
    //UIActivityIndicatorViewStyleWhiteLarge,
    //UIActivityIndicatorViewStyleWhite,
    //UIActivityIndicatorViewStyleGray,
    
    
    [_theIndicatorAV startAnimating];
    //---------------------------------------------------------------------------------------------;
    
    
    //-- 文字标签 -----------------------------------------------------------------------------------
    [_textLabel setFrame:CGRectMake(10 + 20 + 3.f,
                                    (ACLF_View_Height - lableSize.height) / 2,
                                    lableSize.width,
                                    lableSize.height)];
    
    [_textLabel setText:theText];
    [_textLabel setFont:[UIFont boldSystemFontOfSize:ACLV_FontSize]];
    //---------------------------------------------------------------------------------------------;
    
    
    // 白色分割线
    [_separateLine setFrame:CGRectMake(view_width - ACLF_View_Height - 1.f,
                                       0.f,
                                       1.f,
                                       ACLF_View_Height)];
    
    
    //-- 关闭按钮 -----------------------------------------------------------------------------------
    CGFloat closeBtn_w = ACLF_View_Height;
    CGFloat closeBtn_h = closeBtn_w;
    CGFloat closeBtn_x = view_width - ((ACLF_View_Height - closeBtn_w) / 2) - closeBtn_w;
    CGFloat closeBtn_y = 0.f;
    [_closeButton setFrame:CGRectMake(closeBtn_x,
                                      closeBtn_y,
                                      closeBtn_w,
                                      closeBtn_h)];
    //---------------------------------------------------------------------------------------------;
    
    
    //DLog(@"%f----%f", theView.frame.size.height, theView.bounds.size.height);
    //** 开始显示 ***********************************************************************************
    //[self setCenter:theView.center];
    
    [self setFrame:CGRectMake((theView.frame.size.width - view_width) / 2.f,
                              (theView.frame.size.height - ACLF_View_Height) / 2.f,
                              view_width,
                              ACLF_View_Height)];
    
    [theView addSubview:_mask];
    [theView addSubview:(UIView *)self];
    [theView bringSubviewToFront:self];
    
    [_mask setAlpha:.2f];
    [self setAlpha:1.f];
    
    [self popupAnimation:self duration:0.5];
}

- (void)dismissPopupView
{
    [_theIndicatorAV stopAnimating];
    
    [UIView animateWithDuration:0.25
                     animations:
                                 ^
                                 {
                                     [self setAlpha:0.f];
                                     
                                     [_mask setAlpha:0.f];
                                 }
                     completion:
                                 ^(BOOL finished)
                                 {
                                     [self removeFromSuperview];
                                     
                                     [_mask removeFromSuperview];
                                 }
     ];
}

- (void)popupAnimation:(UIView *)outView duration:(CFTimeInterval)duration
{
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    animation.duration = duration;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:@"easeInEaseOut"];
    
    NSMutableArray * values = [NSMutableArray array];
    
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    
    animation.values = values;
    
    [outView.layer addAnimation:animation forKey:nil];
}


#pragma mark - Life Cycle

- (id)init
{
    self = [super init];
    if (self)
    {
        // Initialization code
        
        //-- 遮罩 view -----------------------------------------------------------------------------
        _mask = [[UIControl alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        
        [_mask setBackgroundColor:[UIColor blackColor]];
        //[_mask addTarget:self action:@selector(maskTapped:) forControlEvents:UIControlEventTouchUpInside];
        [_mask setAlpha:0.f];
        //-----------------------------------------------------------------------------------------;
        
        [self setAlpha:0];
        
        // 背景
        [self setBackgroundColor:[UIColor blackColor]];
        
        // 菊花
        _theIndicatorAV = [[UIActivityIndicatorView alloc] init];
        [self addSubview:_theIndicatorAV];
        
        // 文本标签
        _textLabel = [[UILabel alloc] init];
        [_textLabel setBackgroundColor:[UIColor clearColor]];
        [_textLabel setTextColor:[UIColor whiteColor]];
        [_textLabel setTextAlignment:TextAlignmentCenter];
        [self addSubview:_textLabel];
        
        // 白色分割线
        _separateLine = [[UIView alloc] init];
        [_separateLine setBackgroundColor:[UIColor grayColor]];
        [self addSubview:_separateLine];
                
        // 关闭按钮
        _closeButton = [[UIButton alloc] init];
        [_closeButton setBackgroundColor:[UIColor clearColor]];
        //[_closeButton setBackgroundImage:PNGIMAGE(@"popup_text_btn_02") forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(closeBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_closeButton setTitle:@"x" forState:UIControlStateNormal];
        //[_closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //[_closeButton setTitleColor:[UIColor grayColor] forState:UIControlEventTouchUpInside];
        [self addSubview:_closeButton];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
