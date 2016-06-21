//
//  ProtoCell.m
//  NavCtrl
//
//  Created by Jo Tu on 6/7/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import "ProtoCell.h"

@implementation ProtoCell


- (void)dealloc {
//    [_deleteButton release];
    [_stockPriceLabel release];
    [_editButton release];
    [super dealloc];
}
- (IBAction)deleteButton:(id)sender {
}
@end
