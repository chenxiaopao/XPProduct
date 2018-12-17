//
//  XPInfoDetailViewController.m
//  XPProduct
//
//  Created by 陈思斌 on 2018/9/2.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import "XPInfoDetailViewController.h"
#import <WebKit/WebKit.h>
#import "XPNetWorkTool.h"
#import "XPImageModel.h"
#import "XPInfoDetailModel.h"
#import "MJExtension.h"
#import "WebViewJavascriptBridge.h"
#import "SDWebImageManager.h"
#import <MBProgressHUD/MBProgressHUD.h>
@interface XPInfoDetailViewController () <UIWebViewDelegate>
@property (nonatomic,weak) UIWebView *webView;
@property (nonatomic,strong) WebViewJavascriptBridge *bridge;
@property (nonatomic,weak) MBProgressHUD *hud;

@end

@implementation XPInfoDetailViewController
- (UIWebView *)webView{
    if (_webView == nil){
        UIWebView *wb = [[UIWebView alloc]initWithFrame:self.view.bounds];
        _webView = wb;
        [self.view addSubview:_webView];
    }
    return _webView;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"正在加载中";
    hud.mode = MBProgressHUDModeIndeterminate;
    self.hud = hud;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详情";
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.path]];
    self.webView.delegate = self;
    [self.webView loadRequest:request];
    
//    [WebViewJavascriptBridge enableLogging];
//    self.bridge = [WebViewJavascriptBridge bridgeForWebView:self.webView];
//    [[XPNetWorkTool shareTool] loadInfoDetailDataFinish:^(id result, NSError *error) {
//        if (error == nil){
//
//            [self setWebViewDataByData:result];
//        }
//    }];
    
}


#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.hud removeFromSuperview];
}



#pragma mark - Others
- (void)setWebViewDataByData:(id)result{
    [XPInfoDetailModel mj_setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"img":@"XPImageModel"
                 
                 };
    }];
    XPInfoDetailModel *infoModel = [XPInfoDetailModel mj_objectWithKeyValues:[result objectForKey:@"AQ72N9QG00051CA1"]];
  
  
    
    NSMutableString *allStr = [NSMutableString stringWithString:@"<style type='text/css'> p{font-size: 25px}</style>"];
    NSMutableString *bodyStr = [NSMutableString stringWithString:[allStr stringByAppendingString:infoModel.body]];
   
   
    
    for (XPImageModel *imgModel in infoModel.img) {
        NSArray *arr = [imgModel.pixel componentsSeparatedByString:@"*"];
        CGFloat width = [[arr objectAtIndex:0] floatValue];
        CGFloat height = [[arr objectAtIndex:1] floatValue];
        CGFloat rate = (CGFloat)(XP_SCREEN_WIDTH-20)/width;
        CGFloat newWidth = width * rate;
        CGFloat newHeight = height *rate;
        NSString *imageStr = [NSString stringWithFormat:@"<img src = 'loading' id = '%@' width = '%.0f' height = '%.0f' hspace='0.0' vspace='5'>",[self replaceUrlSpecialString:imgModel.src],newWidth,newHeight];
   
        [bodyStr replaceOccurrencesOfString:imgModel.ref withString:imageStr options:NSCaseInsensitiveSearch range:[bodyStr rangeOfString:imgModel.ref]];
        
    }
    [self setImageFromDownloaderOrDiskByImageUrlArray:infoModel.img];
    
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"webViewHtml" ofType:@"html"];
    NSMutableString *htmlStr = [NSMutableString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
     [htmlStr replaceOccurrencesOfString:@"<p>news</p>" withString:bodyStr options:NSCaseInsensitiveSearch range: [htmlStr rangeOfString:@"<p>news</p>"]];
    [self.webView loadHTMLString:htmlStr baseURL:nil];
    
}
- (void)setImageFromDownloaderOrDiskByImageUrlArray:(NSArray *)imageArray{
    SDWebImageManager *imageManager = [SDWebImageManager sharedManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"default/com.hackemist.SDWebImageCache.default"];
    
    for (XPImageModel *model in imageArray) {
        NSString *cacheKey = [imageManager cacheKeyForURL:[NSURL URLWithString:[self replaceUrlSpecialString:model.src]]];
        NSString *imagePath = [imageManager.imageCache cachePathForKey:cacheKey inPath:filePath];
        if ([imageManager.imageCache diskImageDataExistsWithKey:cacheKey]){
            NSString *jsData =[NSString stringWithFormat:@"replaceImage%@,%@",[self replaceUrlSpecialString:model.src],imagePath];
            [self.bridge callHandler:@"showImage" data:jsData responseCallback:^(id responseData) {
                NSLog(@"我问问 %@",responseData);
                
            }];
        }else{
            [imageManager.imageDownloader downloadImageWithURL:[NSURL URLWithString: model.src] options:SDWebImageDownloaderProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                
            } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                if (finished){
                    [imageManager.imageCache storeImage:image forKey:[self replaceUrlSpecialString:model.src] completion:^{
                        NSString *jsData =[NSString stringWithFormat:@"replaceImage%@,%@",[self replaceUrlSpecialString:model.src],imagePath];
                        [self.bridge callHandler:@"showImage" data:jsData responseCallback:^(id responseData) {
                            NSLog(@"%@",responseData);
                            
                        }];
                    }];
                }
            }];

        }
    }
}
- (NSString *)replaceUrlSpecialString:(NSString *)string {
    
    return [string stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
}






@end
