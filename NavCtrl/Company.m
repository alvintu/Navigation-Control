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
    if(self = [super init]){
    
    _products = [[NSMutableArray alloc]init];
    }
    return self;
}

-(instancetype)initWithCompanyName:(NSString*)companyName companyLogo:(NSString*)companyLogo companySYM:(NSString*)companySYM companyID:(NSNumber*)companyID{
    self = [super init];
        _companyName = companyName;
        _companyLogo = companyLogo;
        _companySYM = companySYM;
        _companyID = companyID;
        _products = [[NSMutableArray alloc]init];
    
    return self;
}

-(NSString *)description{
    return [NSString stringWithFormat:@"%@",self.companyName];
    //    return self.productName;
}

-(void)dealloc {

    [_companyName release];
    [_companyLogo release];
    [_companySYM release];
    [_companyID release];
    [_products release];
    [_stockPrice release];

    _companyName = nil;
    _companyLogo = nil;
    _companySYM = nil;
    _companyID = nil;
    _products = nil;
    
    NSLog(@"Company Dealloc");
    
    [super dealloc];
}
@end
