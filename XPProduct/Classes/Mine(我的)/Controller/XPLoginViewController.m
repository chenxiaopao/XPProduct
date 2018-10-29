//
//  XPLoginViewController.m
//  XPProduct
//
//  Created by 陈思斌 on 2018/8/25.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import "XPLoginViewController.h"
#import "XPMineViewController.h"
#import "XPMineNavigationViewController.h"
#import "XPTabBarController.h"
#import "XPNetWorkTool.h"
#import "MBProgressHUD.h"
#import "UIImage+XPOriginImage.h"
@interface XPLoginViewController () <UITextFieldDelegate>
@property (nonatomic,weak) UITextField *phoneTextField;
@property (nonatomic,weak) UITextField *autoCodeTextField;
@property (nonatomic,weak) UIButton *getAutoCodeBtn;
@property (nonatomic,weak) NSTimer *timer;
@end
static NSString *phoneNumber = @"";
static int captchaRandom = 0;
@implementation XPLoginViewController
int totalTime = 60;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    self.view.backgroundColor = [UIColor whiteColor];

}

- (void)closeBtnClick{
    [self.phoneTextField resignFirstResponder];
    [self.autoCodeTextField resignFirstResponder];
    XPTabBarController *tabBarVC = [XPTabBarController new];
    tabBarVC.selectedIndex = 0;
    self.view.window.rootViewController = tabBarVC;
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.phoneTextField resignFirstResponder];
    [self.autoCodeTextField resignFirstResponder];
}

- (void)setUI{
    [self addTopView];
    [self addMiddleView];
}

- (void)getAutoCodeBtnClick:(UIButton *)sender{
    captchaRandom = arc4random()%8999 + 1000;
    NSString *str = [NSString stringWithFormat:@"code=%d",captchaRandom];
    NSLog(@"%@",str);
//    [[XPNetWorkTool shareTool] getCaptchaWithPhone:self.phoneTextField.text andCaptcha:str andCallback:^(NSString *phone) {
//        phoneNumber = phone;
//    }];
    phoneNumber = self.phoneTextField.text;
    UIColor *color = [UIColor grayColor];
    [self setGetAutoCodeBtnState:NO andColor:color andBorderColor:color];
    [self.phoneTextField resignFirstResponder];
    [self.autoCodeTextField becomeFirstResponder];
    [sender setTitle:@"60s" forState:UIControlStateNormal];
//    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
//    [[NSRunLoop mainRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
//    self.timer = timer;
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(detachNewThread) object:nil];
    [thread start];
    
    
}
- (void)detachNewThread{
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop ] run];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.phoneTextField resignFirstResponder];
    [self.autoCodeTextField resignFirstResponder];
    [self removeTimer];
    
}

- (void)removeTimer{
    [self.timer invalidate];
    self.timer = nil;
    totalTime = 60;
}

-(void)countDown{
    NSString *timeStr = nil;
    totalTime -=1;
    if (totalTime==0){
        [self.timer invalidate];
        [self setGetAutoCodeBtnState:YES andColor:[UIColor blackColor] andBorderColor:[UIColor blackColor]];
        timeStr= @"获取验证码";
        totalTime = 60;
    }else{
        timeStr = [NSString stringWithFormat:@"%ds",totalTime];
    }
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.getAutoCodeBtn setTitle:timeStr forState:UIControlStateNormal];
    });
    
    
    
    
}

- (void)loginBtnClick:(UIButton*)sender{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if ([self.phoneTextField.text isEqualToString:@""]&&[self.autoCodeTextField.text isEqualToString:@""]){
        
        hud.label.text=@"手机号或验证码不能为空";
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [hud removeFromSuperview];
        });
    }else if ([self.phoneTextField.text isEqualToString:phoneNumber]&&[self.autoCodeTextField.text isEqualToString:[NSString stringWithFormat:@"%d",captchaRandom]]){
        [self loginSuccessAction];

    }else{
        
        hud.label.text=@"验证码错误";
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [hud removeFromSuperview];

        });
    }
    [self.phoneTextField resignFirstResponder];
    [self.autoCodeTextField resignFirstResponder];
}

- (void)loginSuccessAction{
    NSUserDefaults *defaults =  [NSUserDefaults standardUserDefaults];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"正在登陆中。。。";
    [defaults setBool:YES forKey:@"isLogin"];
    [defaults setObject:phoneNumber forKey:@"phone"];
    [defaults setObject:@"用户名" forKey:@"userName"];
//    UIImage *image = [UIImage imageNamed:@"avatar_user"];
//    [UIImage saveImageWithImage:image andName:@"avatar"];
    [defaults synchronize];
    __weak typeof(self) weakSelf = self;
    [[XPNetWorkTool shareTool] loadUserInfoWithFullParam:YES andIsAvatar:NO CallBack:^{
    
        [weakSelf removeTimer];
        [hud removeFromSuperview];
        XPTabBarController *tabBarVC = [XPTabBarController new];
        tabBarVC.selectedIndex = self.seletedIndex;
        weakSelf.view.window.rootViewController = tabBarVC;
        if(self.destVc){
            UIViewController * vc = [tabBarVC.viewControllers objectAtIndex:self.seletedIndex];
            vc = vc.childViewControllers[0];
            [vc.navigationController pushViewController:self.destVc animated:YES];
        }
    }];
}


