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
    self.newproducts = [[NSMutableArray alloc]init];
    self.dao = [DAO sharedDAO];
    NSLog(@"%@",_currentCompany);
    
    //    NSLog(@"in form");
    self.productNameField =  [[UITextField alloc] initWithFrame:CGRectMake(45, 30, 400, 80)];
    self.productNameField.textColor = [UIColor colorWithRed:0/256.0 green:84/256.0 blue:129/256.0 alpha:1.0];
    self.productNameField.font = [UIFont fontWithName:@"Helvetica-Bold" size:25];
    self.productNameField.backgroundColor=[UIColor greenColor];
    self.productNameField.text=self.productName;
    
    
    
    //second one
    self.productURLField = [[UITextField alloc] initWithFrame:CGRectMake(45, self.productNameField.frame.origin.y+100, 400, 80)];
    self.productURLField.textColor = [UIColor colorWithRed:0/256.0 green:84/256.0 blue:129/256.0 alpha:1.0];
    self.productURLField.font = [UIFont fontWithName:@"Helvetica-Bold" size:25];
    self.productURLField.backgroundColor=[UIColor greenColor];
    self.productURLField.text=self.productURL;
    
    self.productLogoLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, self.productURLField.frame.origin.y+100, 400, 80)];
    self.productLogoLabel.textColor = [UIColor colorWithRed:0/256.0 green:84/256.0 blue:129/256.0 alpha:1.0];
    self.productLogoLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:25];
    self.productLogoLabel.backgroundColor=[UIColor greenColor];
    self.productLogoLabel.text=self.productLogo;
    
    
    CGRect buttonFrame = CGRectMake( 300, 300, 100, 30 );
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
    [view addSubview:self.productNameField];
    [view addSubview:self.productURLField];
    [view addSubview:self.productLogoLabel];

    [view addSubview:button];
    
    [self.view addSubview:view];
    
    
    
}

-(void)saveButton{
    bool found = NO;
                if([self.currentProduct productName] ==  self.productName){
                    [self.currentProduct setProductName:self.productNameField.text];
                    [self.currentProduct setProductURL:self.productURLField.text];
                    [self.currentProduct setProductLogo:self.productLogoLabel.text];
                    [self.dao editProducts:self.currentProduct selectedCompany:self.currentCompany];


                    
            found = YES;
                    

                }

    if (found == NO) {
        Product *newProduct = [[Product alloc]initWithProductName:self.productNameField.text productURL:self.productURLField.text productLogo:self.productLogoLabel.text];
        [self.currentproducts insertObject:newProduct atIndex:([self.currentproducts count])];
        [self.newproducts insertObject:newProduct atIndex:([self.newproducts count])];
        [self.dao addProduct:newProduct selectedCompany:self.currentCompany indexOfProduct:[self.currentproducts indexOfObject:newProduct]];

}

    [self.navigationController popViewControllerAnimated:YES];
    
    //    [self.navigationController
    //     popViewControllerAnimated:YES];
    
    }


@end
