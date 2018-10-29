//
//  XPGraySearchView.m
//  XPProduct
//
//  Created by 陈思斌 on 2018/9/2.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import "XPGraySearchView.h"

#import <objc/runtime.h>

@interface XPGraySearchView ()<UISearchBarDelegate>
@property (nonatomic,weak) UISearchBar *searchBar;
@end
@implementation XPGraySearchView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}
-(void)setUpUI{
    
    UISearchBar *search = [[UISearchBar alloc]init];
    CGFloat padding = 2;
    search.frame = CGRectMake(padding, padding, self.width-padding*2, self.height-padding*2);
    [self addSubview:search];
    search.placeholder = @"请输入搜索内容";
    search.barTintColor = [UIColor grayColor];
    search.delegate = self;
    [search setValue:@"取消" forKey:@"_cancelButtonText"];
//    [search becomeFirstResponder];
    [search setTintColor:[UIColor blackColor]];
//    [search setShowsCancelButton:YES];
    self.searchBar = search;
    UITextField *textField = [search valueForKey:@"_searchField"];
    if (textField){
        textField.layer.masksToBounds = YES;
        textField.layer.cornerRadius = 10;
        textField.backgroundColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1];
    }
}
- (void)setPlaceholder:(NSString *)placeholder{
    _placeholder = placeholder;
    self.searchBar.placeholder = placeholder;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [self.searchBar setShowsCancelButton:YES animated:YES];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self.searchBar setShowsCancelButton:NO animated:YES];
    [self.searchBar resignFirstResponder];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    if ([self.delegate respondsToSelector:@selector(searchBarSearchBtnClick:)]){
        [self.delegate searchBarSearchBtnClick:searchBar];
    }
}

- (void)resignResponder{
    [self.searchBar resignFirstResponder];
    [self.searchBar setShowsCancelButton:NO animated:YES];
}
@end
