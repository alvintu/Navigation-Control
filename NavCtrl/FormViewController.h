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
#import "FormViewController.h"

@interface FormViewController : UIViewController



@property (nonatomic,strong) UITextField *nameField;
@property (nonatomic,strong) UITextField *logoField;
@property (nonatomic,strong) UITextField *stockSymbolField;
@property (nonatomic,strong) UILabel *companyIDLabel;
@property (nonatomic,strong) UIButton *button;
@property (nonatomic,strong) UILabel *warningMessageLabel;
@property (nonatomic,strong) UILabel *warningMessageLabel1;
@property (nonatomic) NSInteger passedCompanyIndex;


@property(nonatomic,strong) Company *currentCompany;
@property(nonatomic, strong) DAO *dao;

-(void)saveButton;


@end
