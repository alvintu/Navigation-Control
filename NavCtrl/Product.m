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
    if(self == [super init]){
        self.productName = productName;
        self.productURL = productURL;
        self.productLogo = productLogo;
    }
    return self;
}
-(NSString *)description{
    return [NSString stringWithFormat:@"%@",self.productName];
    //    return self.productName;
}

@end
