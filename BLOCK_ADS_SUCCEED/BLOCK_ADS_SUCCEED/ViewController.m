//
//  ViewController.m
//  BLOCK_ADS_SUCCEED
//
//  Created by 冯明庆 on 16/11/21.
//  Copyright © 2016年 冯明庆. All rights reserved.
//

#import "ViewController.h"

#import "CCCustomProtocol.h"

@interface ViewController ()

@property (nonatomic , strong) UIWebView *webView ;

- (void) ccInitSettings ;
- (void) ccInitViewSettings ;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self ccInitSettings];
    [self ccInitViewSettings];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void) ccInitViewSettings {
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0,
                                                           0,
                                                           self.view.frame.size.width,
                                                           self.view.frame.size.height)];
    [self.view addSubview:_webView];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://m.le.com/vplay_26884021.html"]];
    [_webView loadRequest:request];
}

#pragma mark - 以下所有方法必须有 . 
/// 只接管 这个控制器 的 ,
/// 放在只有 webView 的控制器中 , 就只接管 WebView 的请求 .
/// 对 WKWebView 无效 . WKWebView 需要使用自己的代理方法 + 拦截视频请求

- (void) ccInitSettings {
    [NSURLProtocol registerClass:[CCCustomProtocol class]];
}
- (void) dealloc {
    /// 确保一定会释放 , 否则接管的是整个 App 的网络请求 .
    [NSURLProtocol unregisterClass:[CCCustomProtocol class]];
}

@end
