//
//  XPBuyPickView.m
//  XPProduct
//
//  Created by 陈思斌 on 2018/9/26.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import "XPBuyPickView.h"

@interface XPBuyPickView () <UIPickerViewDataSource,UIPickerViewDelegate>
@property (nonatomic,strong) NSArray *addressArr;
@property (nonatomic,assign) NSInteger provinceIndex;
@property (nonatomic,assign) NSInteger cityIndex;
@end

@implementation XPBuyPickView
-(NSArray *)addressArr{
    
    if (_addressArr == nil) {
        
        NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"address.plist" ofType:nil]];
        
        _addressArr = dic[@"address"];
    }
    
    return _addressArr;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
    self.delegate = self;
    self.dataSource =self;
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0){
        return self.addressArr.count;
    }else if (component == 1){
        NSArray *arr = [self.addressArr[self.provinceIndex] objectForKey:@"sub"];
        return arr.count;
    }else{
        NSDictionary *dict = [self.addressArr[self.provinceIndex] objectForKey:@"sub"][self.cityIndex];
        if([dict.allKeys containsObject:@"sub"]){
            NSArray *arr = [dict objectForKey:@"sub"];
            return arr.count;
        }
        return 0;
    }
    
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSDictionary *dict = self.addressArr[row];
    if (component == 0){
        return [dict objectForKey:@"name"];
    }else if (component == 1){
        NSArray *arr = [self.addressArr[self.provinceIndex] objectForKey:@"sub"];
        return [arr[row] objectForKey:@"name"];
    }else{
        NSDictionary *dict = [self.addressArr[self.provinceIndex] objectForKey:@"sub"][self.cityIndex];
        if([dict.allKeys containsObject:@"sub"]){
            NSArray *arr = [dict objectForKey:@"sub"];
            return arr[row];
        }
        return @"";
    }
    
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0){
        self.provinceIndex = row;
        [self selectRow:0 inComponent:1 animated:YES];
        
    }else if (component == 1){
        self.cityIndex = row;
        [self selectRow:0 inComponent:2 animated:YES];
        
    }
    [self reloadAllComponents];
    if ([self.buyPickViewDelegate respondsToSelector:@selector(XPBuyPickView:addressName:)]){
        NSDictionary *dict = self.addressArr[self.provinceIndex];
        NSString *provinceName = [dict objectForKey:@"name"];
        NSString *cityName = [[dict objectForKey:@"sub"][self.cityIndex] objectForKey:@"name"];
        NSInteger areaIndex = [self selectedRowInComponent:2];
        NSString *areaName = [[[dict objectForKey:@"sub"][self.cityIndex] objectForKey:@"sub"] objectAtIndex:areaIndex];
        if ([cityName isEqualToString:@"全部"]){
            cityName = @"";
            areaName = @"";
        }
        if ([cityName containsString:provinceName]){
            provinceName = @"";
            
        }
        if ([areaName isEqualToString:@"全部"]){
            areaName = @"";
        }
        [self.buyPickViewDelegate XPBuyPickView:self addressName:[NSString stringWithFormat:@"%@%@%@",provinceName,cityName,areaName]];
    }
}


@end
