//
//  XPDetailCommentInfoTableViewCell.m
//  XPProduct
//
//  Created by 陈思斌 on 2018/10/8.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import "XPDetailCommentInfoTableViewCell.h"
#import "XPCommentModel.h"
#import "UIView+XPViewFrame.h"
#import "XPDetailSubCommentInfoTableView.h"
#import "Masonry.h"
@interface XPDetailCommentInfoTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *avatorView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@end


@implementation XPDetailCommentInfoTableViewCell
- (IBAction)replyBtnn:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(DetailCommentInfoTableViewCell:replyBtnClick:)]){
        [self.delegate DetailCommentInfoTableViewCell:self replyBtnClick:sender];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.commentLabel.numberOfLines = 0;
    self.commentLabel.lineBreakMode = NSLineBreakByWordWrapping;

}

- (void)setModel:(XPCommentModel *)model{
    
    _model = model;
    self.timeLabel.text = model.time;
    self.nameLabel.text = model.user_name;
    self.commentLabel.text = model.content;
    
    CGFloat width = XP_SCREEN_WIDTH - self.timeLabel.x-30;
    self.commentLabel.height = [self getHeightWithString:self.commentLabel.text andFont:[UIFont systemFontOfSize:17] andWidth:0];
    
    if (model.height > 0){
        
        CGRect frame = CGRectMake(0,0,1,1);
        XPDetailSubCommentInfoTableView *tableView = [[XPDetailSubCommentInfoTableView alloc]initWithFrame:frame style:UITableViewStylePlain andModelData:model.subModel];
        [self.contentView addSubview:tableView];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.timeLabel);
            make.top.equalTo(self.timeLabel.mas_bottom).offset(10);
            make.width.equalTo(@(width));
            make.bottom.equalTo(self.contentView).offset(-10);
            make.height.equalTo(@(model.height));
        }];
    }else{
        for (UIView  *view in self.contentView.subviews) {
            if ([view isKindOfClass:[UITableView class]]){
                [view removeFromSuperview];
            }
            [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.contentView).offset(-10);
            }];
        }
    }
}

- (CGFloat)getHeightWithString:(NSString *)str andFont:(UIFont *)font andWidth:(CGFloat)width{
    
    NSDictionary *dict = @{NSFontAttributeName:font};
    CGFloat height = [str boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size.height;
    return height;
}
@end
