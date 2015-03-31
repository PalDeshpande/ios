//
//  PKAlbumTableViewController.h
//  TagShutter
//
//  Created by Pallavi Keskar on 1/23/15.
//  Copyright (c) 2015 pallavi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PKAlbumTableViewController : UITableViewController

@property (strong, nonatomic) NSMutableArray *albums;
- (IBAction)addAlbumButtonPressed:(UIBarButtonItem *)sender;

@end
