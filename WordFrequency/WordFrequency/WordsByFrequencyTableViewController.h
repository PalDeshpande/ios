//
//  WordsByFrequencyTableViewController.h
//  WordFrequency
//
//  Created by Pallavi Keskar on 2/25/15.
//  Copyright (c) 2015 Pallavi Keskar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WordsByFrequencyTableViewController : UITableViewController
@property (strong, nonatomic) NSMutableDictionary *wordsWithFrequency;
@property (nonatomic) int noOfWordsToReturn;
@end
