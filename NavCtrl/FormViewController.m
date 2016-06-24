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
    

    
    UIBarButtonItem *addNewCompany = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                   target:self
                                   action:@selector(saveButton)];
    
    
    
    self.navigationItem.rightBarButtonItem  = addNewCompany;
    self.nameField =  [[UITextField alloc] initWithFrame:CGRectMake(85, 70, 200, 30)];
    self.nameField.textColor = [UIColor colorWithRed:0/256.0 green:84/256.0 blue:129/256.0 alpha:1.0];
    self.nameField.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    self.nameField.backgroundColor=[UIColor colorWithRed:211/256.0 green:211/256.0 blue:211/256.0 alpha:1.0];
    self.nameField.text =[self.currentCompany companyName];
    self.nameField.placeholder = @"Company Name";
    self.nameField.textAlignment =  NSTextAlignmentCenter;
    
    
    
    
    //second one
    self.logoField = [[UITextField alloc] initWithFrame:CGRectMake(85, self.nameField.frame.origin.y+30, 200, 30)];
    self.logoField.textColor = [UIColor colorWithRed:0/256.0 green:84/256.0 blue:129/256.0 alpha:1.0];
    self.logoField.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    self.logoField.backgroundColor=[UIColor colorWithRed:211/256.0 green:211/256.0 blue:211/256.0 alpha:1.0];
    self.logoField.text=[self.currentCompany companyLogo];
    self.logoField.placeholder = @"Company Logo";
    self.logoField.textAlignment =  NSTextAlignmentCenter;
    
    
    
    self.stockSymbolField = [[UITextField alloc] initWithFrame:CGRectMake(85, self.logoField.frame.origin.y+30, 200, 30)];
    self.stockSymbolField.textColor = [UIColor colorWithRed:0/256.0 green:84/256.0 blue:129/256.0 alpha:1.0];
    self.stockSymbolField.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    self.stockSymbolField.backgroundColor= [UIColor colorWithRed:211/256.0 green:211/256.0 blue:211/256.0 alpha:1.0];
    self.stockSymbolField.text=[self.currentCompany companySYM];
    self.stockSymbolField.placeholder = @"Stock Symbol";
    self.stockSymbolField.textAlignment =  NSTextAlignmentCenter;
    
    
    
    self.companyIDLabel = [[UILabel alloc] initWithFrame:CGRectMake(85, self.stockSymbolField.frame.origin.y+30, 200, 20)];
    self.companyIDLabel.textColor = [UIColor colorWithRed:211/256.0 green:211/256.0 blue:211/256.0 alpha:1.0];
    self.companyIDLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    self.companyIDLabel.backgroundColor=[UIColor orangeColor];
    self.companyIDLabel.textAlignment =  NSTextAlignmentCenter;
    self.companyIDLabel.hidden = YES;
  
    //    self.companyIDLabel.text=[self.currentCompany companyID];
    
    
    CGRect buttonFrame = CGRectMake(145, self.companyIDLabel.frame.origin.y+30, 70, 20 );
    self.button = [[UIButton alloc] initWithFrame: buttonFrame];
    [self.button setTitle: @"Delete" forState: UIControlStateNormal];
    [self.button addTarget:self action:@selector(deleteButton) forControlEvents:UIControlEventTouchUpInside];
    [self.button setTitleColor: [UIColor orangeColor] forState: UIControlStateNormal];
    self.button.backgroundColor = [UIColor colorWithRed:211/256.0 green:211/256.0 blue:211/256.0 alpha:1.0];
    
    
    self.warningMessageLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 150, 600, 300)];
    self.warningMessageLabel.textColor = [UIColor redColor];
    self.warningMessageLabel.font  = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    self.warningMessageLabel.text = @"Missing company name ";
    self.warningMessageLabel.hidden = YES;
    
    
    
    self.warningMessageLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(70, 200, 500, 300)];
    self.warningMessageLabel1.textColor = [UIColor redColor];
    self.warningMessageLabel1.font  = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    self.warningMessageLabel1.text = @" or stock symbol.";
    self.warningMessageLabel1.hidden = YES;
    
    
    
    
    //and so on adjust your view size according to your needs
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 45, screenWidth, screenHeight)];
    view.backgroundColor = [UIColor colorWithRed:211/256.0 green:211/256.0 blue:211/256.0 alpha:1.0];
    [view addSubview:self.nameField];
    [view addSubview:self.logoField];
    [view addSubview:self.stockSymbolField];
    [view addSubview:self.companyIDLabel];
    [view addSubview:self.button];
    [view addSubview:self.warningMessageLabel];     //WARNING MESSAGE TO ENTER NAME
    [view addSubview:self.warningMessageLabel1];        //WARNING MESSAGE TO ENTER STOCK SYMBOL
    [self.view addSubview:view];
    
    
    
    if ([self.title isEqual: @"New Company"]){
        self.button.hidden = YES;
    }
    else{
        self.button.hidden = NO;
    }
    
}


-(void)deleteButton{
    [self.dao deleteCompany:[self.dao.companies objectAtIndex:self.passedCompanyIndex]];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)saveButton{
    if(![self.nameField.text isEqualToString:@""] && ![self.stockSymbolField.text isEqualToString:@""]){
        if (self.currentCompany){
            [self.currentCompany setCompanyName:self.nameField.text];
            [self.currentCompany setCompanyLogo:self.logoField.text];
            [self.currentCompany setCompanySYM:self.stockSymbolField.text];
            [self.dao editCompany:self.currentCompany];
            //  CompanyViewController *companyViewController = [[CompanyViewController alloc]init];
        } else {
            self.currentCompany = [[Company alloc]initWithCompanyName:self.nameField.text companyLogo:self.logoField.text companySYM:self.stockSymbolField.text companyID:self.companyIDLabel.text];
//            self.currentCompany.products = [[NSMutableArray alloc]init];
//            [self.dao.companies addObject:self.currentCompany];
            [self.dao addCompany:self.currentCompany];

        }
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        self.warningMessageLabel.hidden = NO;
        
        self.warningMessageLabel1.hidden = NO;
        //        [self.view release];
    }
}

-(void)dealloc {
    
    [_nameField release];
    [_logoField release];
    [_stockSymbolField release];
    [_companyIDLabel release];
    [_button release];
    [_warningMessageLabel release];
    [_warningMessageLabel1 release];
    
    
    
    [super dealloc];
}


//    [self.navigationController
//     popViewControllerAnimated:YES];




@end
