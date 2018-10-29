//
//  XPSalePublishViewController.m
//  XPProduct
//
//  Created by 陈思斌 on 2018/9/28.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import "XPSalePublishViewController.h"
#import "MJExtension.h"
#import "XPBuyPublishModel.h"
#import "XPBuyPublishTableViewCell.h"
#import "XPBuyCategoryViewController.h"
#import "XPBuyPickView.h"
#import "XPSalePublishTimeViewController.h"
#import "XPSalePublishImageCollectionView.h"
#import "TZImagePickerController.h"
@interface XPSalePublishViewController () <UITableViewDataSource,UITableViewDelegate,XPBuyPickViewDelegate,XPSalePublishImageCollectionViewDelegate,TZImagePickerControllerDelegate>
@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,strong) NSArray *salePublishData;
@property (nonatomic,strong) NSMutableArray *imageArr;
@property (nonatomic,assign) CGFloat footerViewH;
@property (nonatomic,strong) NSMutableArray *assets;
@end

static NSString *salePublishCellID = @"salePublishCellID";

@implementation XPSalePublishViewController
- (NSMutableArray *)imageArr{
    if (_imageArr == nil){
        UIImage *image = [UIImage imageNamed:@"add"];
        _imageArr = [NSMutableArray arrayWithObject:image];
    }
    return _imageArr;
}
- (NSMutableArray *)assets{
    if(_assets == nil){
        _assets = [NSMutableArray array];
    }
    return _assets;
}
- (NSArray *)salePublishData{
    if (_salePublishData == nil){
        NSArray *arr = @[
                         @{@"titleName":@"货品名称:",@"subTitleName":@"选择货品名称"},
                         @{@"titleName":@"货品规格:",@"subTitleName":@"输入货品规格"},
                         @{@"titleName":@"货品单价:",@"subTitleName":@"输入货品单价"},
                         @{@"titleName":@"起批数量:",@"subTitleName":@"输入起批数量"},
                         @{@"titleName":@"发货地址:",@"subTitleName":@"选择发货地址"},
                         @{@"titleName":@"供货时间:",@"subTitleName":@"选择供货时间"},
                         @{@"titleName":@"货品描述:",@"subTitleName":@"输入货品特色"},
                         @{@"titleName":@"上传图片:",@"subTitleName":@"选择图片,最多8张,不支持视频"},
                         ];
        _salePublishData = [XPBuyPublishModel mj_objectArrayWithKeyValuesArray:arr];
    }
    return  _salePublishData;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发布供应";
    [self setTableView];
    
    [self addPublishBtn];
}

- (void)addPublishBtn{
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(10, XP_SCREEN_HEIGHT-50, XP_SCREEN_WIDTH-20, 40)];
    [btn setTitle:@"发布供应" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor greenColor];
    btn.layer.cornerRadius = 10;
    btn.layer.masksToBounds = YES;
    [btn addTarget:self action:@selector(publishBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    self.footerViewH = 100;
}

- (void)publishBtnClick:(UIButton *)btn{
    
}

- (void)setTableView{
    UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerNib:[UINib nibWithNibName:@"XPBuyPublishTableViewCell" bundle:nil] forCellReuseIdentifier:salePublishCellID];
    self.tableView = tableView;
    [self.view addSubview:tableView];
}

