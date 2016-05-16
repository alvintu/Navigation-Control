//
//  ProductViewController.h
//  NavCtrl
//
//  Created by Aditya Narayan on 10/22/13.
//  Copyright (c) 2013 Aditya Narayan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Company.h"
#import "Product.h"
#import "DAO.h"
#import "ProductFormViewController.h"
@class WebViewController;

@interface ProductViewController : UITableViewController
@property (nonatomic, retain) NSMutableArray *products;
@property (nonatomic, retain) NSArray *logos;
//@property (nonatomic, retain) NSMutableArray *productsView;
@property(nonatomic, strong) DAO *dao;
@property (nonatomic,strong) Company *currentCompany;






@property (nonatomic, retain) WebViewController *webViewController;

@end
