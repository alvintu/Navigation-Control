//
//  WebViewController.h
//  NavCtrl
//
//  Created by Jo Tu on 4/29/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductViewController.h"
@import WebKit;
@interface WebViewController : UIViewController <WKNavigationDelegate, WKUIDelegate>
@property (nonatomic, retain) NSString *link;
@property (nonatomic,strong) NSString *productName;
@property (nonatomic,strong) NSString *productURL;
@property (nonatomic,strong) NSString *productLogo;
@property (nonatomic,strong) NSString *productPrice;

@property (nonatomic,strong) Product *currentProduct;
@property (nonatomic,strong) Company *currentCompany;
//@property(nonatomic, strong) DAO *dao;
@property (nonatomic,strong) NSMutableArray *currentproducts;
@property (nonatomic) NSInteger passedCompanyIndex;


@end
