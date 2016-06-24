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
    
    
    
    UIBarButtonItem *addNewProduct = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                      target:self
                                      action:@selector(saveButton)];

    
    self.navigationItem.rightBarButtonItem = addNewProduct;
    
    self.dao = [DAO sharedDAO];
    NSLog(@"%@",_currentCompany);
    
    //    NSLog(@"in form");
    self.productNameField =  [[UITextField alloc] initWithFrame:CGRectMake(85, 70, 200, 20)];
    self.productNameField.textColor = [UIColor colorWithRed:0/256.0 green:84/256.0 blue:129/256.0 alpha:1.0];
    self.productNameField.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    self.productNameField.backgroundColor=[UIColor colorWithRed:211/256.0 green:211/256.0 blue:211/256.0 alpha:1.0];
    self.productNameField.text=self.productName;
    self.productNameField.textAlignment =  NSTextAlignmentCenter;
    self.productNameField.placeholder = @"Product Name";
    
    //second one
    self.productURLField = [[UITextField alloc] initWithFrame:CGRectMake(85, self.productNameField.frame.origin.y+30, 200, 20)];
    self.productURLField.textColor =[UIColor colorWithRed:0/256.0 green:84/256.0 blue:129/256.0 alpha:1.0];
    self.productURLField.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    self.productURLField.backgroundColor=[UIColor colorWithRed:211/256.0 green:211/256.0 blue:211/256.0 alpha:1.0];
    self.productURLField.text=self.productURL;
    self.productURLField.textAlignment =  NSTextAlignmentCenter;
    self.productURLField.placeholder = @"Product URL";

    self.productLogoField = [[UITextField alloc] initWithFrame:CGRectMake(85, self.productURLField.frame.origin.y+50, 200, 20)];
    self.productLogoField.textColor = [UIColor colorWithRed:0/256.0 green:84/256.0 blue:129/256.0 alpha:1.0];
    self.productLogoField.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    self.productLogoField.backgroundColor= [UIColor colorWithRed:211/256.0 green:211/256.0 blue:211/256.0 alpha:1.0];
    self.productLogoField.text=self.productLogo;
    self.productLogoField.textAlignment =  NSTextAlignmentCenter;
    self.productLogoField.placeholder = @"Product Image";

    
    self.productPriceField = [[UITextField alloc] initWithFrame:CGRectMake(85, self.productLogoField.frame.origin.y+50, 200, 20)];
    self.productPriceField.textColor = [UIColor colorWithRed:0/256.0 green:84/256.0 blue:129/256.0 alpha:1.0];
    self.productPriceField.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    self.productPriceField.backgroundColor= [UIColor colorWithRed:211/256.0 green:211/256.0 blue:211/256.0 alpha:1.0];
    self.productPriceField.text=self.productPrice;
    self.productPriceField.textAlignment =  NSTextAlignmentCenter;
    self.productPriceField.placeholder = @"$$$$$";
    
    CGRect buttonFrame = CGRectMake(145, self.productPriceField.frame.origin.y+30, 70, 20 );
    self.button = [[UIButton alloc] initWithFrame: buttonFrame];
    [self.button setTitle: @"Delete" forState: UIControlStateNormal];
    [self.button addTarget:self action:@selector(deleteButton) forControlEvents:UIControlEventTouchUpInside];
    [self.button setTitleColor: [UIColor orangeColor] forState: UIControlStateNormal];
    self.button.backgroundColor = [UIColor colorWithRed:211/256.0 green:211/256.0 blue:211/256.0 alpha:1.0];


    
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
    view.backgroundColor = [UIColor colorWithRed:211/256.0 green:211/256.0 blue:211/256.0 alpha:1.0];
    [view addSubview:self.productNameField];
    [view addSubview:self.productURLField];
    [view addSubview:self.productLogoField];
    [view addSubview:self.warningMessageLabel];
    [view addSubview:self.productPriceField];
    [view addSubview:self.button];
    
    if([self.title isEqual:@"Add Product"]){
        self.button.hidden = YES;
    }
    else{
        self.button.hidden = NO;
    }
    
    [self.view addSubview:view];
//    [self.currentCompany release];
}


-(void)deleteButton{
    ProductViewController *productViewController =  [[ProductViewController alloc]init];
    [self.dao deleteProduct:self.currentproducts[self.passedCompanyIndex]];
    [productViewController.tableView reloadData];

    
    NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
    for (UIViewController *aViewController in allViewControllers) {
        
        
        if ([aViewController isKindOfClass:[ProductViewController class]]) {
            
            [self.navigationController popToViewController:aViewController animated:YES];
        }
    }

}


-(void)saveButton{
    if(![self.productNameField.text isEqualToString:@""]){
        
//        bool found = NO;
        //                if([self.currentProduct productName] ==  self.productName){
//        for(Product* product in self.currentCompany.products){
            if(self.currentProduct){ //comparing textfield with dao array
                [self.currentProduct setProductName:self.productNameField.text];
                [self.currentProduct setProductURL:self.productURLField.text];
                [self.currentProduct setProductLogo:self.productLogoField.text];
                [self.currentProduct setPrice:self.productPriceField.text];
                [self.dao editProducts:self.currentProduct];

            }
        
//        if (found == NO)
    else
        {
            

            Product *newProduct = [[Product alloc]initWithProductName:self.productNameField.text productURL:self.productURLField.text productLogo:self.productLogoField.text];
            newProduct.price =self.productPriceField.text;
            NSLog(@"newProduct.price is %@",newProduct.price);

            for(Company *company in self.dao.companies){
                if(company.products == self.currentproducts){
                    self.currentCompany = company;
//                    self.currentProduct = newProduct
            
            
            [newProduct setComp_id:(NSNumber*)self.currentCompany.companyID ];
            [self.currentproducts addObject:newProduct];
            [self.dao addProduct:newProduct selectedCompanyID:newProduct.comp_id indexOfProduct:[self.currentproducts indexOfObject:newProduct]];
            [newProduct release];
                }
            }
        }
        
        
//        [self.navigationController popViewControllerAnimated:YES];
//        [self.navigationController popViewControllerAnimated:YES];


        NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
        for (UIViewController *aViewController in allViewControllers) {
            

            if ([aViewController isKindOfClass:[ProductViewController class]]) {

                [self.navigationController popToViewController:aViewController animated:YES];
            }
        }
//

    }else {
        self.warningMessageLabel.hidden = NO;
        //        [self.view release];
    }
}

-(void)viewWillDisappear:(BOOL)animated {
//    self.currentCompany = nil;
    

}

@end
