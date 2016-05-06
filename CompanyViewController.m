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


//    Company *apple = [[Company alloc]initWithCompanyName:@"Apple" companyLogo:@"apple.png"];
//    Company *samsung = [[Company alloc]initWithCompanyName:@"Samsung" companyLogo:@"samsung.png"];
//    Company *google = [[Company alloc]initWithCompanyName:@"Google" companyLogo:@"google.png"];
//    Company *sprint = [[Company alloc]initWithCompanyName:@"Sprint" companyLogo:@"sprint.png"];
//    Product *iPad = [[Product alloc]initWithProductName:@"iPad" productURL:@"https://www.apple.com/ipad"];
//    Product *iPodTouch = [[Product alloc]initWithProductName:@"iPod Touch" productURL:@"https://www.apple.com/ipod-touch"];
//    Product *iPhone = [[Product alloc]initWithProductName:@"iPhone" productURL:@"https://www.apple.com/iPhone"];
//    Product *GalaxyS4 = [[Product alloc]initWithProductName:@"GalaxyS4" productURL:@"http://www.samsung.com/us/mobile/cell-phones/SCH-I545ZKAVZW"];
//    Product *GalaxyNote = [[Product alloc]initWithProductName:@"Galaxy Note" productURL:@"http://www.samsung.com/us/mobile/galaxy-note/"];
//    Product *GalaxyTab = [[Product alloc]initWithProductName:@"Galaxy Tab" productURL:@"http://www.samsung.com/us/mobile/galaxy-tab/"];
//    Product *Nexus5X = [[Product alloc]initWithProductName:@"Nexus 5X" productURL:@"https://www.google.com/nexus/5x/"];
//    Product *Nexus6P = [[Product alloc]initWithProductName:@"Nexus 6P" productURL:@"https://www.google.com/nexus/6p"];
//    Product *Nexus9 = [[Product alloc]initWithProductName:@"Nexus 9" productURL:@"https://www.google.com/nexus/9"];
//    Product *Nextel = [[Product alloc]initWithProductName:@"Nextel" productURL:@"http://www.amazon.com/Motorola-Nextel-Boost-Mobile-Phone/dp/B003APT3KU/ref=sr_1_1?ie=UTF8&qid=1461951678&sr=8-1&keywords=nextel"];
//    Product *BlackBerry = [[Product alloc]initWithProductName:@"Blackberry" productURL:@"http://www.amazon.com/BlackBerry-Classic-Factory-Unlocked-Cellphone/dp/B00OYZZ3VS/ref=sr_1_3?ie=UTF8&qid=1461951711&sr=8-3&keywords=blackberry"];
//    Product *MotorolaRazr = [[Product alloc]initWithProductName:@"Motorla Razr" productURL:@"http://www.amazon.com/Motorola-V3-Unlocked-Player--U-S-Warranty/dp/B0016JDE34/ref=sr_1_1?s=wireless&ie=UTF8&qid=1461951732&sr=1-1&keywords=motorola+razr"];
//
//    apple.products = [NSMutableArray arrayWithObjects:iPad,iPodTouch, iPhone,nil];
//    samsung.products =[NSMutableArray arrayWithObjects:GalaxyS4,GalaxyNote, GalaxyTab,nil];
//    google.products = [NSMutableArray arrayWithObjects:Nexus5X,Nexus6P, Nexus9,nil];
//    sprint.products = [NSMutableArray arrayWithObjects:Nextel,BlackBerry, MotorolaRazr,nil];

    
    self.dao = [DAO sharedDAO];
    
    
    NSLog(@"%@",self.dao.companies);
    
}


- (void)viewWillAppear:(BOOL)animated {
    //init withStockSymbol
    [super viewWillAppear:animated];
    NSMutableString *stockSymbols = [[NSMutableString alloc]init];
    [stockSymbols appendString:[self.dao.companies[0]companySYM]];
    for(int i = 1;i < [self.dao.companies count]; i++){

    NSMutableString *stock = [[self.dao.companies[i]companySYM]mutableCopy];
    NSMutableString *add = [NSMutableString stringWithFormat:@"+"];
        [stockSymbols appendString:add];
        [stockSymbols appendString:stock];
    }
    NSLog(@"stocksymbols is %@",stockSymbols);

    
    NSLog(@"viewWillAppear");

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

//                                  NSLog(@"%@ %@ %@ %@",[self.dao.companies[0]stockPrice],[self.dao.companies[1]stockPrice],[self.dao.companies[2]stockPrice],[self.dao.companies[3]stockPrice]);
                                  
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      [self.tableView reloadData];
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
    
//    int addRow;
//    if(self.isEditing){
//        addRow = 1;
//    }
//    else{
//        addRow = 0;
//    }
    // Return the number of rows in the section.
    return [self.dao.companies count];
//    + addRow;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
//    Company *company = [self.dao.companies objectAtIndex:[indexPath row]];

//    if(indexPath.row >= self.dao.companies.count && [self isEditing]){
//        cell.textLabel.text = @"Add Row";
//    }else{
//        cell.textLabel.text = self.dao.companies[indexPath.row];
//    }
//    
    // Configure the cell...
    
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

        [self.dao.companies removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
        
    }



// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
-(void)pushForm{
    
    FormViewController *formViewController = [[FormViewController alloc] init];
    
    
        [self.navigationController
         pushViewController:formViewController
         animated:YES];
        formViewController.title = @"Add a New Company";
//    Company *newCompany = [[Company alloc]init];
    formViewController.companyName = @"Enter Name";
    formViewController.companyLogo = @"Enter Logo";
//    formViewController.currentCompany = newCompany;
//    [self.dao.companies insertObject:newCompany atIndex:[self.dao.companies count]];
     //trying to insert company object into companies so that program can add products= to new companies that are not in DAO
    
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

//    FormViewController *formViewController = [[FormViewController alloc] init];
//
//    
    if(self.editing == YES){
        FormViewController *formViewController = [[FormViewController alloc] init];

        
        [self.navigationController
         pushViewController:formViewController
         animated:YES];
        formViewController.title = @"Edit your company";
        
        formViewController.companyName = [self.dao.companies[indexPath.row]companyName];
        formViewController.companyLogo = [self.dao.companies[indexPath.row]companyLogo];
        formViewController.companySYM = [self.dao.companies[indexPath.row]companySYM];

    }
    else{

    [self.navigationController
        pushViewController:self.productViewController
        animated:YES];
    }
    

}



@end
