//
//  XPSearchHistorySectionHeadView.m
//  XPProduct
//
//  Created by 陈思斌 on 2018/9/13.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import "XPSearchHistorySectionHeadView.h"

@implementation XPSearchHistorySectionHeadView


- (IBAction)deleteBtnClick:(UIButton *)sender {
    if(self.deleteBtn){
        self.deleteBtn();
    }
}

@end
