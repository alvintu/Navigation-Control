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
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                  target:self
                                  action:@selector(pushForm)];
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.editButtonItem,addButton, nil];

    self.title = @"Mobile device makers";
    
    self.dao = [DAO sharedDAO];
//
    NSLog(@"%lu",[self.dao.companies count]);
}


- (void)viewWillAppear:(BOOL)animated {
     [self.tableView reloadData];
//    [self.dao orderCompaniesByPosition];

    //init withStockSymbol
    [super viewWillAppear:animated];
    NSMutableString *stockSymbols = [[NSMutableString alloc]init];
//    [stockSymbols appendString:[self.dao.companies[0]companySYM]];
    for(int i = 0;i < [self.dao.companies count]; i++){

    NSMutableString *stock = [[self.dao.companies[i]companySYM]mutableCopy];
    NSMutableString *add = [NSMutableString stringWithFormat:@"+"];
        [stockSymbols appendString:stock];
        [stockSymbols appendString:add];
    }

    

    NSString *yahooAPI = [NSString stringWithFormat:@"http://download.finance.yahoo.com/d/quotes.csv?s=%@&f=a",stockSymbols];
    NSURL *yahooAPIURL = [NSURL URLWithString:yahooAPI];
//    NSError* error = nil;
//    NSString* text = [NSString stringWithContentsOfURL:yahooAPIURL encoding:NSASCIIStringEncoding error:&error];
//    NSArray *stockComponents = [[text componentsSeparatedByString:@"\n" ]mutableCopy];
    
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:yahooAPIURL
                                                         completionHandler:
                              ^(NSData *data, NSURLResponse *response, NSError *error) {
                                  if (data) {
                                      NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                    self.stockComponents1 = [[str componentsSeparatedByString:@"\n" ]mutableCopy];

                                    
                                  } else {
                                      NSLog(@"Failed to fetch %@: %@", yahooAPIURL, error);
                                  }
                                  
                                  for(int i = 0;i < [self.dao.companies count]; i++){
                                      [self.dao.companies[i] setStockPrice: self.stockComponents1[i]];
                                  }

                                  
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      [self.tableView reloadData]; //dispatch main queue
                                  });
                                  
                                  
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
    
    
    cell.textLabel.text = [[self.dao.companies objectAtIndex:[indexPath row]]companyName];; //[self.companyList objectAtIndex:[indexPath row]];
    cell.imageView.image = [UIImage imageNamed:[[self.dao.companies objectAtIndex:[indexPath row]]companyLogo]];
    cell.detailTextLabel.text = [[self.dao.companies objectAtIndex:[indexPath row]]stockPrice];
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
        [self.dao deleteCompany:[self.dao.companies objectAtIndex:indexPath.row]];

        [self.dao.companies removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.dao trackCompanyPosition];
    }
    
    
    else if (editingStyle == UITableViewCellEditingStyleInsert) {


    }
    

}




// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    
        NSInteger sourceRow = fromIndexPath.row;
        NSInteger destRow = toIndexPath.row;
        id object = [self.dao.companies objectAtIndex:sourceRow];
        
        [self.dao.companies removeObjectAtIndex:sourceRow];
        [self.dao.companies insertObject:object atIndex:destRow];
    
    [self.dao trackCompanyPosition];

    
    }



// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
-(void)pushForm{ //when you create a new company name, logo, symbol pushed to formviewcontroller
    
    FormViewController *formViewController = [[FormViewController alloc] init];
    
    
        [self.navigationController
         pushViewController:formViewController
         animated:YES];
        formViewController.title = @"Add a New Company";
    formViewController.companyName = @"Enter Name";
    formViewController.companyLogo = @"Enter Logo";
    formViewController.companySYM = @"EnterStockSymbol";
    formViewController.companyID = @"Company ID Loading....";


        NSLog(@"I'm editing");
    
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
        FormViewController *formViewController = [[FormViewController alloc] init];

        
        [self.navigationController
         pushViewController:formViewController
         animated:YES];
        
//        Company *newCompany = [[Company alloc]init];
        formViewController.title = @"Edit your company";
        
        formViewController.companyName = [self.dao.companies[indexPath.row]companyName];
        formViewController.companyLogo = [self.dao.companies[indexPath.row]companyLogo];
        formViewController.companySYM = [self.dao.companies[indexPath.row]companySYM];
        formViewController.companyID = [self.dao.companies[indexPath.row]companyID];
//        formViewController.companyID = [NSString stringWithFormat:@"%d",[self.dao addCompany:newCompany]] ;


    }
    else{

    [self.navigationController
        pushViewController:self.productViewController
        animated:YES];
    }
    

}



@end
