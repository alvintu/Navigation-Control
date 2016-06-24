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

@interface ProductViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, retain) NSMutableArray *products;
@property (nonatomic, retain) NSArray *logos;
//@property (nonatomic, retain) NSMutableArray *productsView;
@property(nonatomic, strong) DAO *dao;
@property (nonatomic,strong) Company *currentCompany;

@property (retain, nonatomic) IBOutlet UIView *productEmptyState;
@property(retain,nonatomic) NSString *passedLogoString;
@property (retain, nonatomic)  UIImageView *logoImage;
@property (retain, nonatomic)  UILabel *titleLabel;

@property (nonatomic,retain) UIButton *undoButton;
@property (nonatomic,retain) UIButton *redoButton;

@property (retain, nonatomic) IBOutlet UITableView *tableView;


- (IBAction)addProductButton:(id)sender;


//@property (nonatomic, retain) WebViewController *webViewController;

@end
