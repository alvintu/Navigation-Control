//
//  ProductViewController.h
//  NavCtrl
//
//  Created by Aditya Narayan on 10/22/13.
//  Copyright (c) 2013 Aditya Narayan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Company.h"
#import "Product.h"
#import "DAO.h"
#import "ProductFormViewController.h"
#import "ProtoCell.h"
@class WebViewController;

@interface ProductViewController : UICollectionViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic, retain) NSMutableArray *products;
@property (nonatomic, retain) NSArray *logos;
//@property (nonatomic, retain) NSMutableArray *productsView;
@property(nonatomic, strong) DAO *dao;
@property (nonatomic,strong) Company *currentCompany;
//@property (retain, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) IBOutlet UICollectionViewFlowLayout *flowLayout;

@property BOOL isEditing;




//@property (nonatomic, retain) WebViewController *webViewController;

@end
