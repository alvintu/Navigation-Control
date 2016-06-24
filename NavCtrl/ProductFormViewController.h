//
//  ProductFormViewController.h
//  NavCtrl
//
//  Created by Jo Tu on 5/3/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DAO.h"
#import "ProductViewController.h"
#import "WebViewController.h"

@interface ProductFormViewController : UIViewController
@property (nonatomic,strong) UITextField *productNameField;
@property (nonatomic,strong) UITextField *productURLField;
@property (nonatomic,strong) UITextField *productLogoField;
@property (nonatomic,strong) UITextField *productPriceField;
@property (nonatomic,strong) NSString *productName;
@property (nonatomic,strong) NSString *productURL;
@property (nonatomic,strong) NSString *productLogo;
@property (nonatomic,strong) NSString *productPrice;
@property (nonatomic,strong) UIButton *button;
@property (nonatomic) NSInteger passedCompanyIndex;


//@property (nonatomic,strong) WebViewController *webViewController;

@property (nonatomic,strong) Product *currentProduct;
@property (nonatomic,strong) Company *currentCompany;
@property(nonatomic, strong) DAO *dao;
@property (nonatomic,strong) NSMutableArray *currentproducts;

@property (nonatomic,strong) UILabel *warningMessageLabel;

@end
