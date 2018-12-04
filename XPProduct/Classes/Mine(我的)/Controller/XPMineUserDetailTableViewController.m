//
//  XPMineUserDetailTableViewController.m
//  XPProduct
//
//  Created by 陈思斌 on 2018/10/11.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import "XPMineUserDetailTableViewController.h"
#import "XPMineUserDetailImageTableViewCell.h"
#import "XPMineUserDetailSubtitleTableViewCell.h"
#import "XPMineNavigationViewController.h"
#import "XPMineUserCardViewController.h"
#import "MJExtension.h"
#import "XPMineModel.h"
#import "UIImage+XPOriginImage.h"
#import "XPReplyView.h"
#import "XPNetWorkTool.h"
#import "XPAlertTool.h"
#import <MBProgressHUD/MBProgressHUD.h>
@interface XPMineUserDetailTableViewController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate,XPReplyViewDelegate>
@property (nonatomic,strong) NSArray *modelArr;
@property (nonatomic,strong) UIImagePickerController *pickerController;
@end

static NSString *const userImageCellID  = @"userImageCellID";
static NSString *const userSubtitleCellID  = @"userSubtitleCellID";

@implementation XPMineUserDetailTableViewController

- (instancetype)initWithStyle:(UITableViewStyle)style{
    return [super initWithStyle:UITableViewStyleGrouped];
}
- (UIImagePickerController *)pickerController{
    if (_pickerController == nil){
        UIImagePickerController * pickerController = [[UIImagePickerController alloc]init];
        pickerController.delegate = self;
        pickerController.allowsEditing =YES;
        _pickerController = pickerController;
    }
    return _pickerController;
}

- (NSArray *)modelArr{
    if (_modelArr==nil){
        NSString *path =  [[NSBundle mainBundle]pathForResource:@"XPMineUserDetailData" ofType:@"plist"];
        NSArray *arr = [NSArray arrayWithContentsOfFile:path];
        _modelArr = [XPMineModel mj_objectArrayWithKeyValuesArray:arr];
    }
    return  _modelArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人信息";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"XPMineUserDetailImageTableViewCell" bundle:nil] forCellReuseIdentifier:userImageCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"XPMineUserDetailSubtitleTableViewCell" bundle:nil] forCellReuseIdentifier:userSubtitleCellID];
    
    self.tableView.tableFooterView = [UIView new];
}
- (void)viewWillAppear:(BOOL)animated{
    [super  viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.modelArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0){
        XPMineUserDetailImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:userImageCellID forIndexPath:indexPath];
        cell.model = self.modelArr[indexPath.row];
        
        return cell;
    }else{
        XPMineUserDetailSubtitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:userSubtitleCellID forIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.model = self.modelArr[indexPath.row];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath.row == 0 ? 60 : 50;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
            [self showAlertSheet];
            break;
        }
        case 1:
        {
            XPReplyView *replyView = [[XPReplyView alloc]initWithFrame:CGRectMake(0, XP_SCREEN_HEIGHT, XP_SCREEN_WIDTH, 50)];
            replyView.delegate = self;
            UIWindow *window =  [UIApplication sharedApplication].keyWindow;
            [window addSubview:replyView];
            break;
        }
        case 2:
        {
            
            break;
        }
        case 3:
        {
            NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
            NSString *avatar = [[NSUserDefaults standardUserDefaults] objectForKey:@"avatar"];
            
            NSString *user_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
            
            XPMineUserCardViewController *vc = [[XPMineUserCardViewController alloc]initWithName:userName andAvatar:avatar andUser_id:[user_id integerValue]];
            
            [self.navigationController pushViewController:vc animated:NO];
            break;
        }
    }
}

- (void)showAlertSheet{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"切换照片" message:@"选择方式" preferredStyle:UIAlertControllerStyleActionSheet];
    __weak __typeof(self) weakSelf = self;
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        weakSelf.pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [weakSelf presentViewController:weakSelf.pickerController animated:YES completion:nil];
    }];
    
    UIAlertAction *album = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        weakSelf.pickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        [weakSelf presentViewController:weakSelf.pickerController animated:YES completion:nil];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:camera];
    [alert addAction: album];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"上传图片中。。。";
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    __weak __typeof(self) weakSelf = self;
    [picker dismissViewControllerAnimated:YES completion:nil];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[XPNetWorkTool shareTool]upLoadToQNYWithImages:image addSeconds: 1 WithCallBack:^(id obj) {
            NSString *url = obj;
            if ([url isEqualToString:@"error"]){
                dispatch_async(dispatch_get_main_queue(), ^{
                    hud.label.text = @"上传失败";
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [hud removeFromSuperview];
                        
                    });
                });
            }else{
                hud.label.text = @"上传成功";
                [hud removeFromSuperview];
                [[NSUserDefaults standardUserDefaults] setObject:url forKey:@"avatar"];
                XPMineModel *model = weakSelf.modelArr[0];
                model.icon = url;
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [[XPNetWorkTool shareTool] loadUserInfoWithFullParam:NO andIsAvatar:YES CallBack:^{
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                        
                    });
                    
                }];
            }
            
        }];
    });
    
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - XPReplyViewDelegate
- (void)replyViewDelegate:(XPReplyView *)replyView andTextField:(UITextField *)textField{
    [[NSUserDefaults standardUserDefaults] setObject:textField.text forKey:@"userName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[XPNetWorkTool shareTool] loadUserInfoWithFullParam:NO andIsAvatar:NO CallBack:^{
        
    }];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}
@end

