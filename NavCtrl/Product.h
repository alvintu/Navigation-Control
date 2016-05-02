//
//  Product.h
//  NavCtrl
//
//  Created by Jo Tu on 4/29/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Product : NSObject

@property (nonatomic,strong) NSString *productName;
@property (nonatomic,strong) NSString *productURL;
@property (nonatomic,strong) NSString *productLogo;

-(instancetype)initWithProductName:(NSString*)productName productURL:(NSString*)productURL;
@end
