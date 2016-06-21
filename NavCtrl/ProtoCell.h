//
//  ProtoCell.h
//  NavCtrl
//
//  Created by Jo Tu on 6/7/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProtoCell : UICollectionViewCell

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UIButton *deleteButton;
@property (retain, nonatomic) IBOutlet UILabel *stockPriceLabel;
@property (retain, nonatomic) IBOutlet UIButton *editButton;


@end
