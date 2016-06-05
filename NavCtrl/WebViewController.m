//
//  WebViewController.m
//  NavCtrl
//
//  Created by Jo Tu on 4/29/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import "WebViewController.h"

@implementation WebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
//    
//    UIWebView *webview=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 1024,1024)];
////    NSString *url=@"https://www.google.com";
//    NSURL *nsurl=[NSURL URLWithString:self.link];
//    NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
//    [webview loadRequest:nsrequest];
//    [self.view addSubview:webview];
    
    WKWebViewConfiguration *theConfiguration = [[WKWebViewConfiguration alloc] init];
    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.frame ];
    [theConfiguration release];

    NSURL *nsurl=[NSURL URLWithString:self.link];

    webView.navigationDelegate = self;
    NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
    [webView loadRequest:nsrequest];
    [self.view addSubview:webView];
    [webView release];
    
    // Uncomment the following line to preserve selection between presentations.
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
