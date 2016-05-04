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
    self.tf =  [[UITextField alloc] initWithFrame:CGRectMake(45, 30, 400, 80)];
    self.tf.textColor = [UIColor colorWithRed:0/256.0 green:84/256.0 blue:129/256.0 alpha:1.0];
    self.tf.font = [UIFont fontWithName:@"Helvetica-Bold" size:25];
    self.tf.backgroundColor=[UIColor greenColor];
    self.tf.text=self.productName;
    
    
    
    //second one
    self.tf1 = [[UITextField alloc] initWithFrame:CGRectMake(45, self.tf.frame.origin.y+100, 400, 80)];
    self.tf1.textColor = [UIColor colorWithRed:0/256.0 green:84/256.0 blue:129/256.0 alpha:1.0];
    self.tf1.font = [UIFont fontWithName:@"Helvetica-Bold" size:25];
    self.tf1.backgroundColor=[UIColor greenColor];
    self.tf1.text=self.productURL;
    
    
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
    [view addSubview:self.tf];
    [view addSubview:self.tf1];
    [view addSubview:button];
    
    [self.view addSubview:view];
    
    
    
}

-(void)saveButton{
    bool found = NO;
//    for(int i = 0; i < [self.dao.companies count]; i ++){
//        if(self.companyName == [self.dao.companies[i]companyName]){
//            Company *currentCompany = self.dao.companies[i];  // change to being a company
                if([self.currentProduct productName] ==  self.productName){
                    [self.currentProduct setProductName:self.tf.text];
                    [self.currentProduct setProductURL:self.tf1.text];
//                }
//            [self.dao.companies[i]setCompanyName:self.tf.text]; //set name/logo for selected Company obj
//            [self.dao.companies[i]setCompanyLogo:self.tf1.text];
//            NSLog(@"%@",[self.dao.companies[i]companyName]);
//            NSLog(@"%@",[self.dao.companies[i]companyLogo]);
            found = YES;
                    

                }

    if (found == NO) {
        Product *newProduct = [[Product alloc]initWithProductName:self.tf.text productURL:self.tf1.text];
        [self.currentproducts insertObject:newProduct atIndex:([self.currentproducts count])];
        [self.newproducts insertObject:newProduct atIndex:([self.newproducts count])];

}

    [self.navigationController popViewControllerAnimated:YES];
    
    //    [self.navigationController
    //     popViewControllerAnimated:YES];
    
    }


@end
