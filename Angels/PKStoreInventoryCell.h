//
//  PKStoreInventoryCell.h
//  Angels
//
//  Created by Pallavi Keskar on 1/22/15.
//  Copyright (c) 2015 pallavi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PKStoreInventoryCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *productPicture;
@property (strong, nonatomic) IBOutlet UILabel *productName;
@property (strong, nonatomic) IBOutlet UILabel *price;

@end
