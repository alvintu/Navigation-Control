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


@class ProductViewController;



@interface CompanyViewController : UITableViewController

//@property (nonatomic, retain) NSMutableArray *companyList;
@property(nonatomic, strong) DAO *dao;
//@property (nonatomic, retain) IBOutlet FormViewController *formViewController;
@property (nonatomic, retain) IBOutlet  ProductViewController * productViewController;
@property (retain, nonatomic) IBOutlet UIView *EmptyState;

//@property (nonatomic, retain) NSMutableArray *companies;

- (IBAction)addCompanyButton:(id)sender;
@property (nonatomic,retain) UIButton *undoButton;
@property (nonatomic,retain) UIButton *redoButton;


@property(nonatomic,retain) NSMutableArray *stockComponents;
@end
