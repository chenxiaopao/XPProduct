//
//  XPReplyView.m
//  XPProduct
//
//  Created by 陈思斌 on 2018/10/12.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import "XPReplyView.h"
#import "UIView+XPViewFrame.h"
@interface XPReplyView () <UITextFieldDelegate>
@property (nonatomic,weak) UITextField *commentTextF;
@end

@implementation XPReplyView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
   
    self.backgroundColor = [UIColor whiteColor];
    UITextField *commentTextF = [[UITextField alloc]initWithFrame:CGRectMake(10, 5, 300, self.height-10)];
    commentTextF.layer.cornerRadius = 10;
    commentTextF.layer.masksToBounds = YES;
    commentTextF.layer.borderColor = [[UIColor lightGrayColor] CGColor];;
    commentTextF.layer.borderWidth  = 1;
    commentTextF.leftViewMode = UITextFieldViewModeAlways;
    commentTextF.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 0)];
    
    
    commentTextF.placeholder = @"请输入内容";
    commentTextF.delegate = self;
    commentTextF.returnKeyType = UIReturnKeySend;
    
    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(commentTextF.frame)+10, commentTextF.y, XP_SCREEN_WIDTH-30-commentTextF.width, commentTextF.height)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.layer.cornerRadius = 10;
    cancelBtn.layer.masksToBounds = YES;
    cancelBtn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    cancelBtn.layer.borderWidth  = 1;
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.commentTextF = commentTextF;
    [self.commentTextF becomeFirstResponder];
    [self addSubview:commentTextF];
    [self addSubview:cancelBtn];
    
    
}

- (void)cancelBtnClick:(UIButton *)btn{
    [self.commentTextF resignFirstResponder];
}

- (void)keyboardWillShow:(NSNotification *)noti{
    NSDictionary *dict = noti.userInfo;
    
    CGRect endFrame = [[dict objectForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    CGFloat duration = [[dict objectForKey:@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
    __weak __typeof(self) weakSelf = self;
    [UIView animateWithDuration:duration animations:^{
        weakSelf.y = endFrame.origin.y-50;
    }];
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWillHide:(NSNotification *)noti{
    NSDictionary *dict = noti.userInfo;
    CGRect endFrame = [[dict objectForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    CGFloat duration = [[dict objectForKey:@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
    __weak __typeof(self) weakSelf = self;
    [UIView animateWithDuration:duration animations:^{
        weakSelf.y = endFrame.origin.y;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([textField.text isEqualToString:@""]){
        return NO;
    }else{
        if ([self.delegate respondsToSelector:@selector(replyViewDelegate:andTextField:)]){
            [self.delegate replyViewDelegate:self andTextField:self.commentTextF];
        }
        [self.commentTextF resignFirstResponder];
        return YES;
    }
    
}
@end
