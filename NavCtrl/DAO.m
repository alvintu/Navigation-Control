//
//  DAO.m
//  NavCtrl
//
//  Created by Jo Tu on 5/2/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import "DAO.h"
#import "sqlite3.h"



@interface DAO ()
{
    sqlite3 *CompanyDB;
    NSString *dbPathString;
    //    NSString *sqLiteDb;
    NSString *compdataPath;
    NSString *dataPath;
    bool hasItRun;
    NSMutableArray *productArray;
    
}

@end

@implementation DAO

static DAO *sharedDAO = nil;    // static instance variable

+ (DAO *)sharedDAO {
    if (sharedDAO == nil) {
        sharedDAO = [[super alloc] init];
        
    }
    return sharedDAO;
}

-(NSString*) applicationDocumentsDirectory{
    // Get the documents directory
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    NSLog(@"%@",docsDir);
    return [docsDir stringByAppendingPathComponent:@"info"];
}
- (id)init {
    if (self = [super init]) {
        [self createOrOpenDB];
        _companies = [[NSMutableArray alloc]init];
        [self readDatabase];
        
    }
    return self;
}


-(void)undoChanges{
    [self.context undo];
    
    
    
    [self.companies removeAllObjects];
    [self readDatabase];
}

-(void)undoProductChanges{
    //    [self.context setUndoManager:undoManager];
    [self.context undo];
    
    
//    [self.context.undoManager setLevelsOfUndo:1];

    for(Company *company in self.companies){
        [company.products removeAllObjects];
        
        //getting close it's reading the database and repopulating it..i dont think undo is working
   
    
//        for(Company *company in self.companies){
//            [company.products removeAllObjects];
//        }
//
        [self populateProductsBasedOnCompanyID:company];

    }

    //    [undoManager release];
    //    [self.context reset];
}




-(void)createOrOpenDB
{
    
    // 1. Creating ObjectModel which describes the schema.
    [self setModel:[NSManagedObjectModel mergedModelFromBundles:nil]];
    
    NSPersistentStoreCoordinator *psc =
    [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self model]];
    
    // 2. Creating Context.
    NSString *path = [self applicationDocumentsDirectory];
    NSURL *storeURL = [NSURL fileURLWithPath:path];
    NSError *error = nil;
    
    if(![psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        [NSException raise:@"Open failed" format:@"Reason: %@", [error localizedDescription]];
    }
    [self setContext:[[NSManagedObjectContext alloc] init]];
    
    //Add an undo manager
    
        self.context.undoManager = [[NSUndoManager alloc] init];
    //3. Now the context points to the SQLite store
    [[self context] setPersistentStoreCoordinator:psc];
    //    [[self context] setUndoManager:nil];
    
    [self fetchRequestIfAppHasRun];
    
    
    
}

-(void)readDatabase  {
    
    
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    
    //A predicate template can also be used
    NSPredicate *p = [NSPredicate predicateWithFormat:@"comp_id >=0"];
    [request setPredicate:p];
    
    
    
    //Change ascending  YES/NO and validate
    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc]
                                    initWithKey:@"position" ascending:YES];
    
    [request setSortDescriptors:[NSArray arrayWithObject:sortByName]];
    
    NSEntityDescription *e = [[[self model] entitiesByName] objectForKey:@"Company"];
    [request setEntity:e];
    NSError *error = nil;
    
    
    //This gets data only from context, not from store
    NSArray *result = [[self context] executeFetchRequest:request error:&error];
    
    
    
    if(!result)
    {
        [NSException raise:@"Fetch Failed" format:@"Reason: %@", [error localizedDescription]];
    }
    
    
//        [self.companies removeAllObjects];
    for(NSManagedObject* object in result){
        Company *comp = [[Company alloc]init];
        comp.companyName = [object valueForKey:@"comp_name"];
        comp.companyID = [object valueForKey:@"comp_id"];
        comp.companySYM = [object valueForKey:@"comp_sym"];
        comp.companyLogo = [object valueForKey:@"comp_logo"];
        [self.companies addObject:comp];
//        [productArray removeAllObjects];

        [self populateProductsBasedOnCompanyID:comp];
//        comp.products = productArray;
    }
    
    //    [self setCompanies:[[NSMutableArray alloc]initWithArray:result]];
    
    
}


