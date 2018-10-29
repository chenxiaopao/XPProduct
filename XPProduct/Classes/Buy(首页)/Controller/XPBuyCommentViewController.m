//
//  XPBuyCommentViewController.m
//  XPProduct
//
//  Created by 陈思斌 on 2018/10/8.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import "XPBuyCommentViewController.h"
#import "XPDetailCommentInfoTableViewCell.h"
#import "MJExtension.h"
#import "XPCommentModel.h"
#import "UIView+XPViewFrame.h"
#import "XPNavigationViewController.h"
@interface XPBuyCommentViewController () <XPDetailCommentInfoTableViewCellDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic,strong) NSMutableArray *commentDataArr;
@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,assign) CGFloat tableViewHeight;
@property (nonatomic,assign) CGFloat cellHeight;
@property (nonatomic,weak) UIView *replyView;
@property (nonatomic,weak) UIButton *cancelBtn;
@property (nonatomic,weak) UITextField *commentTextF;
@end

static NSString *const detailCommentInfoCellID = @"detailCommentInfoCellID";

@implementation XPBuyCommentViewController
- (NSMutableArray *)commentDataArr{
    if (_commentDataArr == nil){
        NSArray *arr = @[@{@"content":@"我送你是是是我送你是是是宿舍是我送你是是是宿舍是我送你是是是宿舍是宿舍是是是",
                           @"from_uname":@"小炮",
                           @"from_uid":@1,
                           @"timeStr":@"2018-10-05",
                           @"subModel": @[@{
                                              @"content":@"我送你是是我送你是是我送你是是我送你是是我送你是是我送你是是我送你是是我送你是是我送你是是我送你是送你是是我送你是是我送你是是我送你是是我送你是是我送你是是我送你是是我送你是是我送你是是我送你是是",
                                              @"from_uname":@"大头",
                                              @"to_uid":@1,
                                              @"timeStr":@"2018-10-06",
                                              @"from_uid":@22
                                              }]
                           },
                         @{@"content":@"我送你是是是宿舍是是是",
                           @"from_uname":@"大炮",
                           @"from_uid":@1,
                           @"timeStr":@"2018-10-05",
                           @"subModel": @[@{
                                              @"content":@"他天天他他他他他他他他他",
                                              @"from_uname":@"大头",
                                              @"to_uid":@1,
                                              @"timeStr":@"2018-10-06",
                                              @"from_uid":@2
                                              }]
                           },
                         @{@"content":@"我送你是是是宿送你是是是宿舍是是是送你是是是宿舍是是是送你是是是宿舍是是是送你是是是宿舍是是是送你是是是宿舍是是是送你是是是宿舍是是是送你是是是宿舍是是是送你是是是宿舍是是是送你是是是宿舍是是是舍是是是",
                           @"from_uname":@"大炮",
                           @"from_uid":@1,
                           @"timeStr":@"2018-10-05",
                           @"subModel": @[@{
                                              @"content":@"他天天送你是是是宿舍是是是送你是是是宿舍是是是送你是是是宿舍是是是送你是是是宿舍是是是送你是是是宿舍是是是送你是是是宿舍是是是送你是是是宿舍是是是送你是是是宿舍是是是他他他他他他他他他",
                                              @"from_uname":@"大头",
                                              @"to_uid":@1,
                                              @"timeStr":@"2018-10-06",
                                              @"from_uid":@2
                                              },@{
                                              @"content":@"他天天送你是是是宿舍是是是送你是是是宿舍是是是送你是是是宿舍是是是送你是是是宿舍是是是送你是是是宿舍是是是送你是是是宿舍是是是送你是是是宿舍是是是送你是是是宿舍是是是他他他他他他他他他",
                                              @"from_uname":@"大头",
                                              @"to_uid":@1,
                                              @"timeStr":@"2018-10-06",
                                              @"from_uid":@2
                                              }]
                           },
                         @{@"content":@"我送你是是是宿送你是是是宿舍是是是送你是是是宿舍是是是送你是是是宿舍是是是送你是是是宿舍是是是送你是是是宿舍是是是送你是是是宿舍是是是送你是是是宿舍是是是送你是是是宿舍是是是送你是是是宿舍是是是舍是是是",
                           @"from_uname":@"大炮",
                           @"from_uid":@1,
                           @"timeStr":@"2018-10-05"}
                         ,
                         
                         @{@"content":@"我送你是是是宿送你是是是宿舍是是是送你是是是宿舍是是是送你是是是宿舍你是是是宿舍是是是送你是是是宿舍是是是送你是是是宿舍是是是送你是是是宿舍是是是送你是是是宿舍是是是送你是是是宿舍是是是舍是是是",
                           @"from_uname":@"大炮",
                           @"from_uid":@1,
                           @"timeStr":@"2018-10-05"}
                         
                         ];
        _commentDataArr = [NSMutableArray arrayWithArray:([XPCommentModel mj_objectArrayWithKeyValuesArray:arr])];
    }
    return _commentDataArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"全部评论";

    [self setTableView];
    [self addReplyView];
    [self addNavView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)keyboardWillShow:(NSNotification *)noti{
    NSDictionary *dict = noti.userInfo;
    
    CGRect endFrame = [[dict objectForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    CGFloat duration = [[dict objectForKey:@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
    __weak __typeof(self) weakSelf = self;
    [UIView animateWithDuration:duration animations:^{
        weakSelf.replyView.y = endFrame.origin.y-50;
    }];
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWillHide:(NSNotification *)noti{
    NSDictionary *dict = noti.userInfo;
    CGRect endFrame = [[dict objectForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    CGFloat duration = [[dict objectForKey:@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
    __weak __typeof(self) weakSelf = self;
    [UIView animateWithDuration:duration animations:^{
        weakSelf.replyView.y = endFrame.origin.y;
    }];
}
- (void)addNavView{
    UIView *view = [[UIView alloc]init];
    view.frame = CGRectMake(0, 0, XP_SCREEN_WIDTH, XP_NavBar_Height);
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
}

- (void)addReplyView{
    UIView *replyView = [[UIView alloc]initWithFrame:CGRectMake(0, XP_SCREEN_HEIGHT, XP_SCREEN_WIDTH, 50)];
    replyView.backgroundColor = [UIColor whiteColor];
    UITextField *commentTextF = [[UITextField alloc]initWithFrame:CGRectMake(10, 5, 300, replyView.height-10)];
    commentTextF.layer.cornerRadius = 10;
    commentTextF.layer.masksToBounds = YES;
    commentTextF.layer.borderColor = [[UIColor lightGrayColor] CGColor];;
    commentTextF.layer.borderWidth  = 1;
    commentTextF.leftViewMode = UITextFieldViewModeAlways;
    commentTextF.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 0)];
    commentTextF.placeholder = @"请输入内容";
    commentTextF.delegate = self;
    commentTextF.returnKeyType = UIReturnKeySend;
    self.replyView = replyView;

    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(commentTextF.frame)+10, commentTextF.y, XP_SCREEN_WIDTH-30-commentTextF.width, commentTextF.height)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.layer.cornerRadius = 10;
    cancelBtn.layer.masksToBounds = YES;
    cancelBtn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    cancelBtn.layer.borderWidth  = 1;
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.commentTextF = commentTextF;
    self.cancelBtn = cancelBtn;
    [replyView addSubview:commentTextF];
    [replyView addSubview:cancelBtn];
    [self.view addSubview:replyView];

}

- (void)cancelBtnClick:(UIButton *)btn{
    [self.commentTextF resignFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}
- (void)setTableView{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, XP_SCREEN_WIDTH,XP_SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.view.backgroundColor = [UIColor redColor];
    [tableView registerNib:[UINib nibWithNibName:@"XPDetailCommentInfoTableViewCell" bundle:nil] forCellReuseIdentifier:detailCommentInfoCellID];
    tableView.dataSource = self;
    tableView.delegate = self;
    self.tableView = tableView;
    [self.view addSubview:tableView];
    
}
#pragma mark - UITableView 协议

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.commentDataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XPDetailCommentInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:detailCommentInfoCellID ];
    cell.delegate = self;
    cell.model = self.commentDataArr[indexPath.row];
    return cell;
}

#pragma mark - XPDetailCommentInfoTableViewCellDelegate
- (void)DetailCommentInfoTableViewCell:(XPDetailCommentInfoTableViewCell *)cell replyBtnClick:(UIButton *)btn{
    [self.commentTextF becomeFirstResponder];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.commentTextF resignFirstResponder];
    return YES;
}



@end
