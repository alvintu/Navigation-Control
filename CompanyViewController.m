//
//  CompanyViewController.m
//  NavCtrl
//
//  Created by Aditya Narayan on 10/22/13.
//  Copyright (c) 2013 Aditya Narayan. All rights reserved.
//

#import "CompanyViewController.h"
#import "ProductViewController.h"

@interface CompanyViewController ()

@property (nonatomic, retain)  FormViewController * formViewController;

@end

@implementation CompanyViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    self.tableView.allowsSelectionDuringEditing = YES;
    
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
    self.dao = [DAO sharedDAO];

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                  target:self
                                  action:@selector(pushForm)];
    
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                  target:self
                                  action:@selector(saveToDisk)];
    
    
    UIBarButtonItem *undoButton = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemUndo
                                   target:self
                                   action:@selector(undo)];
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.editButtonItem,addButton,saveButton,undoButton,nil];
    self.title = @"Mobile device makers";
    
    
    
}

-(void)saveToDisk{
    [self.dao saveChanges];
}

-(void)undo{
    [self.dao undoChanges];
    
    NSMutableString *stockSymbols = [[NSMutableString alloc]init];
    for(Company* company in self.dao.companies){
        NSMutableString *companyStockSymbol = [[company companySYM]mutableCopy];
        NSMutableString *add = [NSMutableString stringWithFormat:@"+"];
        [stockSymbols appendString:companyStockSymbol];
        [stockSymbols appendString:add];
        //        [companyStockSymbol release];
    }
    
    
    NSString *yahooAPI = [NSString stringWithFormat:@"http://download.finance.yahoo.com/d/quotes.csv?s=%@&f=a",stockSymbols];
    [stockSymbols release];
    NSURL *yahooAPIURL = [NSURL URLWithString:yahooAPI];
    
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:yahooAPIURL
                                                         completionHandler:
                              ^(NSData *data, NSURLResponse *response, NSError *error) {
                                  if (data) {
                                      
                                      NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                      self.stockComponents = [[str componentsSeparatedByString:@"\n" ]mutableCopy];
                                      //                                      for(Company* company in self.dao.companies){
                                      //                                          for(NSString* components in self.stockComponents){
                                      //                                              [company setStockPrice: components];
                                      for(int i = 0; i < [self.dao.companies count]; i++){
                                          [self.dao.companies[i] setStockPrice: self.stockComponents[i]];
                                      }
                                      [str release];
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          [self.tableView reloadData]; //dispatch main queue
                                      });
                                      
                                      
                                      
                                      
                                      
                                  }else {
                                      NSLog(@"Failed to fetch %@: %@", yahooAPIURL, error);
                                  }
                                  
                                  
                                  
                                  
                                  
                              }];
    
    [task resume];
    [self.tableView reloadData];
    
}
- (void)viewWillAppear:(BOOL)animated {
    //    [self.dao orderCompaniesByPosition];
    
    //init withStockSymbol
    [super viewWillAppear:animated];
    NSMutableString *stockSymbols = [[NSMutableString alloc]init];
    for(Company* company in self.dao.companies){
        NSMutableString *companyStockSymbol = [[company companySYM]mutableCopy];
        NSMutableString *add = [NSMutableString stringWithFormat:@"+"];
        [stockSymbols appendString:companyStockSymbol];
        [stockSymbols appendString:add];
//        [companyStockSymbol release];
    }
    
    
    NSString *yahooAPI = [NSString stringWithFormat:@"http://download.finance.yahoo.com/d/quotes.csv?s=%@&f=a",stockSymbols];
    [stockSymbols release];
    NSURL *yahooAPIURL = [NSURL URLWithString:yahooAPI];
    
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:yahooAPIURL
                                                         completionHandler:
                              ^(NSData *data, NSURLResponse *response, NSError *error) {
                                  if (data) {
                                      
                                      NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                      self.stockComponents = [[str componentsSeparatedByString:@"\n" ]mutableCopy];
//                                      for(Company* company in self.dao.companies){
//                                          for(NSString* components in self.stockComponents){
//                                              [company setStockPrice: components];
                                      for(int i = 0; i < [self.dao.companies count]; i++){
                                          [self.dao.companies[i] setStockPrice: self.stockComponents[i]];
                                      }
                                      [str release];
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          [self.tableView reloadData]; //dispatch main queue
                                      });
                                      
                                      
                                      
                                      
                                      
                                  }else {
                                      NSLog(@"Failed to fetch %@: %@", yahooAPIURL, error);
                                  }
                                  
                                  
                                  
                                  
                                  
                              }];
    
    [task resume];
    
    [self.tableView reloadData];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dao.companies count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
    }
    
    
    cell.textLabel.text = [[self.dao.companies objectAtIndex:indexPath.row]companyName];; //[self.companyList objectAtIndex:[indexPath row]];
    cell.imageView.image = [UIImage imageNamed:[[self.dao.companies objectAtIndex:[indexPath row]]companyLogo]];
    cell.detailTextLabel.text = [[self.dao.companies objectAtIndex:indexPath.row]stockPrice];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:16.0];
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Keeps cells from being selectable while not editing. No more blue flash.
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {

        [tableView beginUpdates];


        
     
           [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];

        [self.dao deleteCompany:[self.dao.companies objectAtIndex:indexPath.row]];
//        [self.dao trackCompanyPosition];
//        [tableView reloadData];

        [tableView endUpdates];
        [tableView reloadData];
        
        //        [[self.dao.companies objectAtIndex:indexPath.row] release]; //1st attem
        //        [self.dao.companies objectAtIndex:indexPath.row release];
        //        Company* company = [self.dao.companies objectAtIndex:indexPath.row]; //2nd attempt
        //        [company.products release];
    }
    
    
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        
        
    }
    

}




// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    NSInteger sourceRow = fromIndexPath.row;
    NSInteger destRow = toIndexPath.row;
    [self.tableView beginUpdates];
    Company*company = [[Company alloc] init];
    company = [[self.dao.companies objectAtIndex:sourceRow] retain];
    [[[DAO sharedDAO] companies] removeObjectAtIndex:sourceRow];
    [[[DAO sharedDAO] companies] insertObject:company atIndex:destRow];
    [[DAO sharedDAO] trackCompanyPosition];
    [self.tableView endUpdates];
    [self.tableView reloadData];

}



// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
-(void)pushForm{ //when you create a new company name, logo, symbol pushed to formviewcontroller
    
    FormViewController *formViewController = [[FormViewController alloc] init];
    
    
    
    formViewController.title = @"Add a New Company";
    
    
    
    [self.navigationController
     pushViewController:formViewController
     animated:YES];
    [formViewController release];
    
    
}



#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //    self.productViewController.company = myCompanies[indexPath.row]
    
    self.productViewController.title = [self.dao.companies[indexPath.row]companyName];
    Company *company = self.dao.companies[indexPath.row];
    
    self.productViewController.products =  company.products;
    self.productViewController.currentCompany = self.dao.companies[indexPath.row];
    
    //    FormViewController *formViewController = [[FormViewController alloc] init];
    //
    //
    if(self.editing == YES){  //conditions for editing a comapany
        self.formViewController = [[FormViewController alloc] init];
        
        
        [self.navigationController
         pushViewController:self.formViewController
         animated:YES];
        
        //        Company *newCompany = [[Company alloc]init];
        self.formViewController.title = @"Edit your company";
        self.formViewController.currentCompany = self.dao.companies[indexPath.row];
        
        [self.formViewController.currentCompany setCompanyName:[self.dao.companies[indexPath.row]companyName]];
        [self.formViewController.currentCompany setCompanyLogo: [self.dao.companies[indexPath.row]companyLogo]];
        [self.formViewController.currentCompany setCompanySYM:[self.dao.companies[indexPath.row]companySYM]];
//        [self.formViewController.currentCompany setCompanyID:[self.dao.companies[indexPath.row]companyID]];
        [self.formViewController release];
        //        formViewController.companyID = [NSString stringWithFormat:@"%d",[self.dao addCompany:newCompany]] ;
    }
    else{
        
        [self.navigationController
         pushViewController:self.productViewController
         animated:YES];
    }
    
    
}



@end
