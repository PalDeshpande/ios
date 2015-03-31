//
//  PKPhotoCollectionViewCell.m
//  TagShutter
//
//  Created by Pallavi Keskar on 1/23/15.
//  Copyright (c) 2015 pallavi.com. All rights reserved.
//

#import "PKPhotoCollectionViewCell.h"
#import <UIKit/UIKit.h>
#import "PkCoreDataHelper.h"

#define IMAGEVIEW_BORDER_LENGTH 5

@implementation PKPhotoCollectionViewCell

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

 -(void)setup
{
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectInset(self.bounds, IMAGEVIEW_BORDER_LENGTH, IMAGEVIEW_BORDER_LENGTH)];
    
    [self.contentView addSubview:self.imageView];
}
@end
