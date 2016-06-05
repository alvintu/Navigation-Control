//
//  ProductFormViewController.m
//  NavCtrl
//
//  Created by Jo Tu on 5/3/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import "ProductFormViewController.h"

@implementation ProductFormViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.dao = [DAO sharedDAO];
    NSLog(@"%@",_currentCompany);
    
    //    NSLog(@"in form");
    self.productNameField =  [[UITextField alloc] initWithFrame:CGRectMake(60, 70, 200, 20)];
    self.productNameField.textColor = [UIColor orangeColor];
    self.productNameField.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    self.productNameField.backgroundColor=[UIColor blueColor];
    self.productNameField.text=self.productName;
    self.productNameField.textAlignment =  NSTextAlignmentCenter;
    self.productNameField.placeholder = @"Product Name";
    
    //second one
    self.productURLField = [[UITextField alloc] initWithFrame:CGRectMake(60, self.productNameField.frame.origin.y+30, 200, 20)];
    self.productURLField.textColor = [UIColor orangeColor];
    self.productURLField.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    self.productURLField.backgroundColor=[UIColor blueColor];
    self.productURLField.text=self.productURL;
    self.productURLField.textAlignment =  NSTextAlignmentCenter;
    self.productURLField.placeholder = @"Product URL";

    self.productLogoLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, self.productURLField.frame.origin.y+50, 200, 20)];
    self.productLogoLabel.textColor = [UIColor orangeColor];
    self.productLogoLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
    self.productLogoLabel.backgroundColor=[UIColor blueColor];
    self.productLogoLabel.text=self.productLogo;
    self.productLogoLabel.textAlignment =  NSTextAlignmentCenter;
    
    CGRect buttonFrame = CGRectMake(120, self.productLogoLabel.frame.origin.y+30, 70, 20 );
    UIButton *button = [[UIButton alloc] initWithFrame: buttonFrame];
    [button setTitle: @"Save" forState: UIControlStateNormal];
    [button addTarget:self action:@selector(saveButton) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
    button.backgroundColor = [UIColor redColor];
    
    self.warningMessageLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 150, 600, 300)];
    self.warningMessageLabel.textColor = [UIColor redColor];
    self.warningMessageLabel.font  = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    self.warningMessageLabel.text = @"Missing product name ";
    self.warningMessageLabel.hidden = YES;

   
    
    //and so on adjust your view size according to your needs
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 45, screenWidth, screenHeight)];
    view.backgroundColor = [UIColor colorWithRed:0/256.0 green:0/256.0 blue:256.0/256.0 alpha:1.0];
    [view addSubview:self.productNameField];
    [view addSubview:self.productURLField];
    [view addSubview:self.productLogoLabel];
    [view addSubview:self.warningMessageLabel];
    [view addSubview:button];
    
    [self.view addSubview:view];
//    [self.currentCompany release];
}

-(void)saveButton{
    if(![self.productNameField.text isEqualToString:@""]){
        
//        bool found = NO;
        //                if([self.currentProduct productName] ==  self.productName){
//        for(Product* product in self.currentCompany.products){
            if(self.currentProduct){ //comparing textfield with dao array
                [self.currentProduct setProductName:self.productNameField.text];
                [self.currentProduct setProductURL:self.productURLField.text];
                [self.currentProduct setProductLogo:self.productLogoLabel.text];
                [self.dao editProducts:self.currentProduct];
//                found = YES;
//                [product release];
            }
        
//        if (found == NO)
    else
        {
            Product *newProduct = [[Product alloc]initWithProductName:self.productNameField.text productURL:self.productURLField.text productLogo:self.productLogoLabel.text];
            for(Company *company in self.dao.companies){
                if(company.products == self.currentproducts)
                    self.currentCompany = company;
            }
            
            [newProduct setComp_id:(NSNumber*)self.currentCompany.companyID ];
            [self.currentproducts addObject:newProduct];
            [self.dao addProduct:newProduct selectedCompanyID:newProduct.comp_id indexOfProduct:[self.currentproducts indexOfObject:newProduct]];
            [newProduct release];

        }
        [self.navigationController popViewControllerAnimated:YES];

    } else {
        self.warningMessageLabel.hidden = NO;
        //        [self.view release];
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    self.currentCompany = nil;

}

@end
