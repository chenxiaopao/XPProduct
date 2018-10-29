//
//  XPSearchBar.m
//  XPProduct
//
//  Created by 陈思斌 on 2018/9/9.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import "XPSearchView.h"

@implementation XPSearchView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
    UISearchBar *searchBar = [[UISearchBar alloc]init];
    [self addSubview:searchBar];
    
    CGFloat padding = 2;
    searchBar.frame = CGRectMake(padding, padding, self.width-padding*2, self.height-padding*2);
    searchBar.userInteractionEnabled = NO;
    UITextField *textField = [searchBar valueForKey:@"_searchField"];
    if (textField){
        textField.layer.borderColor = [[UIColor greenColor] CGColor];
        textField.layer.borderWidth = 1;
        textField.layer.masksToBounds = YES;
        textField.layer.cornerRadius = 15;
        textField.text = @"搜索";
        textField.clearButtonMode = UITextFieldViewModeNever;
        textField.textColor = [UIColor greenColor];
    }
    
    
    UIImage *image = [UIImage imageNamed:@"icon_search"];
    UIImage *newImage = [image xp_imageWithColor:[UIColor greenColor]];
    [searchBar setImage:newImage forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
//    unsigned int count =0;
//    Ivar *ivars = class_copyIvarList([textField class], &count);
//    for(int i =0;i<count;i++){
//        NSLog(@"%@",[NSString stringWithFormat:@"%s", ivar_getName(ivars[i])]);
//    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [self addGestureRecognizer:tap];
    
    
}
- (void)tap:(UITapGestureRecognizer *)tap{
    if ([self.delegate respondsToSelector:@selector(searchView:)]){
        [self.delegate searchView:self];
    }
    
}
@end
