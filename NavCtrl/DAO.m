//
//  DAO.m
//  NavCtrl
//
//  Created by Jo Tu on 5/2/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import "DAO.h"


@implementation DAO

static DAO *sharedDAO = nil;    // static instance variable

+ (DAO *)sharedDAO {
    if (sharedDAO == nil) {
        sharedDAO = [[super alloc] init];
    }
    return sharedDAO;
}

- (id)init {
    if ( (self = [super init]) ) {
        Company *apple = [[Company alloc]initWithCompanyName:@"Apple" companyLogo:@"apple.png"];
        Company *samsung = [[Company alloc]initWithCompanyName:@"Samsung" companyLogo:@"samsung.png"];
        Company *google = [[Company alloc]initWithCompanyName:@"Google" companyLogo:@"google.png"];
        Company *sprint = [[Company alloc]initWithCompanyName:@"Sprint" companyLogo:@"sprint.png"];
        Product *iPad = [[Product alloc]initWithProductName:@"iPad" productURL:@"https://www.apple.com/ipad"];
        Product *iPodTouch = [[Product alloc]initWithProductName:@"iPod Touch" productURL:@"https://www.apple.com/ipod-touch"];
        Product *iPhone = [[Product alloc]initWithProductName:@"iPhone" productURL:@"https://www.apple.com/iPhone"];
        Product *GalaxyS4 = [[Product alloc]initWithProductName:@"GalaxyS4" productURL:@"http://www.samsung.com/us/mobile/cell-phones/SCH-I545ZKAVZW"];
        Product *GalaxyNote = [[Product alloc]initWithProductName:@"Galaxy Note" productURL:@"http://www.samsung.com/us/mobile/galaxy-note/"];
        Product *GalaxyTab = [[Product alloc]initWithProductName:@"Galaxy Tab" productURL:@"http://www.samsung.com/us/mobile/galaxy-tab/"];
        Product *Nexus5X = [[Product alloc]initWithProductName:@"Nexus 5X" productURL:@"https://www.google.com/nexus/5x/"];
        Product *Nexus6P = [[Product alloc]initWithProductName:@"Nexus 6P" productURL:@"https://www.google.com/nexus/6p"];
        Product *Nexus9 = [[Product alloc]initWithProductName:@"Nexus 9" productURL:@"https://www.google.com/nexus/9"];
        Product *Nextel = [[Product alloc]initWithProductName:@"Nextel" productURL:@"http://www.amazon.com/Motorola-Nextel-Boost-Mobile-Phone/dp/B003APT3KU/ref=sr_1_1?ie=UTF8&qid=1461951678&sr=8-1&keywords=nextel"];
        Product *BlackBerry = [[Product alloc]initWithProductName:@"Blackberry" productURL:@"http://www.amazon.com/BlackBerry-Classic-Factory-Unlocked-Cellphone/dp/B00OYZZ3VS/ref=sr_1_3?ie=UTF8&qid=1461951711&sr=8-3&keywords=blackberry"];
        Product *MotorolaRazr = [[Product alloc]initWithProductName:@"Motorla Razr" productURL:@"http://www.amazon.com/Motorola-V3-Unlocked-Player--U-S-Warranty/dp/B0016JDE34/ref=sr_1_1?s=wireless&ie=UTF8&qid=1461951732&sr=1-1&keywords=motorola+razr"];
        
        
        apple.products = [NSMutableArray arrayWithObjects:iPad,iPodTouch, iPhone,nil];
        samsung.products =[NSMutableArray arrayWithObjects:GalaxyS4,GalaxyNote, GalaxyTab,nil];
        google.products = [NSMutableArray arrayWithObjects:Nexus5X,Nexus6P, Nexus9,nil];
        sprint.products = [NSMutableArray arrayWithObjects:Nextel,BlackBerry, MotorolaRazr,nil];
       
        
        self.companies = [NSMutableArray arrayWithObjects:apple,samsung, google, sprint,nil];
        
    }
    return self;
}

- (void)customMethod {
    // implement your custom code here
}

// singleton methods


- (id)retain {
    return self;
}

- (NSUInteger)retainCount {
    return NSUIntegerMax;  // denotes an object that cannot be released
}


- (id)autorelease {
    return self;
}

-(void)dealloc {
    [super dealloc];
}

@end