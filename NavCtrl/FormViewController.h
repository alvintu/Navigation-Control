//
//  FormViewController.h
//  NavCtrl
//
//  Created by Jo Tu on 5/3/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DAO.h"
#import "CompanyViewController.h"
#import "ProductFormViewController.h"

@interface FormViewController : UIViewController

@property (nonatomic,strong) NSString *companyName;
@property (nonatomic,strong) NSString *companyLogo;
@property (nonatomic,strong) NSString *companySYM;

@property (nonatomic,strong) UITextField *tf;
@property (nonatomic,strong) UITextField *tf1;
@property (nonatomic,strong) UITextField *tf2;
@property(nonatomic,strong) Company *currentCompany;
@property(nonatomic, strong) DAO *dao;

-(void)saveButton;


@end
