//
//  PKPictureDataTransformer.m
//  TagShutter
//
//  Created by Pallavi Keskar on 1/23/15.
//  Copyright (c) 2015 pallavi.com. All rights reserved.
//

#import "PKPictureDataTransformer.h"
#import <UIKit/UIKit.h>

@implementation PKPictureDataTransformer

+ (Class)transformedValueClass
{
    return [NSData class];
}

+(BOOL)allowsReverseTransformation
{
    return YES;
}

- (id)transformedValue:(id)value
{
    return UIImagePNGRepresentation(value);
}

- (id)reverseTransformedValue:(id)value
{
    UIImage *image = [UIImage imageWithData:value];
    return image;
}
@end