-(void)addTopView{
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    UIImage *image = [UIImage imageNamed:@"icon_close"];
    UIImage *newImage = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [closeBtn setImage:newImage forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [closeBtn sizeToFit];
    [self.view addSubview:closeBtn];
    
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(XP_StatusBar_Height+10);
        make.left.equalTo(self.view.mas_left).offset(20);
    }];
   
}

-(void)addMiddleView{
    CGFloat leftMargin = 30;
    CGFloat getAutoCodeBtnWidth = 80;
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"客观，请登录！";
    titleLabel.font = [UIFont systemFontOfSize:25];
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@120);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    
    UITextField * phoneTextField = [[UITextField alloc]init];
    phoneTextField.placeholder = @"请输入手机号";
    phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    phoneTextField.borderStyle = UITextBorderStyleRoundedRect;
    phoneTextField.delegate =self;
    [self.view addSubview:phoneTextField];
    self.phoneTextField = phoneTextField;
    [phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(20);
        make.left.offset(leftMargin);
        make.width.equalTo(@(XP_SCREEN_WIDTH-leftMargin*2));
        make.height.equalTo(@40);
    }];
    
    UITextField *autoCodeTextField = [[UITextField alloc]init];
    autoCodeTextField.placeholder = @"请输入验证码";
    autoCodeTextField.borderStyle = UITextBorderStyleRoundedRect;
    autoCodeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:autoCodeTextField];
    self.autoCodeTextField = autoCodeTextField;
    [autoCodeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneTextField.mas_bottom).offset(20);
        make.left.height.equalTo(phoneTextField);
        make.width.equalTo(phoneTextField.mas_width).offset(-getAutoCodeBtnWidth);
    }];
    
    UIButton *getAutoCodeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [getAutoCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    getAutoCodeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [getAutoCodeBtn addTarget:self action:@selector(getAutoCodeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    getAutoCodeBtn.layer.masksToBounds = YES;
    getAutoCodeBtn.layer.cornerRadius = 5;
    getAutoCodeBtn.layer.borderWidth = 1;
    [self.view addSubview:getAutoCodeBtn];
    self.getAutoCodeBtn = getAutoCodeBtn;
    [self setGetAutoCodeBtnState:NO andColor:[UIColor grayColor] andBorderColor:[UIColor grayColor]];
    [getAutoCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(autoCodeTextField.mas_right);
        make.height.top.equalTo(autoCodeTextField);
        make.width.equalTo(@(getAutoCodeBtnWidth));
    }];
    
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [loginBtn setBackgroundColor: [UIColor greenColor]];
    [loginBtn addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    loginBtn.layer.masksToBounds = YES;
    loginBtn.layer.cornerRadius = 20;
    
    
    [self.view addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(autoCodeTextField.mas_bottom).offset(20);
        make.width.height.left.equalTo(phoneTextField);
    }];
}


#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSInteger length = textField.text.length-range.length+string.length;
    
//    NSLog(@"%@,%d,%d,%@",textField.text,range.location,range.length,string);
    if (length >11){
        return NO;
    }
    NSString *text = nil;
    if(string.length>0){
        //输入时， 获取文本框的所有字符(原字符串+输入的字符串)
        text = [NSString stringWithFormat:@"%@%@",textField.text,string];
    }else{
        //删除时，获取文本框的所有字符(range.location从第0个到最后一个)
        text = [textField.text substringToIndex:range.location];
    }
    if ([self isCellPhoneNumber:text]){
         [self setGetAutoCodeBtnState:YES andColor:[UIColor blackColor] andBorderColor:[UIColor blackColor]];
    }else{
        [self setGetAutoCodeBtnState:NO andColor:[UIColor grayColor] andBorderColor:[UIColor grayColor]];
    }
    return YES;
}
- (void)setGetAutoCodeBtnState:(BOOL)isEnabled andColor:(UIColor *)color andBorderColor: (UIColor *)borderColor{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.getAutoCodeBtn.enabled = isEnabled;
        [weakSelf.getAutoCodeBtn setTitleColor:color forState:UIControlStateNormal];
        weakSelf.getAutoCodeBtn.layer.borderColor = borderColor.CGColor;
    });
}
- (BOOL)isCellPhoneNumber:(NSString*)str{
    NSString *mobile = @"^1(3[0-9]|4[57]|5[0-35-9]|7[0135678]|8[0-9])\\d{8}$";
    
    NSPredicate *mobileRegExp = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",mobile];
    if([mobileRegExp evaluateWithObject:str]==YES){
        return YES;
    }else{
        return NO;
    }

}
@end
