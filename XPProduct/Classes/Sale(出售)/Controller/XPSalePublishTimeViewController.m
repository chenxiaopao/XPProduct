//
//  XPSalePublishTimeViewController.m
//  XPProduct
//
//  Created by 陈思斌 on 2018/9/28.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import "XPSalePublishTimeViewController.h"

@interface XPSalePublishTimeViewController ()
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *btn;

@end

@implementation XPSalePublishTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"供货时间";
    [self addGesture];
    [self setViewState:self.topView];
    [self setViewState:self.bottomView];
    [self setView:self.topView withColor:[UIColor greenColor]];
    [self setView:self.bottomView withColor:[UIColor lightGrayColor]];
    self.datePicker.alpha = 0;
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    self.datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
    self.datePicker.minimumDate = [NSDate new];
    [self setViewState:self.btn];
    
}
- (IBAction)btnClick:(UIButton *)sender {
    NSString *timeTitle;
    if (self.datePicker.alpha == 1){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
        timeTitle = [dateFormatter stringFromDate:self.datePicker.date];
    }else{
        timeTitle = @"现货";
    }
    if (self.timeBlock){
        self.timeBlock(timeTitle);
        [self.navigationController popViewControllerAnimated:NO];
        
    }
}

- (void)addGesture{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(topViewTap:)];
    [self.topView addGestureRecognizer:tap];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bottomViewTap:)];
    [self.bottomView addGestureRecognizer:tap1];
}

- (void)topViewTap:(UITapGestureRecognizer *)tap{
    [self setView:self.topView withColor:[UIColor greenColor]];
    [self setView:self.bottomView withColor:[UIColor lightGrayColor]];
    [UIView animateWithDuration:0.25 animations:^{
        self.datePicker.alpha = 0;
    }];
}
- (void)bottomViewTap:(UITapGestureRecognizer *)tap{
    [self setView:self.bottomView withColor:[UIColor greenColor]];
    [self setView:self.topView withColor:[UIColor lightGrayColor]];
    [UIView animateWithDuration:0.25 animations:^{
        self.datePicker.alpha = 1;
    }];
}
- (void)setViewState:(UIView *)view{
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 10;
    if (![view isKindOfClass:[UIButton class]])
    view.layer.borderWidth = 1;
}

- (void)setView:(UIView *)view withColor:(UIColor *)color{
    view.layer.borderColor = [color CGColor];
    for (UILabel *label in view.subviews) {
        label.textColor = color;
    }
}



@end
