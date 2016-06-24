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
    
    
    
    
    WKWebViewConfiguration *theConfiguration = [[WKWebViewConfiguration alloc] init];
    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.frame ];
    [theConfiguration release];

    NSURL *nsurl=[NSURL URLWithString:[NSString stringWithFormat:@"https://%@",self.link]];
    webView.navigationDelegate = self;
    NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
    [webView loadRequest:nsrequest];
    [self.view addSubview:webView];
    [webView release];
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                   target:self
                                   action:@selector(editButtonWasPressed)];
    self.navigationItem.rightBarButtonItem = editButton;

    
    // Uncomment the following line to preserve selection between presentations.
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    
}

-(void)editButtonWasPressed{
        ProductFormViewController *productFormViewController = [[ProductFormViewController alloc] init];
        
        productFormViewController.title = @"Edit your products";
        productFormViewController.productName = self.productName;
        productFormViewController.productURL = self.productURL;
        productFormViewController.productLogo = self.productLogo;
        productFormViewController.productPrice = self.productPrice;
        productFormViewController.currentProduct = self.currentProduct;
        productFormViewController.currentproducts = self.currentproducts;
        productFormViewController.currentCompany = self.currentCompany;
    productFormViewController.passedCompanyIndex = self.passedCompanyIndex;
    NSLog(@"webViewController.productPrice right after push is %@",self.productPrice);

    
        [self.navigationController
         pushViewController:productFormViewController
         animated:YES];
        [productFormViewController release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