#pragma mark - UITableView UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return 2;
    }
    return self.salePublishData.count-2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XPBuyPublishTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:salePublishCellID forIndexPath:indexPath];
    

    if (indexPath.section == 0){
        if(indexPath.row == 0){
            __weak __typeof (cell) weakCell = cell;
            __weak __typeof (self)weakSelf = self;
            cell.block = ^{
                XPBuyCategoryViewController *vc = [[XPBuyCategoryViewController alloc]init];
                vc.popBlock = ^(NSArray * arr, NSInteger index) {
                    weakCell.textField.text = [arr lastObject];
                };
                [weakSelf.navigationController pushViewController:vc animated:NO];
    
            };
        }
        cell.data = self.salePublishData[indexPath.row];
    }else{
        switch (indexPath.row) {
            case 2:
            {
                XPBuyPickView *pickView = [[XPBuyPickView alloc]init];
                pickView.buyPickViewDelegate = self;
                cell.textField.inputView = pickView;
            }
                break;
            case 3:
            {
                __weak __typeof(self) weakSelf = self;
                __weak __typeof(cell) weakCell = cell;
                cell.block = ^{
                    XPSalePublishTimeViewController *vc = [XPSalePublishTimeViewController new];
                    vc.timeBlock = ^(NSString *title) {
                        weakCell.textField.text = title;
                    };
                    [weakSelf.navigationController pushViewController:vc animated:NO];
                };
            }
                break;
            case 5:
                cell.userInteractionEnabled = NO;
                break;
            
        }
        cell.data = self.salePublishData[indexPath.row+2];
    }
    
    return cell;
}
- (void)dealloc
{
    NSLog(@"%s",__func__);
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return section == 0 ? 0 : 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1){
        return self.footerViewH;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 1){
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(80, 80);
        layout.minimumLineSpacing = 10;
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        XPSalePublishImageCollectionView *collectionView = [[XPSalePublishImageCollectionView alloc]initWithFrame:CGRectMake(10, 0, XP_SCREEN_WIDTH-20, self.footerViewH) collectionViewLayout:layout];
        collectionView.collDelegate = self;
        collectionView.imageArr = self.imageArr;
        
        return collectionView;
    }
    return [UIView new];
}

#pragma mark - XPBuyPickViewDelegate
- (void)XPBuyPickView:(XPBuyPickView *)pickView addressName:(NSString *)addressName{
    XPBuyPublishTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]];
    cell.textField.text = addressName;
}

#pragma mark - XPSalePublishImageCollectionViewDelegate

- (void)salePublishImageCollectionView:(XPSalePublishImageCollectionView *)collectionView didSelectedIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.item == self.imageArr.count-1){
        TZImagePickerController *vc = [[TZImagePickerController alloc]initWithMaxImagesCount:8 delegate:self];
        [self presentViewController:vc animated:YES completion:nil];
    }else{
//        [self.imageArr removeLastObject];
        TZImagePickerController *vc = [[TZImagePickerController alloc]initWithSelectedAssets:self.assets selectedPhotos:self.imageArr index:indexPath.item];
        [self presentViewController:vc animated:YES completion:nil];
    }
}

- (void)salePublishImageCollectionView:(XPSalePublishImageCollectionView *)collectionView didSelectedCloseBtnIndex:(NSInteger)index{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否删除当前图片?" message:@"慎重考虑" preferredStyle:UIAlertControllerStyleActionSheet];
    __weak __typeof(self) weakSelf = self;
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf.imageArr removeObjectAtIndex:index];
        [weakSelf.tableView reloadData];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:confirm];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:NO];
}

#pragma mark - TZImagePickerControllerDelegate
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos{
    if ((photos.count+ self.imageArr.count) >9){
        [self presentViewController:[picker showAlertWithTitle:@"超过8张了"] animated:YES completion:nil];
    }else{
        NSIndexSet *photoSet =  [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, photos.count)];
        [self.imageArr insertObjects:photos atIndexes:photoSet];
        if (self.imageArr.count > 4){
            self.footerViewH = 200;
        }
        NSIndexSet *set =  [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, assets.count)];
        [self.assets insertObjects:assets atIndexes:set];
     
        [self.tableView reloadData];
    }
}
//- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(PHAsset *)asset{
//    if ((1 + self.imageArr.count) >9){
//        [self presentViewController:[picker showAlertWithTitle:@"超过8张了"] animated:YES completion:nil];
//    }else{
//        [self.imageArr insertObject:coverImage atIndex:0];
//        [self.assets insertObject:asset atIndex:0];
//        if (self.imageArr.count > 4){
//            self.footerViewH = 200;
//        }
//        [self.tableView reloadData];
//    }
//}
@end
