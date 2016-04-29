//
//  ProductViewController.h
//  NavCtrl
//
//  Created by Aditya Narayan on 10/22/13.
//  Copyright (c) 2013 Aditya Narayan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WebViewController;

@interface ProductViewController : UITableViewController
@property (nonatomic, retain) NSMutableArray *products;
@property (nonatomic, retain) NSArray *logos;
@property (nonatomic, retain) NSArray *productLinks;


@property (nonatomic, retain) WebViewController *webViewController;

@end
