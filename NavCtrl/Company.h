//
//  Company.h
//  NavCtrl
//
//  Created by Jo Tu on 4/29/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Product.h"

@interface Company : NSObject
@property (nonatomic, strong) NSString *companyName;
@property (nonatomic, strong ) NSString *companyLogo;
@property (nonatomic, strong ) NSString *companySYM;
@property (nonatomic, strong) NSMutableArray *products;
@property (nonatomic,strong) NSString *stockPrice;


//@property (nonatomic,strong) Product *product;
-(instancetype)initWithCompanyName:(NSString*)companyName companyLogo:(NSString*)companyLogo companySYM:(NSString*)companySYM;

@end
