//
//  ProductViewController.m
//  NavCtrl
//
//  Created by Aditya Narayan on 10/22/13.
//  Copyright (c) 2013 Aditya Narayan. All rights reserved.
//

#import "ProductViewController.h"
#import "WebViewController.h"

@interface ProductViewController (){
UIBarButtonItem *editButton;
UIBarButtonItem *doneButton;
UIBarButtonItem *addButton;
UIBarButtonItem *saveButton;
UIBarButtonItem *undoButton;
NSMutableArray *navigationItems;
}

@end

@implementation ProductViewController

//ProtoCell *cell;
NSIndexPath *deleteIndexPath;
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.installsStandardGestureForInteractiveMovement = true;
    
    //    self.tableView.allowsSelectionDuringEditing = YES;
    
    // Uncomment the following line to preserve selection between presentations.
    //    self.clearsSelectionOnViewWillAppear = NO;
    self.dao = [DAO sharedDAO];
    
    addButton = [[UIBarButtonItem alloc]
                 initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                 target:self
                 action:@selector(pushForm)];
    
    
    saveButton = [[UIBarButtonItem alloc]
                  initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                  target:self
                  action:@selector(saveToDisk)];
    
    
    undoButton = [[UIBarButtonItem alloc]
                  initWithBarButtonSystemItem:UIBarButtonSystemItemUndo
                  target:self
                  action:@selector(undo)];
    
    editButton = [[UIBarButtonItem alloc]
                  initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                  target:self
                  action:@selector(edit)];
    
    doneButton = [[UIBarButtonItem alloc]
                  initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                  target:self
                  action:@selector(done)];
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:editButton,addButton,saveButton,undoButton,nil];
    
    //    CGRect screenRect = [[UIScreen mainScreen] bounds];
    //    CGFloat screenWidth = screenRect.size.width;
    //    CGFloat screenHeight = screenRect.size.height;
    //    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(1, 1, screenWidth, screenHeight)];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    UINib *cellNib = [UINib nibWithNibName:@"ProtoCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"ProtoCell"];
    
    self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [self.flowLayout setItemSize:CGSizeMake(350, 350)];
    [self.flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.flowLayout.minimumInteritemSpacing = 0.0f;
    [self.collectionView setCollectionViewLayout:self.flowLayout];
    //    self.collectionView.bounces = YES;
    [self.collectionView setShowsHorizontalScrollIndicator:NO];
    [self.collectionView setShowsVerticalScrollIndicator:NO];
    
    //    self.deleteButton.hidden = YES;
    
    
    
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.editing = NO;
    
    [self.collectionView reloadData];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    //    return [self.dao.companies count];
    return 1;
    
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    //    return 1;
    return [self.products count];
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(!self.isEditing){
        //    self.productViewController.company = myCompanies[indexPath.row]
        WebViewController *webViewController = [[WebViewController alloc]init];
        
        webViewController.link = [[self.products objectAtIndex:indexPath.row] productURL];
        
        
        [self.navigationController
         pushViewController:webViewController
         animated:YES];
        [webViewController release];

    }
    
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ProtoCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"ProtoCell" forIndexPath:indexPath];
    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[[_products objectAtIndex:[indexPath row]]productLogo]]];

    logo.contentMode = UIViewContentModeScaleAspectFit;
    cell.backgroundView = logo;
    
    cell.titleLabel.text = [[self.products objectAtIndex:[indexPath row]]productName];
    cell.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    cell.titleLabel.textAlignment =  NSTextAlignmentCenter;

    cell.deleteButton.tag = indexPath.row;
    [cell.deleteButton addTarget:self
                          action:@selector(deleteCollectionCell:)
     
                forControlEvents:UIControlEventTouchUpInside];
    
    cell.editButton.tag = indexPath.row;
    [cell.editButton addTarget:self action:@selector(editCollectionCell:) forControlEvents:UIControlEventTouchUpInside];

    cell.stockPriceLabel.hidden = YES;
    if(self.isEditing){
        cell.deleteButton.hidden = NO;
        cell.editButton.hidden = NO;
    }
    else{
        cell.deleteButton.hidden = YES;
        cell.editButton.hidden = YES;
    }
    

    return cell;
}