-(int)addCompany:(Company*)newCompany {
    
    int newCompanyPosition = (int)([self.companies count] -1 );

    NSNumber *pk = [NSNumber numberWithInt:[[NSDate date] timeIntervalSince1970]];
    NSLog(@"PK: %@", pk);
    
    newCompany.companyID = pk;
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Company" inManagedObjectContext:self.context];
    NSManagedObject *newMOCompany=[[NSManagedObject alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:self.context];
    
    [newMOCompany setValue:pk forKey:@"comp_id"];
    [newMOCompany setValue:newCompany.companySYM forKey:@"comp_sym"];
    [newMOCompany setValue:newCompany.companyLogo forKey:@"comp_logo"];
    [newMOCompany setValue:newCompany.companyName forKey:@"comp_name"];
    [newMOCompany setValue:[NSNumber numberWithInt:newCompanyPosition ] forKey:@"position"];

//    [self saveChanges];
    
    
    return (int)pk;
    //    char *error1;
    //
    //
    //    NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO COMPANY(companyname,companylogo,companysym,position) VALUES (\"%@\",\"%@\",\"%@\",\"%lu\")",newCompany.companyName,newCompany.companyLogo,newCompany.companySYM,([self.companies count]-1)];
    //    const char *insert_sql = [insertSQL UTF8String];
    //
    //    if (sqlite3_exec(CompanyDB, insert_sql, NULL, NULL, &error1) == SQLITE_OK)
    //    {
    //        NSLog(@"company added");
    //    }
    //    NSLog(@"id %d", (int)sqlite3_last_insert_rowid(CompanyDB));
    //    return (int)sqlite3_last_insert_rowid(CompanyDB);
    
}

-(void)deleteProductsRelatedToCompanyID:(Company*)company{
    
    for(int i = 0; i < [company.products count]; i++){
    
    NSFetchRequest *productRequest = [[NSFetchRequest alloc]init];
    NSPredicate *o = [NSPredicate predicateWithFormat:@"comp_id=%@",company.companyID];
    [productRequest setPredicate:o];
    NSEntityDescription *f = [[[self model] entitiesByName] objectForKey:@"Product"];
    [productRequest setEntity:f];
    NSError *error = nil;
    
    NSArray *productResult = [[self context] executeFetchRequest:productRequest error:&error];
    
    if(!productResult)
    {
        [NSException raise:@"Fetch Failed" format:@"Reason: %@", [error localizedDescription]];
    }
    
    if ([productResult count] > 0) {
        
        for(NSManagedObject *MOproduct in productResult){
            MOproduct = [productResult objectAtIndex:0];
            //continue...
            
            [self.context deleteObject:MOproduct];
            
//            [self saveChanges];
            NSError *deleteError = nil;
            
            if (![MOproduct.managedObjectContext save:&deleteError]) {
                NSLog(@"Unable to save managed object context.");
                NSLog(@"%@, %@", deleteError, deleteError.localizedDescription);
            }
        }
    }}
    [company.products removeAllObjects];
}
    



-(void)deleteCompany:(Company*)selectedCompany  {
    [self deleteProductsRelatedToCompanyID:selectedCompany];
    
    //    Company *c = [[self companies] objectAtIndex:indexofCompany];
    
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    
    //A predicate template can also be used
    NSPredicate *p = [NSPredicate predicateWithFormat:@"comp_id=%@ and comp_name =%@",selectedCompany.companyID,selectedCompany.companyName];
    
    [request setPredicate:p];
    
    NSEntityDescription *e = [[[self model] entitiesByName] objectForKey:@"Company"];
    [request setEntity:e];

    NSError *error = nil;
    
    
    //This gets data only from context, not from store
    NSArray *result = [[self context] executeFetchRequest:request error:&error];
  
    if(!result)
    {
        [NSException raise:@"Fetch Failed" format:@"Reason: %@", [error localizedDescription]];
    }
    
    if ([result count] > 0) {
        NSManagedObject* company = [result objectAtIndex:0];
        //continue...
        
        
        //Remove object from context
        //    NSManagedObject *company = (NSManagedObject *)[result objectAtIndex:[self.companies indexOfObject:selectedCompany]];
        
        [self.context deleteObject:company];
        
        NSError *deleteError = nil;
        
        if (![company.managedObjectContext save:&deleteError]) {
            NSLog(@"Unable to save managed object context.");
            NSLog(@"%@, %@", deleteError, deleteError.localizedDescription);
        }
//        [self saveChanges];

    }
    [self.companies removeObject:selectedCompany];

}





-(void)editCompany:(Company*)selectedCompany  {
    
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    
    //A predicate template can also be used
    NSPredicate *p = [NSPredicate predicateWithFormat:@"comp_id = %i",[selectedCompany.companyID intValue]];
    [request setPredicate:p];
    
    NSEntityDescription *e = [[[self model] entitiesByName] objectForKey:@"Company"];
    [request setEntity:e];
    NSError *error = nil;
    
    
    //This gets data only from context, not from store
    NSArray *result = [[self context] executeFetchRequest:request error:&error];
    NSManagedObject *company = (NSManagedObject *)[result objectAtIndex:0];

    
    
    if(!result)
    {
        [NSException raise:@"Fetch Failed" format:@"Reason: %@", [error localizedDescription]];
    }
    
    if ([result count] > 0) {
        //continue...
        
        
        //Remove object from context
        //    NSManagedObject *company = (NSManagedObject *)[result objectAtIndex:[self.companies indexOfObject:selectedCompany]];
        NSNumber *pk = [NSNumber numberWithInt:[[NSDate date] timeIntervalSince1970]];
        NSLog(@"PK: %@", pk);
        
//        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Company" inManagedObjectContext:self.context];

        
//        [company setValue:pk forKey:@"comp_id"];
        [company setValue:selectedCompany.companySYM forKey:@"comp_sym"];
        [company setValue:selectedCompany.companyLogo forKey:@"comp_logo"];
        [company setValue:selectedCompany.companyName forKey:@"comp_name"];
    }

        NSError *saveError = nil;
        
        if (![company.managedObjectContext save:&saveError]) {
            NSLog(@"Unable to save managed object context.");
            NSLog(@"%@, %@", saveError, saveError.localizedDescription);
        }

//    [self saveChanges];
    
    }

    

    


-(void)trackCompanyPosition{ //tracks companies positions by setting position using for in loop within method, then extracting values setting them(ints)to NSNumber to pass into core data
//this took me half a day :(
    
    
    for(Company *company in self.companies){
                [company setPosition:(int)[self.companies indexOfObject:company]];

        
    }

    
    for(Company *company in self.companies){
    
    
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    
    //A predicate template can also be used
    NSPredicate *p = [NSPredicate predicateWithFormat:@"comp_id =%i",[company.companyID intValue]];
    [request setPredicate:p];
    
    NSEntityDescription *e = [[[self model] entitiesByName] objectForKey:@"Company"];
    [request setEntity:e];
    NSError *error = nil;
    
    
    //This gets data only from context, not from store
    NSArray *result = [[self context] executeFetchRequest:request error:&error];
    NSManagedObject *MOcompany = (NSManagedObject *)[result objectAtIndex:0];
    
    
    
    if(!result)
    {
        [NSException raise:@"Fetch Failed" format:@"Reason: %@", [error localizedDescription]];
    }
        
    
    if ([result count] > 0) {
        
            for(NSManagedObject *object in result ){

//                [object setValue:[NSNumber numberWithInt:(int)[result indexOfObject:object] ] forKey:@"position"];
                [object setValue:[NSNumber numberWithInt:company.position] forKey:@"position"];

        
            
        }
//        [self saveChanges];

    }
        
    
    NSError *saveError = nil;
    
    if (![MOcompany.managedObjectContext save:&saveError]) {
        NSLog(@"Unable to save managed object context.");
        NSLog(@"%@, %@", saveError, saveError.localizedDescription);
    }
    }
    
    
    
 
    
    

    
    //    char *error1;
    //
//        for(int i = 0; i < self.companies.count; i++){
//            Company*company = (Company*)self.companies[i];
    //        NSString *trackpositionSQL = [NSString stringWithFormat:@"UPDATE COMPANY SET position = '%d' WHERE companyid = '%d'", i,[company.companyID intValue]];
    //        const char *trackposition_sql = [trackpositionSQL UTF8String];
    //        if (sqlite3_exec(CompanyDB, trackposition_sql, NULL, NULL, &error1) == SQLITE_OK) {
    //            NSLog(@"position changed");
    //        }
    //
    //        trackpositionSQL = nil;
    //    }
    
    
    
    
    
}

-(void)addProduct:(Product*)newProduct  selectedCompanyID:(NSNumber*)selectedCompanyID indexOfProduct:(NSInteger)indexOfProduct {
    

    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Product" inManagedObjectContext:self.context];
    NSManagedObject *newMOProduct=[[NSManagedObject alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:self.context];
    [newMOProduct setValue:newProduct.comp_id forKey:@"comp_id"];
    [newMOProduct setValue:newProduct.productName forKey:@"prod_name"];
    [newMOProduct setValue:newProduct.productURL forKey:@"prod_url"];
    [newMOProduct setValue:newProduct.productLogo forKey:@"prod_logo"];
    [newMOProduct setValue:[NSNumber numberWithInteger:indexOfProduct] forKey:@"prod_position"];
    
//    [self saveChanges];
    
    //    char *error1;
    //
    //
    //    NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO PRODUCTS(productname,productlogo,productURL,companyid,position) VALUES (\"%@\",\"%@\",\"%@\",\"%ld\",\"%li\")",newProduct.productName,newProduct.productLogo,newProduct.productURL, (long)selectedCompanyID,(long)indexOfProduct ];
    //    const char *insert_sql = [insertSQL UTF8String];
    //
    //    if (sqlite3_exec(CompanyDB, insert_sql, NULL, NULL, &error1) == SQLITE_OK)
    //    {
    //
    //        NSLog(@"product added");
    //
    //    }
}


-(void)deleteProduct:(Product*)selectedProduct{
    
    //    Company *c = [[self companies] objectAtIndex:indexofCompany];
    
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    
    //A predicate template can also be used
    NSPredicate *p = [NSPredicate predicateWithFormat:@"prod_name = %@  and prod_logo= %@ and comp_id =%@ and prod_url = %@",selectedProduct.productName, selectedProduct.productLogo,selectedProduct.comp_id,selectedProduct.productURL];
    [request setPredicate:p];
    
    NSEntityDescription *e = [[[self model] entitiesByName] objectForKey:@"Product"];
    [request setEntity:e];
    NSError *error = nil;
    
    
    //This gets data only from context, not from store
    NSArray *result = [[self context] executeFetchRequest:request error:&error];
    
    
    
    if(!result)
    {
        [NSException raise:@"Fetch Failed" format:@"Reason: %@", [error localizedDescription]];
    }
    
    if ([result count] > 0) {
        NSManagedObject* product = [result objectAtIndex:0];
        //continue...
        
        
        //Remove object from context
        //    NSManagedObject *company = (NSManagedObject *)[result objectAtIndex:[self.companies indexOfObject:selectedCompany]];
        
        [self.context deleteObject:product];
        for(Company *company in self.companies){
            if(company.companyID == selectedProduct.comp_id){
            [company.products removeObject:selectedProduct];
        }
        }

        
        NSError *deleteError = nil;
        
        if (![product.managedObjectContext save:&deleteError]) {
            NSLog(@"Unable to save managed object context.");
            NSLog(@"%@, %@", deleteError, deleteError.localizedDescription);
        }
//        [self saveChanges];
        
        
        
    }

    
    //    char *error1;
    //    NSString *deleteSQL = [NSString stringWithFormat:@"DELETE FROM PRODUCTS WHERE  productname= \"%@\" AND productlogo=\"%@\" LIMIT 1",selectedProduct.productName, selectedProduct.productLogo];
    //    const char *delete_sql = [deleteSQL UTF8String];
    //
    //    //
    //    if (sqlite3_exec(CompanyDB, delete_sql, NULL, NULL, &error1) == SQLITE_OK) {
    //        NSLog(@"product deleted");
    //    }
    
}
-(void)editProducts:(Product*)selectedProduct{
    
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    
    //A predicate template can also be used
    NSPredicate *p = [NSPredicate predicateWithFormat:@"comp_id = %@ and prod_logo = %@",selectedProduct.comp_id,selectedProduct.productLogo];

    [request setPredicate:p];
    
    NSEntityDescription *e = [[[self model] entitiesByName] objectForKey:@"Product"];
    [request setEntity:e];
    NSError *error = nil;
    
    
    //This gets data only from context, not from store
    NSArray *result = [[self context] executeFetchRequest:request error:&error];
    NSManagedObject *product = (NSManagedObject *)[result objectAtIndex:0];
    
    
    
    if(!result)
    {
        [NSException raise:@"Fetch Failed" format:@"Reason: %@", [error localizedDescription]];
    }
    
    if ([result count] > 0) {
        //continue...
        
        
        //Remove object from context
        //    NSManagedObject *company = (NSManagedObject *)[result objectAtIndex:[self.companies indexOfObject:selectedCompany]];
        
        //        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Company" inManagedObjectContext:self.context];
        
        
//        [company setValue:pk forKey:@"comp_id"];
        [product setValue:selectedProduct.productName forKey:@"prod_name"];
        [product setValue:selectedProduct.productURL forKey:@"prod_url"];
        [product setValue:selectedProduct.productLogo forKey:@"prod_logo"];
    }
    
    NSError *saveError = nil;
    
    if (![product.managedObjectContext save:&saveError]) {
        NSLog(@"Unable to save managed object context.");
        NSLog(@"%@, %@", saveError, saveError.localizedDescription);
    }
    
//    [self saveChanges];
    
}

    
    //
    //    char *error1;
    //    NSString *updateSQL = [NSString stringWithFormat:@"UPDATE PRODUCTS SET productname = \"%@\",producturl = \"%@\" WHERE companyid = \"%@\" AND productlogo = \"%@\"",selectedProduct.productName,selectedProduct.productURL,selectedCompany.companyID,selectedProduct.productLogo];
    //    const char *update_sql = [updateSQL UTF8String];
    //
    //    //
    //    if (sqlite3_exec(CompanyDB, update_sql, NULL, NULL, &error1) == SQLITE_OK)
    //    {
    //        NSLog(@"product updated");
    //    }
    



-(void)trackProductsPosition:(NSMutableArray*)products selectedCompany:(Company*)selectedCompany{
    
    for(Product *product in selectedCompany.products){
        [product setProductPosition:(int)[selectedCompany.products indexOfObject:product]];
        
        
    }
    
    
    for(Product *product in selectedCompany.products){
        
        
        NSFetchRequest *request = [[NSFetchRequest alloc]init];
        
        //A predicate template can also be used
        NSPredicate *p = [NSPredicate predicateWithFormat:@"comp_id =%@ and prod_logo = %@",selectedCompany.companyID,product.productLogo];
        [request setPredicate:p];
        
        NSSortDescriptor *sortByName = [[NSSortDescriptor alloc]
                                        initWithKey:@"prod_position" ascending:YES];
        
        [request setSortDescriptors:[NSArray arrayWithObject:sortByName]];
        NSEntityDescription *e = [[[self model] entitiesByName] objectForKey:@"Product"];
        [request setEntity:e];
        NSError *error = nil;
        
        
        //This gets data only from context, not from store
        NSArray *result = [[self context] executeFetchRequest:request error:&error];
        NSManagedObject *MOcompany = (NSManagedObject *)[result objectAtIndex:0];
        
        
        
        if(!result)
        {
            [NSException raise:@"Fetch Failed" format:@"Reason: %@", [error localizedDescription]];
        }
        
        
        if ([result count] > 0) {
            
            for(NSManagedObject *object in result ){
                
                //                [object setValue:[NSNumber numberWithInt:(int)[result indexOfObject:object] ] forKey:@"position"];
                [object setValue:[NSNumber numberWithInt:product.productPosition] forKey:@"prod_position"];
                
                
                
            }
//            [self saveChanges];
            
        }
        
        
        NSError *saveError = nil;
        
        if (![MOcompany.managedObjectContext save:&saveError]) {
            NSLog(@"Unable to save managed object context.");
            NSLog(@"%@, %@", saveError, saveError.localizedDescription);
        }
    }
    
    
    
    
    
    
    
    
    //    char *error1;
    //
    //    for(Product* product in products){
    //        NSString *trackpositionSQL = [NSString stringWithFormat:@"UPDATE PRODUCTS SET position = \"%lu\" WHERE companyid = \"%@\" AND productlogo=\"%@\"",(unsigned long)[products indexOfObject:product],selectedCompany.companyID, [product productLogo]];
    //        const char *trackposition_sql = [trackpositionSQL UTF8String];
    //
    //        if (sqlite3_exec(CompanyDB, trackposition_sql, NULL, NULL, &error1) == SQLITE_OK)
    //        {
    //            NSLog(@"product position changed");
    //        }
    //    }
}


- (id)retain {
    return self;
}

- (NSUInteger)retainCount {
    return NSUIntegerMax;  // denotes an object that cannot be released
}

-(void) saveChanges
{
    NSError *err = nil;
    BOOL successful = [[self context] save:&err];
    if(!successful)
    {
        NSLog(@"Error saving: %@", [err localizedDescription]);
    }
    NSLog(@"Data Saved");
    [self.context.undoManager removeAllActions];
    
}

-(void)fetchRequestIfAppHasRun{
    
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    
    NSEntityDescription *e = [[[self model] entitiesByName] objectForKey:@"RunOnceOnly"];
    [request setEntity:e];
    NSError *error1 = nil;
    //This gets data only from context, not from store
    NSArray *result = [[self context] executeFetchRequest:request error:&error1];
    if(!result)
    {
        [NSException raise:@"Fetch Failed" format:@"Reason: %@", [error1 localizedDescription]];
    }
    
    
    
    for(NSManagedObject* object in result){
        hasItRun = [object valueForKey:@"hasItBeenRun"]; //has it run? if not load hardcodedvals
    }
    if(hasItRun == false){
        [self changeBoolEntitytoRun];
        
        [self loadHardCodedCoreDataValues];
        
    }
    else{
        
        
        hasItRun = true;
    }
    
    
    
}
-(void)changeBoolEntitytoRun{
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"RunOnceOnly" inManagedObjectContext:self.context];
    NSManagedObject *runOnceCheck=[[NSManagedObject alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:self.context];
    [runOnceCheck setValue:@TRUE forKey:@"hasItBeenRun"]; //setting true to bool
    hasItRun = runOnceCheck;
    
    
}


-(void)loadHardCodedCoreDataValues{
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Company" inManagedObjectContext:self.context];
        NSManagedObject *newMOCompany=[[NSManagedObject alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:self.context];
        [newMOCompany setValue:[NSNumber numberWithInt:0] forKey:@"comp_id"];
        [newMOCompany setValue:[NSNumber numberWithInt:0] forKey:@"position"];
        [newMOCompany setValue:@"AAPL" forKey:@"comp_sym"];
        [newMOCompany setValue:@"apple.png" forKey:@"comp_logo"];
        [newMOCompany setValue:@"Apple" forKey:@"comp_name"];
    
    NSEntityDescription *entityDescription1 = [NSEntityDescription entityForName:@"Company" inManagedObjectContext:self.context];
    NSManagedObject *newMOCompany1=[[NSManagedObject alloc] initWithEntity:entityDescription1 insertIntoManagedObjectContext:self.context];
    [newMOCompany1 setValue:[NSNumber numberWithInt:1] forKey:@"comp_id"];
    [newMOCompany1 setValue:[NSNumber numberWithInt:1]forKey:@"position"];
    [newMOCompany1 setValue:@"SSNLF" forKey:@"comp_sym"];
    [newMOCompany1 setValue:@"samsung.png" forKey:@"comp_logo"];
    [newMOCompany1 setValue:@"Samsung" forKey:@"comp_name"];

    NSEntityDescription *entityDescription2 = [NSEntityDescription entityForName:@"Company" inManagedObjectContext:self.context];
    NSManagedObject *newMOCompany2=[[NSManagedObject alloc] initWithEntity:entityDescription2 insertIntoManagedObjectContext:self.context];
    [newMOCompany2 setValue:[NSNumber numberWithInt:2] forKey:@"comp_id"];
    [newMOCompany2 setValue:[NSNumber numberWithInt:2] forKey:@"position"];
    [newMOCompany2 setValue:@"GOOG" forKey:@"comp_sym"];
    [newMOCompany2 setValue:@"google.jpg" forKey:@"comp_logo"];
    [newMOCompany2 setValue:@"Google" forKey:@"comp_name"];

    NSEntityDescription *entityDescription3 = [NSEntityDescription entityForName:@"Company" inManagedObjectContext:self.context];
    NSManagedObject *newMOCompany3=[[NSManagedObject alloc] initWithEntity:entityDescription3 insertIntoManagedObjectContext:self.context];
    [newMOCompany3 setValue:[NSNumber numberWithInt:3] forKey:@"comp_id"];
    [newMOCompany3 setValue:[NSNumber numberWithInt:3] forKey:@"position"];
    [newMOCompany3 setValue:@"S" forKey:@"comp_sym"];
    [newMOCompany3 setValue:@"sprint.jpg" forKey:@"comp_logo"];
    [newMOCompany3 setValue:@"Sprint" forKey:@"comp_name"];
    
    NSEntityDescription *productEntityDescription = [NSEntityDescription entityForName:@"Product" inManagedObjectContext:self.context];
    NSManagedObject *newMOProduct=[[NSManagedObject alloc] initWithEntity:productEntityDescription insertIntoManagedObjectContext:self.context];
    //    [newMOCompany3 setValue:pk forKey:@"comp_id"];
    [newMOProduct setValue:[NSNumber numberWithInt:0] forKey:@"comp_id"];
    [newMOProduct setValue:[NSNumber numberWithInt:0] forKey:@"prod_position"];
    [newMOProduct setValue:@"iPad" forKey:@"prod_name"];
    [newMOProduct setValue:@"https://www.apple.com/ipad" forKey:@"prod_url"];
    [newMOProduct setValue:@"ipad.jpg" forKey:@"prod_logo"];
    
    NSEntityDescription *productEntityDescription1 = [NSEntityDescription entityForName:@"Product" inManagedObjectContext:self.context];
    NSManagedObject *newMOProduct1 =[[NSManagedObject alloc] initWithEntity:productEntityDescription1 insertIntoManagedObjectContext:self.context];
    //    [newMOCompany3 setValue:pk forKey:@"comp_id"];
    [newMOProduct1 setValue:[NSNumber numberWithInt:0] forKey:@"comp_id"];
    [newMOProduct1 setValue:[NSNumber numberWithInt:1] forKey:@"prod_position"];
    [newMOProduct1 setValue:@"iPod Touch" forKey:@"prod_name"];
    [newMOProduct1 setValue:@"https://www.apple.com/ipod-touch" forKey:@"prod_url"];
    [newMOProduct1 setValue:@"ipodtouch.jpg" forKey:@"prod_logo"];
    
    
    NSEntityDescription *productEntityDescription2 = [NSEntityDescription entityForName:@"Product" inManagedObjectContext:self.context];
    NSManagedObject *newMOProduct2=[[NSManagedObject alloc] initWithEntity:productEntityDescription2 insertIntoManagedObjectContext:self.context];
    //    [newMOCompany3 setValue:pk forKey:@"comp_id"];
    [newMOProduct2 setValue:[NSNumber numberWithInt:0] forKey:@"comp_id"];
    [newMOProduct2 setValue:[NSNumber numberWithInt:2] forKey:@"prod_position"];
    [newMOProduct2 setValue:@"iPhone" forKey:@"prod_name"];
    [newMOProduct2 setValue:@"https://www.apple.com/iPhone" forKey:@"prod_url"];
    [newMOProduct2 setValue:@"iphone.jpg" forKey:@"prod_logo"];
    
    NSEntityDescription *productEntityDescription3 = [NSEntityDescription entityForName:@"Product" inManagedObjectContext:self.context];
    NSManagedObject *newMOProduct3=[[NSManagedObject alloc] initWithEntity:productEntityDescription3 insertIntoManagedObjectContext:self.context];
    //    [newMOCompany3 setValue:pk forKey:@"comp_id"];
    [newMOProduct3 setValue:[NSNumber numberWithInt:1] forKey:@"comp_id"];
    [newMOProduct3 setValue:[NSNumber numberWithInt:0] forKey:@"prod_position"];
    [newMOProduct3 setValue:@"Galaxy S4" forKey:@"prod_name"];
    [newMOProduct3 setValue:@"http://www.samsung.com/us/mobile/cell-phones/SCH-I545ZKAVZW" forKey:@"prod_url"];
    [newMOProduct3 setValue:@"galaxys4.jpg" forKey:@"prod_logo"];
    
    NSEntityDescription *productEntityDescription4 = [NSEntityDescription entityForName:@"Product" inManagedObjectContext:self.context];
    NSManagedObject *newMOProduct4 =[[NSManagedObject alloc] initWithEntity:productEntityDescription4 insertIntoManagedObjectContext:self.context];
    //    [newMOCompany3 setValue:pk forKey:@"comp_id"];
    [newMOProduct4 setValue:[NSNumber numberWithInt:1] forKey:@"comp_id"];
    [newMOProduct4 setValue:[NSNumber numberWithInt:1] forKey:@"prod_position"];
    [newMOProduct4 setValue:@"Galaxy Note" forKey:@"prod_name"];
    [newMOProduct4 setValue:@"http://www.samsung.com/us/mobile/galaxy-note/" forKey:@"prod_url"];
    [newMOProduct4 setValue:@"galaxynote.png" forKey:@"prod_logo"];
    
    
    NSEntityDescription *productEntityDescription5 = [NSEntityDescription entityForName:@"Product" inManagedObjectContext:self.context];
    NSManagedObject *newMOProduct5=[[NSManagedObject alloc] initWithEntity:productEntityDescription5 insertIntoManagedObjectContext:self.context];
    //    [newMOCompany3 setValue:pk forKey:@"comp_id"];
    [newMOProduct5 setValue:[NSNumber numberWithInt:1] forKey:@"comp_id"];
    [newMOProduct5 setValue:[NSNumber numberWithInt:2] forKey:@"prod_position"];
    [newMOProduct5 setValue:@"Galaxy Tab" forKey:@"prod_name"];
    [newMOProduct5 setValue:@"http://www.samsung.com/us/mobile/galaxy-tab/" forKey:@"prod_url"];
    [newMOProduct5 setValue:@"galaxytab.jpg" forKey:@"prod_logo"];
    
    
    
    NSEntityDescription *productEntityDescription6 = [NSEntityDescription entityForName:@"Product" inManagedObjectContext:self.context];
    NSManagedObject *newMOProduct6=[[NSManagedObject alloc] initWithEntity:productEntityDescription6 insertIntoManagedObjectContext:self.context];
    //    [newMOCompany3 setValue:pk forKey:@"comp_id"];
    [newMOProduct6 setValue:[NSNumber numberWithInt:2] forKey:@"comp_id"];
    [newMOProduct6 setValue:[NSNumber numberWithInt:0] forKey:@"prod_position"];
    [newMOProduct6 setValue:@"Nexus 5X" forKey:@"prod_name"];
    [newMOProduct6 setValue:@"https://www.google.com/nexus/5x/" forKey:@"prod_url"];
    [newMOProduct6 setValue:@"nexus5x.jpg" forKey:@"prod_logo"];
    
    NSEntityDescription *productEntityDescription7 = [NSEntityDescription entityForName:@"Product" inManagedObjectContext:self.context];
    NSManagedObject *newMOProduct7 =[[NSManagedObject alloc] initWithEntity:productEntityDescription7 insertIntoManagedObjectContext:self.context];
    //    [newMOCompany3 setValue:pk forKey:@"comp_id"];
    [newMOProduct7 setValue:[NSNumber numberWithInt:2] forKey:@"comp_id"];
    [newMOProduct7 setValue:[NSNumber numberWithInt:1] forKey:@"prod_position"];
    [newMOProduct7 setValue:@"Nexus 6" forKey:@"prod_name"];
    [newMOProduct7 setValue:@"https://www.google.com/nexus/6p" forKey:@"prod_url"];
    [newMOProduct7 setValue:@"nexus6.jpg" forKey:@"prod_logo"];
    
    
    NSEntityDescription *productEntityDescription8 = [NSEntityDescription entityForName:@"Product" inManagedObjectContext:self.context];
    NSManagedObject *newMOProduct8=[[NSManagedObject alloc] initWithEntity:productEntityDescription8 insertIntoManagedObjectContext:self.context];
    //    [newMOCompany3 setValue:pk forKey:@"comp_id"];
    [newMOProduct8 setValue:[NSNumber numberWithInt:2] forKey:@"comp_id"];
    [newMOProduct8 setValue:[NSNumber numberWithInt:2] forKey:@"prod_position"];
    [newMOProduct8 setValue:@"Nexus 9" forKey:@"prod_name"];
    [newMOProduct8 setValue:@"https://www.google.com/nexus/9" forKey:@"prod_url"];
    [newMOProduct8 setValue:@"nexus9.jpg" forKey:@"prod_logo"];
    
    
    NSEntityDescription *productEntityDescription9 = [NSEntityDescription entityForName:@"Product" inManagedObjectContext:self.context];
    NSManagedObject *newMOProduct9=[[NSManagedObject alloc] initWithEntity:productEntityDescription9 insertIntoManagedObjectContext:self.context];
    //    [newMOCompany3 setValue:pk forKey:@"comp_id"];
    [newMOProduct9 setValue:[NSNumber numberWithInt:3] forKey:@"comp_id"];
    [newMOProduct9 setValue:[NSNumber numberWithInt:0] forKey:@"prod_position"];
    [newMOProduct9 setValue:@"Nextel" forKey:@"prod_name"];
    [newMOProduct9 setValue:@"http://www.amazon.com/Motorola-Nextel-Boost-Mobile-Phone/dp/B003APT3KU/ref=sr_1_1?ie=UTF8&qid=1461951678&sr=8-1&keywords=nextel" forKey:@"prod_url"];
    [newMOProduct9 setValue:@"nextel.jpg" forKey:@"prod_logo"];
    
    NSEntityDescription *productEntityDescription10 = [NSEntityDescription entityForName:@"Product" inManagedObjectContext:self.context];
    NSManagedObject *newMOProduct10 =[[NSManagedObject alloc] initWithEntity:productEntityDescription10 insertIntoManagedObjectContext:self.context];
    //    [newMOCompany3 setValue:pk forKey:@"comp_id"];
    [newMOProduct10 setValue:[NSNumber numberWithInt:3] forKey:@"comp_id"];
    [newMOProduct10 setValue:[NSNumber numberWithInt:1] forKey:@"prod_position"];
    [newMOProduct10 setValue:@"Blackberry" forKey:@"prod_name"];
    [newMOProduct10 setValue:@"http://www.amazon.com/BlackBerry-Classic-Factory-Unlocked-Cellphone/dp/B00OYZZ3VS/ref=sr_1_3?ie=UTF8&qid=1461951711&sr=8-3&keywords=blackberry" forKey:@"prod_url"];
    [newMOProduct10 setValue:@"blackberry.jpg" forKey:@"prod_logo"];
    
    
    NSEntityDescription *productEntityDescription11 = [NSEntityDescription entityForName:@"Product" inManagedObjectContext:self.context];
    NSManagedObject *newMOProduct11=[[NSManagedObject alloc] initWithEntity:productEntityDescription11 insertIntoManagedObjectContext:self.context];
    //    [newMOCompany3 setValue:pk forKey:@"comp_id"];
    [newMOProduct11 setValue:[NSNumber numberWithInt:3] forKey:@"comp_id"];
    [newMOProduct11 setValue:[NSNumber numberWithInt:2] forKey:@"prod_position"];
    [newMOProduct11 setValue:@"Motorla Razr" forKey:@"prod_name"];
    [newMOProduct11 setValue:@"http://www.amazon.com/Motorola-V3-Unlocked-Player--U-S-Warranty/dp/B0016JDE34/ref=sr_1_1?s=wireless&ie=UTF8&qid=1461951732&sr=1-1&keywords=motorola+razr" forKey:@"prod_url"];
    [newMOProduct11 setValue:@"razr.jpg" forKey:@"prod_logo"];
    

    
    [self saveChanges];


    }
-(void)populateProductsBasedOnCompanyID:(Company*)selectedCompany{
    
    
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    
    //A predicate template can also be used
    NSPredicate *p = [NSPredicate predicateWithFormat:@"comp_id = %@",selectedCompany.companyID];
    [request setPredicate:p];
    
    
    
    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc]
                                    initWithKey:@"prod_position" ascending:YES];
    
    [request setSortDescriptors:[NSArray arrayWithObject:sortByName]];
    
    NSEntityDescription *e = [[[self model] entitiesByName] objectForKey:@"Product"];
    [request setEntity:e];
    NSError *error = nil;
    
    
    //This gets data only from context, not from store
    NSArray *result = [[self context] executeFetchRequest:request error:&error];
    
    
    
    if(!result)
    {
        [NSException raise:@"Fetch Failed" format:@"Reason: %@", [error localizedDescription]];
    }
    
    if ([result count] > 0) {

//            [self.companies removeAllObjects];
    for(NSManagedObject* object in result){
        
        Product *prod = [[Product alloc]init];
        prod.productName = [object valueForKey:@"prod_name"];
        prod.productURL = [object valueForKey:@"prod_url"];
        prod.productLogo = [object valueForKey:@"prod_logo"];
        prod.comp_id = [object valueForKey:@"comp_id"];
        [selectedCompany.products addObject:prod];
    
    }
    }
}



@end