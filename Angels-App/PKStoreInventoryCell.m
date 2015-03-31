//
//  PKStoreInventoryCell.m
//  Angels
//
//  Created by Pallavi Keskar on 1/22/15.
//  Copyright (c) 2015 pallavi.com. All rights reserved.
//

#import "PKStoreInventoryCell.h"

@implementation PKStoreInventoryCell

- (void)awakeFromNib {
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:@"cell"];
    if (self) {
        //initialize
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
