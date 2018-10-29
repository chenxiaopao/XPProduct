//
//  XPBuyPublishTableViewCell.m
//  XPProduct
//
//  Created by 陈思斌 on 2018/9/26.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import "XPBuyPublishTableViewCell.h"
#import "XPBuyPublishModel.h"
@interface XPBuyPublishTableViewCell () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end
@implementation XPBuyPublishTableViewCell

- (void)awakeFromNib{
    [super awakeFromNib];
    self.textField.delegate = self;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if (self.block){
        self.block();
    }
}

- (void)setData:(XPBuyPublishModel *)data{
    _data = data;
    self.titleLabel.text = data.titleName;
    self.textField.placeholder = data.subTitleName;
    self.textField.textColor = [UIColor greenColor];
    if (data.isSetText ){
        self.textField.text = data.subTitleName;
    }
    if (self.block){
        self.textField.userInteractionEnabled = NO;
    }
    

}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    self.data.subTitleName = textField.text;
}

@end
