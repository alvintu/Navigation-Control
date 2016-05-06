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
        Company *apple = [[Company alloc]initWithCompanyName:@"Apple" companyLogo:@"apple.png" companySYM:@"AAPL"];
        Company *samsung = [[Company alloc]initWithCompanyName:@"Samsung" companyLogo:@"samsung.png" companySYM:@"SSNLF"];
        Company *google = [[Company alloc]initWithCompanyName:@"Google" companyLogo:@"google.png" companySYM:@"GOOG"];
        Company *sprint = [[Company alloc]initWithCompanyName:@"Sprint" companyLogo:@"sprint.png" companySYM:@"S"];
        Product *iPad = [[Product alloc]initWithProductName:@"iPad" productURL:@"https://www.apple.com/ipad" productLogo:@"ipad.jpg"];
        Product *iPodTouch = [[Product alloc]initWithProductName:@"iPod Touch" productURL:@"https://www.apple.com/ipod-touch" productLogo:@"ipodtouch.jpg"];
        Product *iPhone = [[Product alloc]initWithProductName:@"iPhone" productURL:@"https://www.apple.com/iPhone" productLogo:@"iphone.jpg"];
        Product *GalaxyS4 = [[Product alloc]initWithProductName:@"GalaxyS4" productURL:@"http://www.samsung.com/us/mobile/cell-phones/SCH-I545ZKAVZW" productLogo:@"galaxys4.jpg"];
        Product *GalaxyNote = [[Product alloc]initWithProductName:@"Galaxy Note" productURL:@"http://www.samsung.com/us/mobile/galaxy-note/" productLogo:@"galaxynote.png"];
        Product *GalaxyTab = [[Product alloc]initWithProductName:@"Galaxy Tab" productURL:@"http://www.samsung.com/us/mobile/galaxy-tab/" productLogo:@"galaxytab.jpg"];
        Product *Nexus5X = [[Product alloc]initWithProductName:@"Nexus 5X" productURL:@"https://www.google.com/nexus/5x/" productLogo:@"nexus5x.jpg"];
        Product *Nexus6P = [[Product alloc]initWithProductName:@"Nexus 6P" productURL:@"https://www.google.com/nexus/6p" productLogo:@"nexus6.jpg"];
        Product *Nexus9 = [[Product alloc]initWithProductName:@"Nexus 9" productURL:@"https://www.google.com/nexus/9" productLogo:@"nexus9.jpg"];
        Product *Nextel = [[Product alloc]initWithProductName:@"Nextel" productURL:@"http://www.amazon.com/Motorola-Nextel-Boost-Mobile-Phone/dp/B003APT3KU/ref=sr_1_1?ie=UTF8&qid=1461951678&sr=8-1&keywords=nextel" productLogo:@"nextel.jpg"];
        Product *BlackBerry = [[Product alloc]initWithProductName:@"Blackberry" productURL:@"http://www.amazon.com/BlackBerry-Classic-Factory-Unlocked-Cellphone/dp/B00OYZZ3VS/ref=sr_1_3?ie=UTF8&qid=1461951711&sr=8-3&keywords=blackberry"productLogo:@"blackberry.jpg"];
        Product *MotorolaRazr = [[Product alloc]initWithProductName:@"Motorla Razr" productURL:@"http://www.amazon.com/Motorola-V3-Unlocked-Player--U-S-Warranty/dp/B0016JDE34/ref=sr_1_1?s=wireless&ie=UTF8&qid=1461951732&sr=1-1&keywords=motorola+razr" productLogo:@"razr.jpg"];
        
        
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