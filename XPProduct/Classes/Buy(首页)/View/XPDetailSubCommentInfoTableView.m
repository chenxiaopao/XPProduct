//
//  XPDetailSubCommentInfoTableView.m
//  XPProduct
//
//  Created by 陈思斌 on 2018/10/9.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import "XPDetailSubCommentInfoTableView.h"
#import "XPDetailSubCommentInfoTableViewCell.h"
#import "XPCommentModel.h"
#import "MJExtension.h"
#import "UIView+XPViewFrame.h"
#import "Masonry.h"
@interface XPDetailSubCommentInfoTableView () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSArray<XPCommentModel *> *modelArr;
@end
static NSString *const detailSubCommentCellID = @"detailSubCommentCellID";
@implementation XPDetailSubCommentInfoTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style andModelData:(NSArray *)modelArr{
    if (self = [super initWithFrame:frame style:style]){
        self.modelArr = [XPCommentModel mj_objectArrayWithKeyValuesArray:modelArr];
        [self setUI];

    }
    return self;
}


- (void)setUI{
    self.scrollEnabled = NO;
    
    self.backgroundColor = [UIColor redColor];
    self.backgroundColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1];
    [self registerNib:[UINib nibWithNibName:@"XPDetailSubCommentInfoTableViewCell" bundle:nil] forCellReuseIdentifier:detailSubCommentCellID];
    self.delegate = self;
    self.dataSource = self;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XPDetailSubCommentInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:detailSubCommentCellID forIndexPath:indexPath];

    cell.model = self.modelArr[indexPath.row];
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.modelArr.count;
}


@end
