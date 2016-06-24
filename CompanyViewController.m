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


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.498 green:0.706 blue:0.224 alpha:1.0];
    self.tableView.allowsSelectionDuringEditing = YES;
    
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
    
    
    CGRect undoButtonFrame = CGRectMake(200,555, 200, 50 );
    self.undoButton = [[UIButton alloc] initWithFrame: undoButtonFrame];
    [self.undoButton setTitle: @"Undo" forState: UIControlStateNormal];
    [self.undoButton addTarget:self action:@selector(undo) forControlEvents:UIControlEventTouchUpInside];
    [self.undoButton setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
    self.undoButton.backgroundColor = [UIColor colorWithRed:0.259 green:0.259 blue:0.259 alpha:1];
    
    CGRect redoButtonFrame = CGRectMake(0,555, 200, 50 );

    self.redoButton = [[UIButton alloc] initWithFrame: redoButtonFrame];
    [self.redoButton setTitle: @"Redo" forState: UIControlStateNormal];
    [self.redoButton addTarget:self action:@selector(redo) forControlEvents:UIControlEventTouchUpInside];
    [self.redoButton setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
    self.redoButton.backgroundColor = [UIColor colorWithRed:0.259 green:0.259 blue:0.259 alpha:1];
    

    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.editButtonItem,addButton,nil]; //removed undoButton but functionality is there, just have to assign it to reassign it to a frame next to redo button
    self.navigationItem.leftBarButtonItem = saveButton;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];

    [self.view addSubview:self.undoButton];
    [self.view addSubview:self.redoButton];

}




- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];

    
    if (self) {
        // Custom initialization
    }
    return self;
}



-(void)saveToDisk{
    [self.dao saveChanges];
}


-(void)redo{
    [self.dao redoChanges];
    [self loadStockPrices];
    [self.tableView reloadData];
    [self viewWillAppear:YES];

}


-(void)undo{
    [self.dao undoChanges];
    [self loadStockPrices];
    [self.tableView reloadData];
    [self viewWillAppear:YES];
    
}

- (IBAction)addCompanyButton:(id)sender{
    [self pushForm];
}


-(void)pushEmptyStateViewWhenNoCompaniesExist{
//    CGRect screenRect = [[UIScreen mainScreen] bounds];
//    CGFloat screenWidth = screenRect.size.width;
//    CGFloat screenHeight = screenRect.size.height;

    
    
    if([self.dao.companies count] != 0){
        self.title = @"Watch List";
        [self.EmptyState removeFromSuperview];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
        [self.view addSubview:self.undoButton];
        [self.view addSubview:self.redoButton];

    }else{
        self.title =@"Stock Tracker";
//        [self.EmptyState initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView addSubview:self.EmptyState];
        [self.view addSubview:self.undoButton];
        [self.view addSubview:self.redoButton];

        
    }
    
}
- (void)viewWillAppear:(BOOL)animated {

    [self pushEmptyStateViewWhenNoCompaniesExist];
    [super viewWillAppear:animated];
    [self loadStockPrices];
    
    [self.tableView reloadData];
    [self.view addSubview:self.undoButton];
    [self.view addSubview:self.redoButton];

    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
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
        [tableView endUpdates];
        [tableView reloadData];
        [self pushEmptyStateViewWhenNoCompaniesExist];
        
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
    
    
    
    formViewController.title = @"New Company";
    
    
    
    [self.navigationController
     pushViewController:formViewController
     animated:YES];
    [formViewController release];
    
    
}



#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    

    self.productViewController.title = [self.dao.companies[indexPath.row]companyName];
    Company *company = self.dao.companies[indexPath.row];
    self.productViewController.currentCompany = self.dao.companies[indexPath.row];
    self.productViewController.products =  company.products;
    self.productViewController.passedLogoString = [self.dao.companies[indexPath.row]companyLogo];
    
    NSLog(@"company is %@",self.dao.companies[indexPath.row]);
    NSLog(@"products is  is %@",self.dao.companies[indexPath.row].products);



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
        
        self.formViewController.passedCompanyIndex = indexPath.row;
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

-(void)loadStockPrices{
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
                                  
                                      for(int i = 0; i < [self.dao.companies count]; i++){
                                      
                                          [self.dao.companies[i] setStockPrice:[NSString stringWithFormat:@"$%@",self.stockComponents[i]]];
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
}



- (void)dealloc {
    [_EmptyState release];
    [super dealloc];
}

@end
