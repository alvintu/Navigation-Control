//
//  ProductFormViewController.h
//  NavCtrl
//
//  Created by Jo Tu on 5/3/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DAO.h"

@interface ProductFormViewController : UIViewController
@property (nonatomic,strong) UITextField *tf;
@property (nonatomic,strong) UITextField *tf1;
@property (nonatomic,strong) NSString *productName;
@property (nonatomic,strong) NSString *productURL;
@property (nonatomic,strong) Product *currentProduct;
@property (nonatomic,strong) Company *currentCompany;
@property(nonatomic, strong) DAO *dao;

@property (nonatomic,strong) NSMutableArray *currentproducts;

@end
