//
//  PKPhotodetailViewController.m
//  TagShutter
//
//  Created by Pallavi Keskar on 1/24/15.
//  Copyright (c) 2015 pallavi.com. All rights reserved.
//

#import "PKPhotodetailViewController.h"
#import "Photo.h"
#import "PKFiltersCollectionViewController.h"

@interface PKPhotodetailViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIButton *deleteButton;
@property (strong, nonatomic) IBOutlet UIButton *addFilterButton;

@end

@implementation PKPhotodetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.imageView.image = self.photo.image;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

- (IBAction)addFilterButtonPressed:(UIButton *)sender {
}

- (IBAction)deleteButtonPressed:(UIButton *)sender {
    
    [[self.photo managedObjectContext] deleteObject:self.photo];
    
    NSError *error = nil;
    [[self.photo managedObjectContext] save:&error];
    
    if (error) {
        NSLog(@"Error %@", error);
    }
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"filters"]) {
        if ([segue.destinationViewController isKindOfClass:[PKFiltersCollectionViewController class]]) {
            PKFiltersCollectionViewController *filtersVC = segue.destinationViewController;
            filtersVC.photo = self.photo;
        }
    }
}


@end
