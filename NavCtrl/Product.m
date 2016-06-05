//
//  Product.m
//  NavCtrl
//
//  Created by Jo Tu on 4/29/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import "Product.h"

@implementation Product



-(instancetype)initWithProductName:(NSString*)productName productURL:(NSString*)productURL productLogo:(NSString*)productLogo{
    self = [super init];
        _productName = productName;
        _productURL = productURL;
        _productLogo = productLogo;
    
    return self;
}
-(NSString *)description{
    return [NSString stringWithFormat:@"%@",self.productName];
    //    return self.productName;
}

-(void)dealloc {
    
//    // access all properties directly as instance variables
//    [_productName release];
//    [_productURL release];
//    [_productLogo release];
//    
//    _productName = nil;
//    _productURL = nil;
//    _productLogo = nil;
//    
//    NSLog(@"Product Dealloc");

    [super dealloc];
}

@end
