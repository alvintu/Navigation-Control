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

@interface DAO : NSObject
@property (nonatomic, retain) NSMutableArray *companies;
//@property (nonatomic, retain) NSMutableArray *products;


    // whatever instance vars you want


+ (DAO *)sharedDAO;   // class method to return the singleton object

- (void)customMethod; // add optional methods to customize the singleton class

@end