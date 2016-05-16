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
    return docsDir;
}
- (id)init {
    if (self = [super init]) {
        [self createOrOpenDB];
        [self readDatabase];
    }
    return self;
}

//            NSString *sqLiteDb = [[NSBundle mainBundle] pathForResource:@"CompanyProduct"
//                                                                 ofType:@"db"];
//            
//            NSFileManager *fileManager = [NSFileManager defaultManager];
//            NSError *error;
//            
//            NSString *dataPath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"CompanyProduct.db"];
//            NSLog(@"Datapath is %@", dataPath);
//            
//            // If the expected store doesn't exist, copy the default store.
//            if (![fileManager fileExistsAtPath:dataPath])
//            {
//                NSLog(@"File doesn't exist");
//                 compdataPath = [[NSBundle mainBundle] pathForResource:@"CompanyProduct" ofType:@"db"];
//                [fileManager copyItemAtPath:compdataPath toPath:dataPath error:&error];
//                
//            } else {
//                NSLog(@"File exists");
//
//}
//            }

//            
//            if (sqlite3_open([compdataPath UTF8String], &CompanyDB) != SQLITE_OK) {
//                NSLog(@"Failed to open database!");
//            }
//        }
//    }
//    return self;

//}
//
-(void)dealloc {
//        sqlite3_close(CompanyDB);
        [super dealloc];
}
    

//        Company *apple = [[Company alloc]initWithCompanyName:@"Apple" companyLogo:@"apple.png" companySYM:@"AAPL"];
//        Company *samsung = [[Company alloc]initWithCompanyName:@"Samsung" companyLogo:@"samsung.png" companySYM:@"SSNLF"];
//        Company *google = [[Company alloc]initWithCompanyName:@"Google" companyLogo:@"google.png" companySYM:@"GOOG"];
//        Company *sprint = [[Company alloc]initWithCompanyName:@"Sprint" companyLogo:@"sprint.png" companySYM:@"S"];
//        Product *iPad = [[Product alloc]initWithProductName:@"iPad" productURL:@"https://www.apple.com/ipad" productLogo:@"ipad.jpg"];
//        Product *iPodTouch = [[Product alloc]initWithProductName:@"iPod Touch" productURL:@"https://www.apple.com/ipod-touch" productLogo:@"ipodtouch.jpg"];
//        Product *iPhone = [[Product alloc]initWithProductName:@"iPhone" productURL:@"https://www.apple.com/iPhone" productLogo:@"iphone.jpg"];
//        Product *GalaxyS4 = [[Product alloc]initWithProductName:@"GalaxyS4" productURL:@"http://www.samsung.com/us/mobile/cell-phones/SCH-I545ZKAVZW" productLogo:@"galaxys4.jpg"];
//        Product *GalaxyNote = [[Product alloc]initWithProductName:@"Galaxy Note" productURL:@"http://www.samsung.com/us/mobile/galaxy-note/" productLogo:@"galaxynote.png"];
//        Product *GalaxyTab = [[Product alloc]initWithProductName:@"Galaxy Tab" productURL:@"http://www.samsung.com/us/mobile/galaxy-tab/" productLogo:@"galaxytab.jpg"];
//        Product *Nexus5X = [[Product alloc]initWithProductName:@"Nexus 5X" productURL:@"https://www.google.com/nexus/5x/" productLogo:@"nexus5x.jpg"];
//        Product *Nexus6P = [[Product alloc]initWithProductName:@"Nexus 6P" productURL:@"https://www.google.com/nexus/6p" productLogo:@"nexus6.jpg"];
//        Product *Nexus9 = [[Product alloc]initWithProductName:@"Nexus 9" productURL:@"https://www.google.com/nexus/9" productLogo:@"nexus9.jpg"];
//        Product *Nextel = [[Product alloc]initWithProductName:@"Nextel" productURL:@"http://www.amazon.com/Motorola-Nextel-Boost-Mobile-Phone/dp/B003APT3KU/ref=sr_1_1?ie=UTF8&qid=1461951678&sr=8-1&keywords=nextel" productLogo:@"nextel.jpg"];
//        Product *BlackBerry = [[Product alloc]initWithProductName:@"Blackberry" productURL:@"http://www.amazon.com/BlackBerry-Classic-Factory-Unlocked-Cellphone/dp/B00OYZZ3VS/ref=sr_1_3?ie=UTF8&qid=1461951711&sr=8-3&keywords=blackberry"productLogo:@"blackberry.jpg"];
//        Product *MotorolaRazr = [[Product alloc]initWithProductName:@"Motorla Razr" productURL:@"http://www.amazon.com/Motorola-V3-Unlocked-Player--U-S-Warranty/dp/B0016JDE34/ref=sr_1_1?s=wireless&ie=UTF8&qid=1461951732&sr=1-1&keywords=motorola+razr" productLogo:@"razr.jpg"];
        
