//
//  XPMineSettingTableViewController.m
//  XPProduct
//
//  Created by 陈思斌 on 2018/8/23.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import "XPMineSettingTableViewController.h"
#import "XPLoginViewController.h"
#import "MJExtension.h"
#import "MBProgressHUD.h"
#import "XPMineModel.h"
#import "XPClearCacheTool.h"
@interface XPMineSettingTableViewController ()
@property (nonatomic,strong) NSArray *settingCellDataArr;
@end

@implementation XPMineSettingTableViewController
- (NSArray *)settingCellDataArr{
    if (_settingCellDataArr==nil){
        NSString *filePath = [[NSBundle mainBundle]pathForResource:@"XPMIneSettingModelData" ofType:@"plist"];
        NSArray *dictArr = [NSArray arrayWithContentsOfFile:filePath];
        _settingCellDataArr = [XPMineModel mj_objectArrayWithKeyValuesArray:dictArr];
    }
    return _settingCellDataArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLogoutBtn];
    [self setAppVersionAndCache];
    self.title = @"设置";
    
    
    
}
- (void)setAppVersionAndCache{
    NSDictionary *infoDic = [[NSBundle mainBundle]infoDictionary];
    NSString *appVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    XPMineModel *lastModel = self.settingCellDataArr.lastObject;
    lastModel.subTitle = appVersion;
    
    XPMineModel *lastSecondModel =  self.settingCellDataArr[self.settingCellDataArr.count-2];
    NSString *cachePath =  [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];


    __block NSString *title ;
    __weak typeof(self) weakSelf = self;
    //创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    //创建操作
    NSBlockOperation *block = [NSBlockOperation blockOperationWithBlock:^{
        //耗时操作
        title =  [XPClearCacheTool getSizeWithPath:cachePath];
        [NSOperationQueue.mainQueue addOperationWithBlock:^{
            //刷新UI
            lastSecondModel.subTitle = title;
            [weakSelf.tableView reloadData];
        }];
    }];
    //添加操作
    [queue addOperation:block];
   
}

- (void)setLogoutBtn{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, XP_SCREEN_WIDTH, 60)];
    
    UIButton *logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    logoutBtn.frame = CGRectMake(10, 5, XP_SCREEN_WIDTH-20, 50);
    logoutBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    logoutBtn.layer.cornerRadius = 10;
    logoutBtn.layer.masksToBounds = YES;
    [logoutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [logoutBtn setBackgroundColor:[UIColor redColor]];
    [logoutBtn addTarget:self action:@selector(logoutBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:logoutBtn];
    
    self.tableView.tableFooterView = footView;


}

- (void)logoutBtnClick{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isLogin"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userName"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"avatar"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"phone"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"user_id"];
    [self.navigationController popToRootViewControllerAnimated:NO ];
    XPLoginViewController *vc = [[XPLoginViewController alloc]init];
    vc.seletedIndex = 3;
    [self presentViewController:vc animated:YES completion:nil];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.settingCellDataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    static NSString * ID = @"settingCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    XPMineModel *model = self.settingCellDataArr[indexPath.row];
    cell.imageView.image = [UIImage imageNamed: model.icon];
    
    cell.textLabel.text = model.title;
    cell.detailTextLabel.text = model.subTitle;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@",NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES));
    switch (indexPath.row) {
        case 0:
            [self clearCacheCellClick:tableView didSelectRowAtIndexPath:indexPath];
            break;
            
        case 1:
            [self appVersionCellClick:tableView didSelectRowAtIndexPath:indexPath];
            break;
    }
}
-(void)appVersionCellClick:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view  animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = @"需上传到App Store 才能做处理";
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [hud hideAnimated:YES];
    });
}
- (void)clearCacheCellClick:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    XPMineModel *model =self.settingCellDataArr[indexPath.row];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if ([model.subTitle isEqualToString:@"0.0KB"]){
        hud.label.text = @"缓存为0";
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
        });
    }else{
        hud.label.text = @"正在清理缓存";
        //进程间通信
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSString *cachePath =  [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
            [XPClearCacheTool clearCacheWithPath:cachePath];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                XPMineModel *lastSecondModel =  self.settingCellDataArr[self.settingCellDataArr.count-2];
                lastSecondModel.subTitle = @"0.0KB";
                [tableView reloadData];
                hud.label.text =@"清理完成";
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES];
                });
                
            });
        });
    }

}
@end

