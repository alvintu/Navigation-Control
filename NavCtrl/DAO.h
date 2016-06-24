//
//  DAO.h
//  NavCtrl
//
//  Created by Jo Tu on 5/2/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Product.h"
#import "Company.h"
//#import "sqlite3.h"
#import <CoreData/CoreData.h>



@interface DAO : NSObject
@property (nonatomic, retain) NSMutableArray<Company*> *companies;
@property (nonatomic, retain) NSMutableArray<Product*> *products;


    // whatever instance vars you want

-(void)readDatabase;

+ (DAO *)sharedDAO;   // class method to return the singleton object
-(void)createOrOpenDB;
-(int)addCompany:(Company*)newCompany;
-(void)deleteCompany:(Company*)selectedCompany;
-(void)editCompany:(Company*)selectedCompany;
-(void)trackCompanyPosition;
//-(void)orderCompaniesByPosition;
-(void)addProduct:(Product*)newProduct  selectedCompanyID:(NSNumber*)selectedCompanyID indexOfProduct:(NSInteger)indexOfProduct;
-(void)deleteProduct:(Product*)selectedProduct;
//-(void)sortProducts:(Company*)selectedCompany;
//-(void)trackProductsPosition;
-(void)editProducts:(Product*)selectedProduct;
-(void)trackProductsPosition:(NSMutableArray*)products selectedCompany:(Company*)selectedCompany;
-(void)deleteProductsRelatedToCompanyID:(Company*)company;
-(void)redoChanges;
-(void)redoProductChanges;

-(void) saveChanges;
-(void)populateProductsBasedOnCompanyID:(Company*)selectedCompany;
@property(nonatomic,retain) NSManagedObjectContext *context;
@property(nonatomic,retain) NSManagedObjectModel *model;
-(void)undoChanges;
-(void)undoProductChanges;

@end