//        
//        apple.products = [NSMutableArray arrayWithObjects:iPad,iPodTouch, iPhone,nil];
//        samsung.products =[NSMutableArray arrayWithObjects:GalaxyS4,GalaxyNote, GalaxyTab,nil];
//        google.products = [NSMutableArray arrayWithObjects:Nexus5X,Nexus6P, Nexus9,nil];
//        sprint.products = [NSMutableArray arrayWithObjects:Nextel,BlackBerry, MotorolaRazr,nil];
       
        
//        self.companies = [NSMutableArray arrayWithObjects:apple,samsung, google, sprint,nil];
        
//    }
//    return self;
//}


-(void)createOrOpenDB
{
    
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
     dataPath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"CompanyProduct.db"];
    NSLog(@"Datapath is %@", dataPath);
    
    // If the expected store doesn't exist, copy the default store.
    if (![fileManager fileExistsAtPath:dataPath])
    {
        NSLog(@"File doesn't exist");
        compdataPath = [[NSBundle mainBundle] pathForResource:@"CompanyProduct" ofType:@"db"];
        [fileManager copyItemAtPath:compdataPath toPath:dataPath error:&error];
        
    } else {
        NSLog(@"File exists");
        
    }

//    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *docPath = path[0];
//    dbPathString = [docPath stringByAppendingPathComponent:@"CompanyProduct.db"];
//    NSFileManager *fileManager = [NSFileManager defaultManager];
////    
////    if (![fileManager fileExistsAtPath:dbPathString])
////    {
////        const char *dbPath = [dbPathString UTF8String];
////        
////        //cretae database
////        if (sqlite3_open(dbPath, &CompanyDB)== SQLITE_OK)
////        {
////            if(sqlite3_exec(CompanyDB, sql_stmt, NULL, NULL, &error) == SQLITE_OK)
//                //execute the sql statement
////            {
////           
////            }
//            sqlite3_close(CompanyDB);
//            
//        }
//        else
//        {
//            NSLog(@"Unable to open db");
//        }
//    }
}

-(void)readDatabase  {
    int sqlstatus = sqlite3_open([dataPath UTF8String], &CompanyDB);
        
    if (sqlstatus ==SQLITE_OK)
        {
            sqlite3_stmt *statement ;
            self.companies = [[NSMutableArray alloc]init];



            NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM COMPANY ORDER BY POSITION"];
            const char *query_sql = [querySQL UTF8String];
//            int sqlprepare = sqlite3_prepare(CompanyDB, query_sql, -1, &statement, NULL);

            if (sqlite3_prepare(CompanyDB, query_sql, -1, &statement, NULL) == SQLITE_OK)
            {
                
                while (sqlite3_step(statement)== SQLITE_ROW)
                {
                    NSString *companyID = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                    NSString *companyName = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                    NSString *companyLogo = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
                    NSString *companySYM = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 3)];
                    Company *company = [[Company alloc]init];
                    [company setCompanyName:companyName];
                    [company setCompanyLogo:companyLogo];
                    [company setCompanySYM:companySYM];
                    [company setCompanyID:companyID];
                    company.products = [[NSMutableArray alloc]init];
                    [self.companies addObject:company];
                    
                    sqlite3_stmt *statement1;

                    NSString *productQuerySQL = [NSString stringWithFormat:@"SELECT * FROM PRODUCTS WHERE companyid = %@ ORDER BY POSITION",company.companyID];
                    const char *productQuery_sql = [productQuerySQL UTF8String];
                    if (sqlite3_prepare(CompanyDB, productQuery_sql, -1, &statement1, NULL) == SQLITE_OK)
                    {
                        while (sqlite3_step(statement1)== SQLITE_ROW)
                        {
                        

                        NSString *productName = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement1, 1)];
                        NSString *productLogo = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement1, 2)];
                        NSString *productURL  = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement1, 3)];

                         Product *product = [[Product alloc]init];
                        [product setProductName:productName];
                        [product setProductLogo:productLogo];
                        [product setProductURL:productURL];
                        [company.products addObject:product];
                    }
           
                    }
                    
                    
                }
            }
        }
}


-(int)addCompany:(Company*)newCompany {

    char *error1;

        
    NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO COMPANY(companyname,companylogo,companysym,position) VALUES (\"%@\",\"%@\",\"%@\",\"%lu\")",newCompany.companyName,newCompany.companyLogo,newCompany.companySYM,([self.companies count] - 1)];
        const char *insert_sql = [insertSQL UTF8String];
    
        if (sqlite3_exec(CompanyDB, insert_sql, NULL, NULL, &error1) == SQLITE_OK)
            {
                NSLog(@"company added");
            }
    NSLog(@"id %d", (int)sqlite3_last_insert_rowid(CompanyDB));
    return (int)sqlite3_last_insert_rowid(CompanyDB);

}


