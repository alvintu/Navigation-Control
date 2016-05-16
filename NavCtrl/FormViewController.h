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
@property (nonatomic,strong) NSString *companyID;


@property (nonatomic,strong) UITextField *nameField;
@property (nonatomic,strong) UITextField *logoField;
@property (nonatomic,strong) UITextField *stockSymbolField;
@property (nonatomic,strong) UITextField *textfield3;
@property (nonatomic,strong) UILabel *companyIDLabel;

@property(nonatomic,strong) Company *currentCompany;
@property(nonatomic, strong) DAO *dao;

-(void)saveButton;


@end
