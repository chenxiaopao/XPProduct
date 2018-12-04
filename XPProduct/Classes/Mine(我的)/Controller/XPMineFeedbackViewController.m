//
//  XPMineFeedbackViewController.m
//  XPProduct
//
//  Created by 陈思斌 on 2018/8/23.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import "XPMineFeedbackViewController.h"
#import "XPNetWorkTool.h"
#import "XPAlertTool.h"
#import <MBProgressHUD/MBProgressHUD.h>
@interface XPMineFeedbackViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *contactBtn;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;

@end

@implementation XPMineFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"意见和反馈";
    self.textView.delegate = self;
    self.textView.layer.borderWidth = 1;
    self.textView.layer.masksToBounds = YES;
    self.textView.layer.cornerRadius = 10;
    self.textView.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    self.submitBtn.layer.masksToBounds = YES;
    self.submitBtn.layer.cornerRadius = 10;
    
    //[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(transitionView:) name:UIKeyboardWillChangeFrameNotification object:nil];
}
/*
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}
- (void)transitionView:(NSNotification *)sender{
    NSLog(@"%@",[sender userInfo]);
//    UIKeyboardFrameBeginUserInfoKey
//    UIKeyboardFrameEndUserInfoKey
    NSDictionary *dict = [sender userInfo];
    NSValue *beginRectValue = [dict objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect beginRect = [beginRectValue CGRectValue];
    
    NSValue *endRectValue = [dict objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect endRect = [endRectValue CGRectValue];
    
    CGFloat deltaY = endRect.origin.y - beginRect.origin.y;
    NSLog(@"%f",deltaY);
    [UIView animateWithDuration:0.2 animations:^{
        
        self.view.transform = CGAffineTransformMakeTranslation(0,self.view.frame.origin.y+deltaY);
    }];
}
*/
- (IBAction)contactBtnClick:(UIButton *)sender {
    NSMutableString * phoneNumber=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"1001011"];
    UIWebView * webView = [[UIWebView alloc] init];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:phoneNumber]]];
    [self.view addSubview:webView];
    
}

- (IBAction)submitBtnClick:(UIButton *)sender {
    [self.textView resignFirstResponder];
    NSString *text = [self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"正在反馈中。。。";
    [[XPNetWorkTool shareTool]postFeedbackInfo:text andCallBack:^(NSInteger tag) {
        [hud removeFromSuperview];
        if (tag){
            [XPAlertTool showAlertWithSupeView:self.view andText:@"反馈成功"];
        }else{
            [XPAlertTool showAlertWithSupeView:self.view andText:@"反馈失败"];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    }];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.placeholderLabel.alpha = 1;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.textView resignFirstResponder];
}
#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    self.placeholderLabel.alpha = 0;
    if ([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
    }
    return YES;
}

@end
