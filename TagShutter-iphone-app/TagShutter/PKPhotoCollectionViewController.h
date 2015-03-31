//
//  PKPhotoCollectionViewController.h
//  TagShutter
//
//  Created by Pallavi Keskar on 1/23/15.
//  Copyright (c) 2015 pallavi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Album.h"

@interface PKPhotoCollectionViewController : UICollectionViewController

@property (strong, nonatomic) Album *album;
@end
