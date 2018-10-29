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
            XPMineUserCardViewController *vc = [[XPMineUserCardViewController alloc]init];
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
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSString *fullPath =  [UIImage saveImageWithImage:image andName:@"avatar"];
    [[XPNetWorkTool shareTool] loadUserInfoWithFullParam:NO andIsAvatar:YES CallBack:^{
        
    }];
    XPMineModel *model = self.modelArr[0];
    model.icon = fullPath;
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    [picker dismissViewControllerAnimated:YES completion:nil];
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

