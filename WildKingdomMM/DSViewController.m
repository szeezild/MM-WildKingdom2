//
//  DSViewController.m
//  WildKingdomMM
//
//  Created by Dan Szeezil on 3/30/14.
//  Copyright (c) 2014 Dan Szeezil. All rights reserved.
//

#import "DSViewController.h"
#import "FlickrPhotoViewCell.h"



@interface DSViewController () <UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITabBarControllerDelegate>


@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;

@property (strong, nonatomic) NSMutableDictionary *searchResults;
@property (strong, nonatomic) NSMutableArray *searches;
@property (strong, nonatomic) NSString *textSearch;

@property (weak, nonatomic) IBOutlet UITabBarItem *sharkTab;

@property (weak, nonatomic) IBOutlet UITabBarItem *dolphinTab;

@property (weak, nonatomic) IBOutlet UITabBarItem *whaleTab;




@end


@implementation DSViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tabBarController.delegate = self;


    self.textSearch = @"shark";
    
    self.searches = [NSMutableArray new];
    
    [self searchFlickrPhotos:self.textSearch];
    
}



-(void)searchFlickrPhotos:(NSString *)text
{
    NSString *FlickrAPIKey = @"d5b7e67f5abf24695097b62bfb31259e";
    
    // Build the string to call the Flickr API
    NSString *urlString = [NSString stringWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&tags=%@&per_page=10&format=json&nojsoncallback=1", FlickrAPIKey, text];
    
    // Create NSURL string from formatted string
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // Setup and start async download
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSError *error;
        
        NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        
        // set meetings array to data
        self.searchResults = jsonData[@"photos"];
        NSArray *gettingPhotos = self.searchResults[@"photo"];

        
        [self.searches removeAllObjects];
 
        
        for (NSDictionary *items in gettingPhotos) {
            
            NSString *photoURL = [NSString stringWithFormat:@"http://farm%@.staticflickr.com/%@/%@_%@.jpg", items[@"farm"], items[@"server"], items[@"id"], items[@"secret"]];
            
//            NSLog(@"%@", photoURL);
            
            NSURL *url = [NSURL URLWithString:photoURL];
            NSData *data = [NSData dataWithContentsOfURL:url];
            UIImage *image = [UIImage imageWithData:data];
            [self.searches addObject:image];
        }
        
        [self.myCollectionView reloadData];
        
    }];

}


#pragma mark UICollectionView Datasource methods
    

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.searches.count;

}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
    
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FlickrPhotoViewCell *cell = [self.myCollectionView dequeueReusableCellWithReuseIdentifier:@"newCellID" forIndexPath:indexPath];
    
    UIImage *flickrImage = self.searches[indexPath.row];
    
    cell.imageView.image = flickrImage;
    
    return cell;
    
    
}


- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if (viewController.tabBarItem.tag == 1) {
        [self searchFlickrPhotos:@"shark"];
        
    } else if (viewController.tabBarItem.tag == 2) {
        [self searchFlickrPhotos:@"dolphins"];
        
    } else if (viewController.tabBarItem.tag == 3) {
        [self searchFlickrPhotos:@"whales"];
        
    }
}





@end













