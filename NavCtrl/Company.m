//
//  Company.m
//  NavCtrl
//
//  Created by Jo Tu on 4/29/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import "Company.h"

@implementation Company

-(instancetype)init{
    self = [super init];
    self.products = [[NSMutableArray alloc]init];
    return self;
}


-(instancetype)initWithCompanyName:(NSString*)companyName companyLogo:(NSString*)companyLogo companySYM:(NSString*)companySYM {
    if(self == [super init]){
        self.companyName = companyName;
        self.companyLogo = companyLogo;
        self.companySYM = companySYM;
    }
    return self;
}

-(NSString *)description{
    return [NSString stringWithFormat:@"%@",self.companyName];
    //    return self.productName;
}
@end
