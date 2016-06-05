//
//  NSManagedObject+CoreDataProperties.h
//  NavCtrl
//
//  Created by Jo Tu on 6/3/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "NSManagedObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSManagedObject (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *comp_id;
@property (nullable, nonatomic, retain) NSString *comp_logo;
@property (nullable, nonatomic, retain) NSString *comp_name;
@property (nullable, nonatomic, retain) NSString *comp_sym;
@property (nullable, nonatomic, retain) NSNumber *position;
@property (nullable, nonatomic, retain) NSManagedObject *products;

@end

NS_ASSUME_NONNULL_END
