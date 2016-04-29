//
//  ProductViewController.m
//  NavCtrl
//
//  Created by Aditya Narayan on 10/22/13.
//  Copyright (c) 2013 Aditya Narayan. All rights reserved.
//

#import "ProductViewController.h"
#import "WebViewController.h"

@interface ProductViewController ()

@end

@implementation ProductViewController

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
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if ([self.title isEqualToString:@"Apple mobile devices"]) {
        self.products = @[@"iPad", @"iPod Touch",@"iPhone"];
        self.productLinks = @[@"https://www.apple.com/ipad", @"https://www.apple.com/ipod-touch",@"https://www.apple.com/iphone"];
//        self.imageView.image = [UIImage imageNamed:@"apple.png"];
    
    } else if([self.title isEqualToString:@"Samsung mobile devices"]) {
        self.products = @[@"Galaxy S4", @"Galaxy Note", @"Galaxy Tab"];
          self.productLinks = @[@"http://www.samsung.com/us/mobile/cell-phones/SCH-I545ZKAVZW", @"http://www.samsung.com/us/mobile/galaxy-note/",@"http://www.samsung.com/us/mobile/galaxy-tab/"];
    }
    else if([self.title isEqualToString:@"Google mobile devices"]) {
        self.products = @[@"Nexus 5X", @"Nexus 6P", @"Nexus 9"];
        self.productLinks = @[@"https://www.google.com/nexus/5x/",@"https://www.google.com/nexus/6p",@"https://www.google.com/nexus/9"];
    }
    else {
        NSLog(@"self.title is %@",self.title);
        self.products = @[@"Nextel ", @"Blackberry", @"Motorola Razr"];
        self.productLinks = @[@"http://www.amazon.com/Motorola-Nextel-Boost-Mobile-Phone/dp/B003APT3KU/ref=sr_1_1?ie=UTF8&qid=1461951678&sr=8-1&keywords=nextel",@"http://www.amazon.com/BlackBerry-Classic-Factory-Unlocked-Cellphone/dp/B00OYZZ3VS/ref=sr_1_3?ie=UTF8&qid=1461951711&sr=8-3&keywords=blackberry",@"http://www.amazon.com/Motorola-V3-Unlocked-Player--U-S-Warranty/dp/B0016JDE34/ref=sr_1_1?s=wireless&ie=UTF8&qid=1461951732&sr=1-1&keywords=motorola+razr"];
//        UIWebView *webview=[[UIWebView alloc]initWithFrame:CGRectMake(0,200, 700,1300)];
//        webview.scalesPageToFit = YES;
//        NSString *url=@"https://www.google.com/";
//        NSURL *nsurl=[NSURL URLWithString:url];
//        NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
//        [webview loadRequest:nsrequest];
//        [self.view addSubview:webview];;
    }
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
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.products count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    
    cell.textLabel.text = [self.products objectAtIndex:[indexPath row]];
//    cell.imageView.image = [UIImage imageNamed:@"apple.png"];
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

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    DetailViewController *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
 // initWithFrame

    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
 
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.webViewController = [[WebViewController alloc]init];

    self.webViewController.link = [self.productLinks objectAtIndex:indexPath.row];
    [self.navigationController
     pushViewController:self.webViewController
     animated:YES];
    
//    if ([self.title isEqualToString:@"Apple mobile devices"]) {
//        if (indexPath.row == 0){
//
//            UIWebView *webview=[[UIWebView alloc]initWithFrame:CGRectMake(0, 200, 1024,768)];
//            NSString *url=@"http://www.apple.com/ipad/";
//            NSURL *nsurl=[NSURL URLWithString:url];
//            NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
//            [webview loadRequest:nsrequest];
//            [self.view addSubview:webview];
//        }
//        else if(indexPath.row == 1)
//        {
//            UIWebView *webview=[[UIWebView alloc]initWithFrame:CGRectMake(0, 200, 1024,768)];
//            NSString *url=@"http://www.apple.com/ipod-touch";
//            NSURL *nsurl=[NSURL URLWithString:url];
//            NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
//            [webview loadRequest:nsrequest];
//            [self.view addSubview:webview];
//            
//        }
//        else if(indexPath.row == 2)
//        {
//            UIWebView *webview=[[UIWebView alloc]initWithFrame:CGRectMake(0, 200, 1024,768)];
//            NSString *url=@"http://www.apple.com/iphone";
//            NSURL *nsurl=[NSURL URLWithString:url];
//            NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
//            [webview loadRequest:nsrequest];
//            [self.view addSubview:webview];
//        }
//        
//    } else if([self.title isEqualToString:@"Samsung mobile devices"]) {
//        if (indexPath.row == 0){
//            
//            UIWebView *webview=[[UIWebView alloc]initWithFrame:CGRectMake(0, 200, 1024,768)];
//            NSString *url=@"http://www.samsung.com/uk/consumer/mobile-devices/smartphones/galaxy-s/GT-I9505ZKABTU";
//            NSURL *nsurl=[NSURL URLWithString:url];
//            NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
//            [webview loadRequest:nsrequest];
//            [self.view addSubview:webview];
//        }
//        else if(indexPath.row == 1)
//        {
//            UIWebView *webview=[[UIWebView alloc]initWithFrame:CGRectMake(0, 200, 1024,768)];
//            NSString *url=@"http://www.samsung.com/us/mobile/galaxy-note/";
//            NSURL *nsurl=[NSURL URLWithString:url];
//            NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
//            [webview loadRequest:nsrequest];
//            [self.view addSubview:webview];
//            
//        }
//        else if(indexPath.row == 2)
//        {
//            UIWebView *webview=[[UIWebView alloc]initWithFrame:CGRectMake(0, 200, 1024,768)];
//            NSString *url=@"http://www.samsung.com/us/mobile/galaxy-tab/";
//            NSURL *nsurl=[NSURL URLWithString:url];
//            NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
//            [webview loadRequest:nsrequest];
//            [self.view addSubview:webview];
//    }
//    else if([self.title isEqualToString:@"Google mobile devices"]) {
//        
//    }
//    else {
//        NSLog(@"self.title is %@",self.title);
//       
//    }
//
//     
//    }
    
    // webViewController aloc, initWithFrame

    
    
}

@end
