//
//  Photo.h
//  TagShutter
//
//  Created by Pallavi Keskar on 1/24/15.
//  Copyright (c) 2015 pallavi.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Album;

@interface Photo : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) id image;
@property (nonatomic, retain) Album *albumBook;

@end
