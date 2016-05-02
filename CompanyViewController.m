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

    // Uncomment the following line to preserve selection between presentations.
     self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    
    
    
    
    
//     self.companies = [NSMutableArray arrayWithObjects:apple,samsung, google, sprint,nil];
//    self.companyList = [NSMutableArray arrayWithObjects:apple.companyName,samsung.companyName, google.companyName, sprint.companyName,nil];
//    
    
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
    // Return the number of rows in the section.
    return [self.dao.companies count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    Company *company = [self.dao.companies objectAtIndex:[indexPath row]];
    
    cell.textLabel.text = company.companyName; //[self.companyList objectAtIndex:[indexPath row]];
    cell.imageView.image = [UIImage imageNamed:company.companyLogo];
    /*
    //    cell.imageView.image = [UIImage imageNamed:@"apple.png"];
    if (cell.textLabel.text == [self.companyList objectAtIndex:[indexPath row]]){ //set different images to different products
        
        
        
        //        for (int i=0; i<[self.companyList count]; i++)
        
        
        
        
        if([cell.textLabel.text isEqualToString:self.companies.apple.companyName]){
            cell.imageView.image = [UIImage imageNamed:self.apple.companyLogo];
        }
        if([cell.textLabel.text isEqualToString:self.samsung.companyName]){
            cell.imageView.image = [UIImage imageNamed:self.samsung.companyLogo];
        }
        
        if([cell.textLabel.text isEqualToString:self.google.companyName]){
            cell.imageView.image = [UIImage imageNamed:self.google.companyLogo];
        }
        if([cell.textLabel.text isEqualToString: self.sprint.companyName]){
            cell.imageView.image = [UIImage imageNamed:self.sprint.companyLogo];
        }
        
    }
     */

    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{


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
        id object = [self.companyList objectAtIndex:sourceRow];
        
        [self.companyList removeObjectAtIndex:sourceRow];
        [self.companyList insertObject:object atIndex:destRow];
        
    }



// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}




#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

//    self.productViewController.company = myCompanies[indexPath.row]
    
    self.productViewController.title = [self.dao.companies[indexPath.row]companyName];
    Company *company = self.dao.companies[indexPath.row];

    self.productViewController.products =  company.products;


    [self.navigationController
        pushViewController:self.productViewController
        animated:YES];
    
    

}



@end
