//
//  PkCoreDataHelper.m
//  TagShutter
//
//  Created by Pallavi Keskar on 1/23/15.
//  Copyright (c) 2015 pallavi.com. All rights reserved.
//

#import "PkCoreDataHelper.h"
#import <UIKit/UIKit.h>

@implementation PkCoreDataHelper

+(NSManagedObjectContext *)managedObjectContext

{
    
    NSManagedObjectContext *context = nil;
    
    id delegate = [[UIApplication sharedApplication] delegate];
    
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        
        context = [delegate managedObjectContext];
        
    }
    
    return context;

    
}
@end