-(void)deleteCompany:(Company*)selectedCompany  {
    
    char *error1;
 
    
    
    NSString *deleteSQL = [NSString stringWithFormat:@"DELETE FROM COMPANY WHERE companyid = \"%@\"",selectedCompany.companyID];
    const char *delete_sql = [deleteSQL UTF8String];
    
    //
    if (sqlite3_exec(CompanyDB, delete_sql, NULL, NULL, &error1) == SQLITE_OK)
    {
        NSLog(@"user deleted");
    }
    
}


-(void)editCompany:(Company*)selectedCompany  {
    
    char *error1;
    
    
    
    NSString *updateSQL = [NSString stringWithFormat:@"UPDATE COMPANY SET companyname = \"%@\",companylogo = \"%@\",companysym = \"%@\" WHERE companyid = \"%@\"",selectedCompany.companyName,selectedCompany.companyLogo,selectedCompany.companySYM,selectedCompany.companyID];
    const char *update_sql = [updateSQL UTF8String];
    
    //
    if (sqlite3_exec(CompanyDB, update_sql, NULL, NULL, &error1) == SQLITE_OK)
    {
        NSLog(@"company updated");
    }
    
}

-(void)trackCompanyPosition{
    
    char *error1;
    
    for(int i = 0; i < [self.companies count]; i++){
    
//    [self.companies indexOfObject:company];
    
        NSString *trackpositionSQL = [NSString stringWithFormat:@"UPDATE COMPANY SET position = \"%lu\" WHERE companyid = \"%@\"",[self.companies indexOfObject:self.companies[i]],[self.companies[i] companyID]];
    const char *trackposition_sql = [trackpositionSQL UTF8String];
    
    
        
        
        if (sqlite3_exec(CompanyDB, trackposition_sql, NULL, NULL, &error1) == SQLITE_OK)
    {
        NSLog(@"position changed");
    }
    }
    

    
    
}

-(void)addProduct:(Product*)newProduct  selectedCompany:(Company*)selectedCompany indexOfProduct:(NSInteger)indexOfProduct {
    
    char *error1;
    
    
    NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO PRODUCTS(productname,productlogo,productURL,companyid,position) VALUES (\"%@\",\"%@\",\"%@\",\"%@\",\"%li\")",newProduct.productName,newProduct.productLogo,newProduct.productURL, selectedCompany.companyID,indexOfProduct ];
    const char *insert_sql = [insertSQL UTF8String];
    
    if (sqlite3_exec(CompanyDB, insert_sql, NULL, NULL, &error1) == SQLITE_OK)
    {
        NSLog(@"product added");
    }
//    NSLog(@"id %d", (int)sqlite3_last_insert_rowid(CompanyDB));
//    return (int)sqlite3_last_insert_rowid(CompanyDB);
    
}


-(void)deleteProduct:(Product*)selectedProduct{
    
    char *error1;
    

    
    NSString *deleteSQL = [NSString stringWithFormat:@"DELETE FROM PRODUCTS WHERE  productname= \"%@\" AND productlogo=\"%@\" LIMIT 1",selectedProduct.productName, selectedProduct.productLogo];
    const char *delete_sql = [deleteSQL UTF8String];
    
    //
    if (sqlite3_exec(CompanyDB, delete_sql, NULL, NULL, &error1) == SQLITE_OK)
    {
        NSLog(@"user deleted");
    }
    
}
-(void)editProducts:(Product*)selectedProduct selectedCompany:(Company*)selectedCompany{
    
    char *error1;
    
    
    
    
    NSString *updateSQL = [NSString stringWithFormat:@"UPDATE PRODUCTS SET productname = \"%@\",producturl = \"%@\" WHERE companyid = \"%@\" AND productlogo = \"%@\"",selectedProduct.productName,selectedProduct.productURL,selectedCompany.companyID,selectedProduct.productLogo];
    const char *update_sql = [updateSQL UTF8String];
    
    //
    if (sqlite3_exec(CompanyDB, update_sql, NULL, NULL, &error1) == SQLITE_OK)
    {
        NSLog(@"product updated");
    }
    
}


-(void)trackProductsPosition:(NSMutableArray*)products selectedCompany:(Company*)selectedCompany{
    
    char *error1;
    
    for(int i = 0; i < [products count]; i++){
        
        //    [self.companies indexOfObject:company];
        
        NSString *trackpositionSQL = [NSString stringWithFormat:@"UPDATE PRODUCTS SET position = \"%lu\" WHERE companyid = \"%@\" AND productlogo=\"%@\"",[products indexOfObject:products[i]],selectedCompany.companyID, [products[i] productLogo]];
        const char *trackposition_sql = [trackpositionSQL UTF8String];
        
        
        
        
        if (sqlite3_exec(CompanyDB, trackposition_sql, NULL, NULL, &error1) == SQLITE_OK)
        {
            NSLog(@"product position changed");
        }
    }
}


    







- (id)retain {
    return self;
}

- (NSUInteger)retainCount {
    return NSUIntegerMax;  // denotes an object that cannot be released
}


- (id)autorelease {
    return self;
}



@end