-(void)edit{
    self.isEditing = YES;
    
//    if(self.isEditing){
//        
//        NSLog(@"I'm editing");
//        
//        for(ProtoCell *cell in _collectionView.visibleCells){
//            cell.deleteButton.hidden = NO;
//            cell.editButton.hidden = NO;
//            //    }
//            
//        }
//        
    
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:doneButton,addButton,saveButton,undoButton,nil];
    [self.collectionView reloadData];
//    }
}


-(void)deleteCollectionCell:(id)sender{
    NSLog(@"dododo");
    
    UIButton *delBtn = sender;
    int row = (int)delBtn.tag;
    

    [self.collectionView performBatchUpdates:^{


        [self.dao deleteProduct:self.products[row]];
//        [self.products removeObjectAtIndex:row];  //transferred a version of this method into the DAO
        NSIndexPath *indexPath =[NSIndexPath indexPathForItem:row inSection:0];
        [self.collectionView deleteItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];

        
        
    } completion:^(BOOL finished) {
        
        
    [self.collectionView reloadData];
    

        //    }
        
        
        
        
    }];
    
}


-(void)editCollectionCell:(id)sender{
    
    UIButton *editBtn = sender;
    int row = (int)editBtn.tag;
    
    ProductFormViewController *productFormViewController = [[ProductFormViewController alloc] init];
    
    productFormViewController.title = @"Edit your products";
    productFormViewController.productName = [self.products[row] productName];
    productFormViewController.productURL = [self.products[row] productURL];
    productFormViewController.productLogo = [self.products[row] productLogo];
    productFormViewController.currentProduct = self.products[row];
    productFormViewController.currentproducts = self.products;
    productFormViewController.currentCompany = self.currentCompany;
    
    [self.navigationController
     pushViewController:productFormViewController
     animated:YES];
    [productFormViewController release];
    
    
    
}

-(void)done{
    self.isEditing = NO;
    [self.collectionView reloadData];
//    for(ProtoCell *cell in _collectionView.visibleCells){
//        cell.deleteButton.hidden = YES;
//        cell.editButton.hidden = YES;
//        //hides all cells buttons when done buttin is clicked
//    }

    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:editButton,addButton,saveButton,undoButton,nil];
}


-(void)pushForm{ //when you create a new company name, logo, symbol pushed to formviewcontroller
    
    ProductFormViewController *productFormViewController = [[ProductFormViewController alloc] init];
    NSUInteger i = [self.products count];
    
    productFormViewController.title = @"Add A New Product";

    //    productformViewController.productName = @"Enter Name";
    //    productformViewController.productURL = @"Enter URL";
    productFormViewController.productLogo = [NSString stringWithFormat:@"defaultLogo%lu.jpg",(unsigned long)i];
    productFormViewController.currentproducts = self.products;
    productFormViewController.currentCompany = self.currentCompany;

    
    
    
    
    
    
    [self.navigationController
     pushViewController:productFormViewController
     animated:YES];
    [productFormViewController release];
    
    
}
    


-(void)saveToDisk{
    [self.dao saveChanges];
}
-(void)undo{

[self.dao undoProductChanges];
[self.collectionView reloadData];
    NSLog(@"undoed");
}


-(BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
    return true;
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSInteger sourceRow = sourceIndexPath.row;
    NSInteger destRow = destinationIndexPath.row;
    Product*product = [[Product alloc] init];
    
    product = [[self.products objectAtIndex:sourceRow]retain];
//    [self.tableView beginUpdates];
    [self.products removeObjectAtIndex:sourceRow];
    [self.products insertObject:product atIndex:destRow];
    [self.dao trackProductsPosition:self.products selectedCompany:self.currentCompany];
//    [self.tableView endUpdates];
    [self.collectionView reloadData];
    
}





@end
