//
//  MenuScreeningView.m
//  LinkageMenu
//
//  Created by mango on 2017/3/4.
//  Copyright © 2017年 mango. All rights reserved.
//

#import "MenuScreeningView.h"
#import "DropMenuView.h"
#import "UIButton+XPAdjustFont.h"

@interface MenuScreeningView ()<DropMenuViewDelegate>

@property (nonatomic, strong) UIButton *oneLinkageButton;
@property (nonatomic, strong) UIButton *threeLinkageButton;

@property (nonatomic, strong) DropMenuView *oneLinkageDropMenu;
@property (nonatomic, strong) DropMenuView *threeLinkageDropMenu;

@property (nonatomic, strong) NSArray *addressArr;
@property (nonatomic, strong) NSArray *sortsArr;

@property (nonatomic,strong) NSString *lastFullStr;

@end


@implementation MenuScreeningView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSLog(@"%@",NSStringFromCGRect(frame));
        self.oneLinkageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.oneLinkageButton.frame = CGRectMake(0, 0, XP_SCREEN_WIDTH/3, 40);
        [self setUpButton:self.oneLinkageButton withText:@"默认排序"];
        
        self.oneLinkageDropMenu = [[DropMenuView alloc] init];
        self.oneLinkageDropMenu.arrowView = self.oneLinkageButton.imageView;
        self.oneLinkageDropMenu.delegate = self;
        
        
        self.threeLinkageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.threeLinkageButton.frame = CGRectMake(XP_SCREEN_WIDTH/3, 0,  XP_SCREEN_WIDTH/3, 40);
        [self setUpButton:self.threeLinkageButton withText:@"地区"];
        
        self.threeLinkageDropMenu = [[DropMenuView alloc] init];
        self.threeLinkageDropMenu.arrowView = self.threeLinkageButton.imageView;
        self.threeLinkageDropMenu.delegate = self;
        

    }
    return self;
}



#pragma mark - 按钮点击推出菜单 (并且其他的菜单收起)
-(void)clickButton:(UIButton *)button{

    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideCategoryView" object:nil];
    [button setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    if (button == self.oneLinkageButton){
        
        [self.threeLinkageDropMenu dismiss];
        [self.threeLinkageButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.oneLinkageDropMenu creatDropView:self withShowTableNum:1 withData:self.sortsArr];
    
    }else if (button == self.threeLinkageButton){
        

        [self.oneLinkageDropMenu dismiss];
        [self.oneLinkageButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.threeLinkageDropMenu creatDropView:self withShowTableNum:3 withData:self.addressArr];
    }
}



#pragma mark - 筛选菜单消失
-(void)menuScreeningViewDismiss{
    
    [self.oneLinkageDropMenu dismiss];
    [self.threeLinkageDropMenu dismiss];
    [self.threeLinkageButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.oneLinkageButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}


#pragma mark - 协议实现
-(void)dropMenuView:(DropMenuView *)view didSelectName:(NSString *)str fullAddressName:(NSString *)fullStr{
    if ([fullStr containsString:str]){
        NSString *tempStr =  [fullStr substringWithRange:NSMakeRange(0, str.length)];
        if([tempStr containsString:str]){
            fullStr = str;
        }
    }
    if (![fullStr isEqualToString:@""]){
        self.lastFullStr = fullStr;
    }else{
        
        fullStr = self.lastFullStr;
    }
    BOOL isRefresh = false;
    BOOL temp = false, temp1 = false;
   if (view == self.oneLinkageDropMenu){
       temp = [self.oneLinkageButton.titleLabel.text isEqualToString:str] ? NO :YES;
       [self.oneLinkageButton setTitle:str forState:UIControlStateNormal];
       [self buttonEdgeInsets:self.oneLinkageButton];
       [self.oneLinkageButton adjustBtnFont];
    }else if (view == self.threeLinkageDropMenu){
        temp1 = [self.threeLinkageButton.titleLabel.text isEqualToString:str] ? NO :YES;
        [self.threeLinkageButton setTitle:str forState:UIControlStateNormal];
        [self buttonEdgeInsets:self.threeLinkageButton];
        [self.threeLinkageButton adjustBtnFont];
    }
    
    if ([self.delegate respondsToSelector:@selector(menuScreeningView:didSeletedAddressTitle:fullAddressTitle:sortTitle: isRefresh:)]){
        if (temp || temp1){
            isRefresh = YES;
        }
       
        
        [self.delegate menuScreeningView:self didSeletedAddressTitle:self.threeLinkageButton.titleLabel.text fullAddressTitle:fullStr sortTitle:self.oneLinkageButton.titleLabel.text isRefresh:isRefresh];
    }
}

#pragma mark - 设置Button
-(void)setUpButton:(UIButton *)button withText:(NSString *)str{
    
    [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    [button setTitle:str forState:UIControlStateNormal];
    button.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"downArrow"] forState:UIControlStateNormal];
    [self buttonEdgeInsets:button];
    UIView *verticalLine = [[UIView alloc]init];
    verticalLine.backgroundColor = [UIColor lightGrayColor];
    [button addSubview:verticalLine];
    verticalLine.frame = CGRectMake(button.frame.size.width - 1, 10, 1, 20);
    [button adjustBtnFont];
}


-(void)buttonEdgeInsets:(UIButton *)button{
    
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, -button.imageView.bounds.size.width + 2, 0, button.imageView.bounds.size.width + 10)];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, button.titleLabel.bounds.size.width + 10, 0, -button.titleLabel.bounds.size.width + 2)];
    
}




#pragma mark - 懒加载
-(NSArray *)addressArr{

    if (_addressArr == nil) {
        
        NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"address.plist" ofType:nil]];
        
        _addressArr = dic[@"address"];
    }
    
    return _addressArr;
}

-(NSArray *)sortsArr{

    if (_sortsArr == nil) {
        
        _sortsArr =  [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sorts.plist" ofType:nil]];
    }
    
    return _sortsArr;
}


@end
