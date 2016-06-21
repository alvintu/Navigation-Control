//
//  CompanyViewController.h
//  NavCtrl
//
//  Created by Aditya Narayan on 10/22/13.
//  Copyright (c) 2013 Aditya Narayan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Company.h"
#import "Product.h"
#import "DAO.h"
#import "FormViewController.h"
#import "ProtoCell.h"
@class ProductViewController;



@interface CompanyViewController : UICollectionViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIGestureRecognizerDelegate>


//@property (nonatomic, retain) NSMutableArray *companyList;
@property(nonatomic, strong) DAO *dao;
//@property (nonatomic, retain) IBOutlet FormViewController *formViewController;
@property (nonatomic, retain) IBOutlet  ProductViewController * productViewController;

//@property (nonatomic, retain) NSMutableArray *companies;

@property(nonatomic,retain) NSMutableArray *stockComponents;
//@property (retain, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) IBOutlet UICollectionViewFlowLayout *flowLayout;
@property BOOL isEditing;
//@property (nonatomic) UIButton *deleteButton;



@end
