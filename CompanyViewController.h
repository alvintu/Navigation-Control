//
//  CompanyViewController.h
//  NavCtrl
//
//  Created by Aditya Narayan on 10/22/13.
//  Copyright (c) 2013 Aditya Narayan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Company.h"
#import "Product.h"
#import "DAO.h"
#import "FormViewController.h"
#import "ProductFormViewController.h"



@class ProductViewController;



@interface CompanyViewController : UITableViewController

@property (nonatomic, retain) NSMutableArray *companyList;
@property(nonatomic, strong) DAO *dao;
//@property (nonatomic, retain) IBOutlet FormViewController *formViewController;
@property (nonatomic, retain) IBOutlet  ProductViewController * productViewController;
@property (nonatomic, retain)  ProductFormViewController * productFormViewController;

@property (nonatomic, retain) NSMutableArray *companies;

@property(nonatomic,retain) NSMutableArray *stockComponents1;
@end
