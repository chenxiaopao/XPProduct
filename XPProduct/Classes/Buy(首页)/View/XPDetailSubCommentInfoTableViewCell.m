//
//  XPDetailSubCommentInfoTableViewCell.m
//  XPProduct
//
//  Created by 陈思斌 on 2018/10/9.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import "XPDetailSubCommentInfoTableViewCell.h"
#import "XPCommentModel.h"
#import "UIView+XPViewFrame.h"
@interface XPDetailSubCommentInfoTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation XPDetailSubCommentInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.commentLabel.numberOfLines = 0;
    self.commentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.backgroundColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setModel:(XPCommentModel *)model{
    _model = model;
    self.commentLabel.text = model.content;
    self.nameLabel.text = model.user_name;
    [self setFirstLineIndent];
    NSMutableString *str =[ NSMutableString stringWithFormat:@"%@:%@",self.nameLabel.text,self.commentLabel.text];
    self.commentLabel.height = [self getHeightWithString:str andFont:[UIFont systemFontOfSize:17] andWidth:self.width];
    self.height = self.commentLabel.height;
    
   
}

- (void)setFirstLineIndent{
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    style.alignment = NSTextAlignmentLeft;
    [style setFirstLineHeadIndent:CGRectGetMaxX(self.nameLabel.frame)];
    NSAttributedString *attrText =  [[NSAttributedString alloc]initWithString:self.commentLabel.text attributes:@{NSParagraphStyleAttributeName:style}];
    self.commentLabel.attributedText = attrText;
}

- (CGFloat)getHeightWithString:(NSString *)str andFont:(UIFont *)font andWidth:(CGFloat)width{
    
    NSDictionary *dict = @{NSFontAttributeName:font};
    CGFloat height = [str boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size.height;
    return height;
}
@end
