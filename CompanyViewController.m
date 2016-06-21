//
//  CompanyViewController.m
//  NavCtrl
//
//  Created by Aditya Narayan on 10/22/13.
//  Copyright (c) 2013 Aditya Narayan. All rights reserved.
//

#import "CompanyViewController.h"
#import "ProductViewController.h"

@interface CompanyViewController (){
    UIBarButtonItem *editButton;
    UIBarButtonItem *doneButton;
    UIBarButtonItem *addButton;
    UIBarButtonItem *saveButton;
    UIBarButtonItem *undoButton;
    NSMutableArray *navigationItems;
    //ProtoCell *cell;
    NSIndexPath *deleteIndexPath;
}
@property (nonatomic, retain)  FormViewController * formViewController;


@end

@implementation CompanyViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.installsStandardGestureForInteractiveMovement = true;

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

    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:editButton,addButton,saveButton,undoButton,nil];
    
    self.title = @"Mobile device makers";
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

    
    
}

- (void)viewWillAppear:(BOOL)animated {
    //        [self.dao orderCompaniesByPosition];
    
    //init withStockSymbol
    [super viewWillAppear:animated];
    NSLog(@"viewwillappear");
    
    [self loadStockPrices];
    [self.collectionView reloadData];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)saveToDisk{
    [self.dao saveChanges];
}

-(void)edit{
    self.isEditing = YES;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:doneButton,addButton,saveButton,undoButton,nil];

    [self.collectionView reloadData];
//    [doneButton release];

//    [doneButton release];
    if(self.isEditing){
    
    NSLog(@"I'm editing");
    

        
        
    }
}

-(void)done{
    self.isEditing = NO;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:editButton,addButton,saveButton,undoButton,nil];
    [self.collectionView reloadData];
    


}

-(void)undo{
    [self.dao undoChanges];
    [self loadStockPrices];

    [self.collectionView reloadData];
    
}



#pragma mark - collection view data source


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
//    return [self.dao.companies count];
    return 1;

}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
//    return 1;
    return [self.dao.companies count];


}


-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
     ProtoCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"ProtoCell" forIndexPath:indexPath];
    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[[self.dao.companies objectAtIndex:[indexPath row]]companyLogo]]];
    logo.contentMode = UIViewContentModeScaleAspectFit;
    cell.backgroundView = logo;
    cell.titleLabel.text = [[self.dao.companies objectAtIndex:[indexPath row]]companyName];
    cell.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    cell.titleLabel.textAlignment =  NSTextAlignmentCenter;

    
    cell.stockPriceLabel.text = [[self.dao.companies objectAtIndex:[indexPath row]]stockPrice];
    cell.stockPriceLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    cell.stockPriceLabel.textAlignment =  NSTextAlignmentCenter;
    
    cell.deleteButton.tag = indexPath.row;
    [cell.deleteButton addTarget:self
                          action:@selector(deleteCollectionCell:)
     
                forControlEvents:UIControlEventTouchUpInside];
    
    cell.editButton.tag = indexPath.row;
    [cell.editButton addTarget:self action:@selector(editCollectionCell:) forControlEvents:UIControlEventTouchUpInside];
    
    if(self.isEditing){
        cell.deleteButton.hidden = NO;
        cell.editButton.hidden = NO;
    }
    else{
    cell.deleteButton.hidden = YES;
    cell.editButton.hidden = YES;
    }
//



   
    
    return cell;

}

-(void)editCollectionCell:(id)sender{
    
    UIButton *editBtn = sender;
    int row = (int)editBtn.tag;

    
    self.formViewController = [[FormViewController alloc] init];
    
    
    [self.navigationController
     pushViewController:self.formViewController
     animated:YES];
    
    self.formViewController.title = @"Edit your company";
    self.formViewController.currentCompany = self.dao.companies[row];
    
    [self.formViewController.currentCompany setCompanyName:[self.dao.companies[row]companyName]];
    [self.formViewController.currentCompany setCompanyLogo: [self.dao.companies[row]companyLogo]];
    [self.formViewController.currentCompany setCompanySYM:[self.dao.companies[row]companySYM]];
            [self.formViewController.currentCompany setCompanyID:[self.dao.companies[row]companyID]];
    
    [self.formViewController release];

}



-(void)deleteCollectionCell:(id)sender{
    NSLog(@"dododo");
    
    UIButton *delBtn = sender;
    int row = (int)delBtn.tag;
    

    [self.collectionView performBatchUpdates:^{
//        [self.dao deleteCompany:self.dao.companies[row]];


        NSIndexPath *indexPath =[NSIndexPath indexPathForItem:row inSection:0];
        
        [self.collectionView deleteItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
        [self.dao deleteCompany:self.dao.companies[row]];

//        [self.dao.companies removeObjectAtIndex:row];
        
//        [self.dao deleteCompany:self.dao.companies[row]];

        
        
    } completion:^(BOOL finished) {

        [self.collectionView reloadData];


                //    }
                
            
            
        
    }];

}



-(void)pushForm{ //when you create a new company name, logo, symbol pushed to formviewcontroller
    
    FormViewController *formViewController = [[FormViewController alloc] init];
    
    
    
    formViewController.title = @"Add a New Company";
    
    
    
    [self.navigationController
     pushViewController:formViewController
     animated:YES];
    [formViewController release];
    

}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(!self.isEditing){
    //    self.productViewController.company = myCompanies[indexPath.row]
    self.productViewController = [[ProductViewController alloc]initWithNibName:@"ProductViewController" bundle:nil];
    
    self.productViewController.title = [self.dao.companies[indexPath.row]companyName];
    
    Company *company = self.dao.companies[indexPath.row];
    
    self.productViewController.products =  company.products;
    self.productViewController.currentCompany = self.dao.companies[indexPath.row];
    

    [self.navigationController
     pushViewController:self.productViewController
     animated:YES];

    [self.productViewController release];
    }
    
}


-(BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
    return true;
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    NSInteger sourceRow = sourceIndexPath.row;
    NSInteger destRow = destinationIndexPath.row;
//    [self.collectionView beginUpdates];
    Company*company = [[Company alloc] init];
    company = [[self.dao.companies objectAtIndex:sourceRow] retain];
    [[[DAO sharedDAO] companies] removeObjectAtIndex:sourceRow];
    [[[DAO sharedDAO] companies] insertObject:company atIndex:destRow];
    [[DAO sharedDAO] trackCompanyPosition];
//    [self.tableView endUpdates];
    [self.collectionView reloadData];
    
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
                                      //                                      for(Company* company in self.dao.companies){
                                      //                                          for(NSString* components in self.stockComponents){
                                      //                                              [company setStockPrice: components];
                                      for(int i = 0; i < [self.dao.companies count]; i++){
                                          [self.dao.companies[i] setStockPrice: self.stockComponents[i]];
                                      }
                                      [str release];
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          [self.collectionView reloadData]; //dispatch main queue
                                      });
                                      
                                      
                                      
                                      
                                      
                                  }else {
                                      NSLog(@"Failed to fetch %@: %@", yahooAPIURL, error);
                                  }
                                  
                                  
                                  
                                  
                                  
                              }];
    
    [task resume];
}
@end
