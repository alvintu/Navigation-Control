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
    
    NSLog(@"viewDidLoad");
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                  target:self
                                  action:@selector(pushForm)];
    self.dao = [DAO sharedDAO];

    self.tableView.allowsSelectionDuringEditing = YES;

    // Uncomment the following line to preserve selection between presentations.
     self.clearsSelectionOnViewWillAppear = NO;
 
    
    UIBarButtonItem *undoButton = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemUndo
                                   target:self
                                   action:@selector(undo)];
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                   target:self
                                   action:@selector(saveToDisk)];
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
       self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.editButtonItem,addButton,saveButton,undoButton,nil];

}
-(void)saveToDisk{
    [self.dao saveChanges];
}
-(void)undo{

[self.dao undoProductChanges];
[self.tableView reloadData];
    NSLog(@"undoed");
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    

//    [self.dao sortProducts:self.currentCompany];

    NSLog(@"viewWillAppear");
    NSLog(@"%@",self.title);
//    [self.dao populateProductsBasedOnCompanyID:self.currentCompany];
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
    
    cell.textLabel.text = [[self.products objectAtIndex:[indexPath row]] productName];
    
    cell.imageView.image = [UIImage imageNamed:[[_products objectAtIndex:[indexPath row]] productLogo] ];
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

-(void)pushForm{
    
    ProductFormViewController *productformViewController = [[ProductFormViewController alloc] init];
    NSUInteger i = [self.products count];
    [self.navigationController
     pushViewController:productformViewController
     animated:YES];
    
    productformViewController.title = @"Add a New Product";
//    productformViewController.productName = @"Enter Name";
//    productformViewController.productURL = @"Enter URL";
    productformViewController.productLogo = [NSString stringWithFormat:@"defaultLogo%lu.jpg",(unsigned long)i];
    productformViewController.currentproducts = self.products;
    productformViewController.currentCompany = self.currentCompany;
    
    [productformViewController release];
}





- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        [self.dao sortProducts:self.currentCompany];
        [self.dao deleteProduct:self.products[indexPath.row]];

        [self.products removeObjectAtIndex:indexPath.row];
        [self.dao trackProductsPosition:self.products selectedCompany:self.currentCompany];

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
    Product*product = [[Product alloc] init];

    product = [[self.products objectAtIndex:sourceRow]retain];
    [self.tableView beginUpdates];
    [self.products removeObjectAtIndex:sourceRow];
    [self.products insertObject:product atIndex:destRow];
     [self.dao trackProductsPosition:self.products selectedCompany:self.currentCompany];
    [self.tableView endUpdates];
    [self.tableView reloadData];

}



// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}


/*/Users/Jo/Library/Developer/CoreSimulator/Devices/83ECACC1-0A82-478B-85C4-5A7E69472557/data/Containers/Data/Application/FF1B14CC-F688-4ADF-9078-55CC222004B7/Documents/CompanyProduct.db
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
//    self.webViewController = [[WebViewController alloc]init];
//
//    self.webViewController.link = [[self.products objectAtIndex:indexPath.row] productURL];

    if(self.editing == YES){
        ProductFormViewController *productFormViewController = [[ProductFormViewController alloc] init];

        productFormViewController.title = @"Edit your products";
        productFormViewController.productName = [self.products[indexPath.row] productName];
        productFormViewController.productURL = [self.products[indexPath.row] productURL];
        productFormViewController.productLogo = [self.products[indexPath.row] productLogo];
        productFormViewController.currentProduct = self.products[indexPath.row];
        productFormViewController.currentproducts = self.products;
        productFormViewController.currentCompany = self.currentCompany;

        [self.navigationController
         pushViewController:productFormViewController
         animated:YES];
        [productFormViewController release];
    }
    else{
        WebViewController *webViewController = [[WebViewController alloc]init];
        
        webViewController.link = [[self.products objectAtIndex:indexPath.row] productURL];
        
        [self.navigationController
         pushViewController:webViewController
         animated:YES];
        [webViewController release];
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    self.currentCompany = nil;
}

@end
