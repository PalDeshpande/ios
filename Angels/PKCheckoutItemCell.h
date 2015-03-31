//
//  PKCheckoutItemCell.h
//  Angels
//
//  Created by Pallavi Keskar on 1/27/15.
//  Copyright (c) 2015 pallavi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PKCheckoutItemCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *productNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *productQuantityLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@end
