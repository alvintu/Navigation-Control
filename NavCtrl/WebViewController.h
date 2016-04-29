//
//  WebViewController.h
//  NavCtrl
//
//  Created by Jo Tu on 4/29/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductViewController.h"
@import WebKit;
@interface WebViewController : UIViewController <WKNavigationDelegate, WKUIDelegate>
@property (nonatomic, retain) NSString *link;


@end
