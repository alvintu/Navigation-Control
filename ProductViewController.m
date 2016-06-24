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

//- (id)initWithStyle:(UITableViewStyle)style
//{
//    self = [super initWithStyle:style];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

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
//     self.tableview.clearsSelectionOnViewWillAppear = NO;
 
    
    UIBarButtonItem *undoButton = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemUndo
                                   target:self
                                   action:@selector(undo)];
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                   target:self
                                   action:@selector(saveToDisk)];
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
       self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:addButton,saveButton,nil]; //removed undo button, will implement later when doing redo functionality

    CGRect undoButtonFrame = CGRectMake(200,625, 200, 50 );
    self.undoButton = [[UIButton alloc] initWithFrame: undoButtonFrame];
    [self.undoButton setTitle: @"Undo" forState: UIControlStateNormal];
    [self.undoButton addTarget:self action:@selector(undo) forControlEvents:UIControlEventTouchUpInside];
    [self.undoButton setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
    self.undoButton.backgroundColor = [UIColor colorWithRed:0.259 green:0.259 blue:0.259 alpha:1];
    
    CGRect redoButtonFrame = CGRectMake(0,625, 200, 50 );
    
    self.redoButton = [[UIButton alloc] initWithFrame: redoButtonFrame];
    [self.redoButton setTitle: @"Redo" forState: UIControlStateNormal];
    [self.redoButton addTarget:self action:@selector(redo) forControlEvents:UIControlEventTouchUpInside];
    [self.redoButton setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
    self.redoButton.backgroundColor = [UIColor colorWithRed:0.259 green:0.259 blue:0.259 alpha:1];
    [self.view addSubview:self.redoButton];
    [self.view addSubview:self.undoButton];
}
-(void)saveToDisk{
    [self.dao saveChanges];
}
-(void)undo{

[self.dao undoProductChanges];
[self.tableView reloadData];
[self viewWillAppear:YES];
    NSLog(@"undoed");
}


-(void)redo{
    [self.dao redoProductChanges];
    [self.tableView reloadData];
    [self viewWillAppear:YES];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    UIImage *tempImg = [UIImage imageNamed:self.passedLogoString];

    self.logoImage = [[UIImageView alloc]initWithFrame:CGRectMake(150, 100, 75, 75)];
    self.logoImage.image = tempImg;
    self.logoImage.layer.cornerRadius = 20;
    self.logoImage.layer.masksToBounds = YES;
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(165, 175, 100, 30)];
    self.titleLabel.text = self.currentCompany.companyName;
    self.titleLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.logoImage];
    [self pushEmptyStateViewWhenNoProductsExist];
    NSLog(@"currentCompany is %@",self.currentCompany);
    NSLog(@"amount of products in currentcompany is %@",self.currentCompany.products);

    
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    
    cell.textLabel.text = [[self.products objectAtIndex:[indexPath row]] productName];
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"$%@",[[self.products objectAtIndex:[indexPath row]] price]];
    NSLog(@"price of product is %@",[[self.products objectAtIndex:[indexPath row]] price]);
    
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
//    NSUInteger i = [self.products count];
    [self.navigationController
     pushViewController:productformViewController
     animated:YES];
    
    productformViewController.title = @"Add Product";
//    productformViewController.productName = @"Enter Name";
//    productformViewController.productURL = @"Enter URL";
//    productformViewController.productLogo
    productformViewController.currentproducts = self.products;
    productformViewController.currentCompany = self.currentCompany;
    
    [productformViewController release];
}





- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        [self.dao sortProducts:self.currentCompany];
        [self.dao deleteProduct:self.products[indexPath.row]];
        
        

//        [self.products removeObjectAtIndex:indexPath.row];
        [self.dao trackProductsPosition:self.products selectedCompany:self.currentCompany];
        [self pushEmptyStateViewWhenNoProductsExist];

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



 

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    self.webViewController = [[WebViewController alloc]init];
//
//    self.webViewController.link = [[self.products objectAtIndex:indexPath.row] productURL];

//    if(self.editing == YES){
//        ProductFormViewController *productFormViewController = [[ProductFormViewController alloc] init];
//
//        productFormViewController.title = @"Edit your products";
//        productFormViewController.productName = [self.products[indexPath.row] productName];
//        productFormViewController.productURL = [self.products[indexPath.row] productURL];
//        productFormViewController.productLogo = [self.products[indexPath.row] productLogo];
//        productFormViewController.currentProduct = self.products[indexPath.row];
//        productFormViewController.currentproducts = self.products;
//        productFormViewController.currentCompany = self.currentCompany;
//
//        [self.navigationController
//         pushViewController:productFormViewController
//         animated:YES];
//        [productFormViewController release];
//    }
//    else{
        WebViewController *webViewController = [[WebViewController alloc]init];
        
        webViewController.link = [[self.products objectAtIndex:indexPath.row] productURL];
    
        webViewController.productName = [self.products[indexPath.row] productName];
        webViewController.productURL = [self.products[indexPath.row] productURL];
        webViewController.productLogo = [self.products[indexPath.row] productLogo];
        webViewController.productPrice = [self.products[indexPath.row]price];
        webViewController.currentProduct = self.products[indexPath.row];
        webViewController.currentproducts = self.products;
        webViewController.currentCompany = self.currentCompany;
        webViewController.passedCompanyIndex = indexPath.row;
    NSLog(@"webViewController.productPrice is %@",webViewController.productPrice);
        [self.navigationController
         pushViewController:webViewController
         animated:YES];
        [webViewController release];
//    }
}

-(void)viewWillDisappear:(BOOL)animated {
//    self.currentCompany = nil;
    [self.titleLabel removeFromSuperview];  //fix overlapping labels
    [self.logoImage removeFromSuperview]; //fix overlapping logos
}

-(void)pushEmptyStateViewWhenNoProductsExist{
    
    
    if([self.products count] != 0){
        self.title = self.currentCompany.companyName;
        [self.productEmptyState removeFromSuperview];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
    }
    else{
        self.title = self.currentCompany.companyName;
//        self.tableView 
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView addSubview:self.productEmptyState];
        
        
    }
    
}
- (void)dealloc {
    [_tableView release];
    [_productEmptyState release];
    [_logoImage release];
    [_titleLabel release];
    [_titleLabel release];
    [super dealloc];
}

- (IBAction)addProductButton:(id)sender {
    [self pushForm];
}
@end
