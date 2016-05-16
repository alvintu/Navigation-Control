//
//  FormViewController.m
//  NavCtrl
//
//  Created by Jo Tu on 5/3/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import "FormViewController.h"

@implementation FormViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.dao = [DAO sharedDAO];
    //    [self.dao.companies[0]setCompanyName:@"adfas"];
    //    NSLog(@"%@",[self.dao.companies[0] companyName]);
    
    
    //    NSLog(@"in form");
    self.nameField =  [[UITextField alloc] initWithFrame:CGRectMake(150, 30, 400, 80)];
    self.nameField.textColor = [UIColor colorWithRed:0/256.0 green:84/256.0 blue:129/256.0 alpha:1.0];
    self.nameField.font = [UIFont fontWithName:@"Helvetica-Bold" size:25];
    self.nameField.backgroundColor=[UIColor greenColor];
    self.nameField.text =self.companyName;
    
    
    
    //second one
    self.logoField = [[UITextField alloc] initWithFrame:CGRectMake(150, self.nameField.frame.origin.y+100, 400, 80)];
    self.logoField.textColor = [UIColor colorWithRed:0/256.0 green:84/256.0 blue:129/256.0 alpha:1.0];
    self.logoField.font = [UIFont fontWithName:@"Helvetica-Bold" size:25];
    self.logoField.backgroundColor=[UIColor greenColor];
    self.logoField.text=self.companyLogo;
    
    
    self.stockSymbolField = [[UITextField alloc] initWithFrame:CGRectMake(150, self.logoField.frame.origin.y+100, 400, 80)];
    self.stockSymbolField.textColor = [UIColor colorWithRed:0/256.0 green:84/256.0 blue:129/256.0 alpha:1.0];
    self.stockSymbolField.font = [UIFont fontWithName:@"Helvetica-Bold" size:25];
    self.stockSymbolField.backgroundColor=[UIColor greenColor];
    self.stockSymbolField.text=self.companySYM;
    
    
    self.companyIDLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, self.stockSymbolField.frame.origin.y+100, 400, 80)];
    self.companyIDLabel.textColor = [UIColor colorWithRed:0/256.0 green:84/256.0 blue:129/256.0 alpha:1.0];
    self.companyIDLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:25];
    self.companyIDLabel.backgroundColor=[UIColor greenColor];
    self.companyIDLabel.textAlignment =  NSTextAlignmentCenter;
    self.companyIDLabel.text=self.companyID;
    
    
    CGRect buttonFrame = CGRectMake( 300, 400, 100, 30 );
    UIButton *button = [[UIButton alloc] initWithFrame: buttonFrame];
    [button setTitle: @"Save" forState: UIControlStateNormal];
    [button addTarget:self action:@selector(saveButton) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
    button.backgroundColor = [UIColor redColor];
    
    //and so on adjust your view size according to your needs
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 45, screenWidth, screenHeight)];
    view.backgroundColor = [UIColor whiteColor];
    [view addSubview:self.nameField];
    [view addSubview:self.logoField];
    [view addSubview:self.stockSymbolField];
    [view addSubview:self.companyIDLabel];
    [view addSubview:button];
    
    [self.view addSubview:view];
    
    
    
}

-(void)saveButton{
    
    
    bool found = NO;
    for(int i = 0; i < [self.dao.companies count]; i ++){
        if(self.companyName == [self.dao.companies[i]companyName]){ //comparing textfield with dao array
            [self.dao.companies[i]setCompanyName:self.nameField.text]; //set name/logo for selected Company obj
            [self.dao.companies[i]setCompanyLogo:self.logoField.text];
            [self.dao.companies[i]setCompanySYM:self.stockSymbolField.text];
            [self.dao.companies[i]setCompanyID:self.companyIDLabel.text];
            [self.dao editCompany:self.dao.companies[i]];

            found = YES;
            break;
            //  CompanyViewController *companyViewController = [[CompanyViewController alloc]init];
        }
    }
    if (found == NO) {
        
        Company *newcompany = [[Company alloc]initWithCompanyName:self.nameField.text companyLogo:self.logoField.text companySYM:self.stockSymbolField.text companyID:self.companyIDLabel.text];
        newcompany.products = [[NSMutableArray alloc]init];
        [self.dao.companies addObject:newcompany];
         newcompany.companyID =  [NSString stringWithFormat:@"%d", [self.dao addCompany:newcompany]];
        
    }
    [self.navigationController popViewControllerAnimated:YES];
    
    //    [self.navigationController
    //     popViewControllerAnimated:YES];
    
}


@end
