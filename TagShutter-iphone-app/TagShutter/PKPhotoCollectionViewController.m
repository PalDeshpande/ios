//
//  PKPhotoCollectionViewController.m
//  TagShutter
//
//  Created by Pallavi Keskar on 1/23/15.
//  Copyright (c) 2015 pallavi.com. All rights reserved.
//

#import "PKPhotoCollectionViewController.h"
#import "PKPhotoCollectionViewCell.h"
#import "Photo.h"
#import "PKPictureDataTransformer.h"
#import "PkCoreDataHelper.h"
#import "PKPhotodetailViewController.h"

@interface PKPhotoCollectionViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (strong, nonatomic) IBOutlet UIBarButtonItem *cameraButton;
@property (strong, nonatomic) NSMutableArray *photos;

@end

@implementation PKPhotoCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

#pragma lazy instantiation

- (NSMutableArray *)photos
{
    if (!_photos) {
        _photos = [[NSMutableArray alloc] init];
    }
    return _photos;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[PKPhotoCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    NSSet *unorderedPhotos = self.album.photos;
    NSSortDescriptor *dateDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES];
    
    NSArray *sortedPhotos = [unorderedPhotos sortedArrayUsingDescriptors:@[dateDescriptor]];
    
    self.photos = [sortedPhotos mutableCopy];
    
    [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"photoDetails"]) {
        if ([segue.destinationViewController isKindOfClass:[PKPhotodetailViewController class]]) {
            PKPhotodetailViewController *detailsVC = segue.destinationViewController;
            NSIndexPath *path = [[self.collectionView indexPathsForSelectedItems] lastObject];
            
            Photo *selectedPhoto = self.photos[path.row];
            detailsVC.photo = selectedPhoto;
        }
    }
}


#pragma mark - IBACtion

- (IBAction)cameraButtonPressed:(UIBarButtonItem *)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }
    
    [self presentViewController:picker animated:YES completion:nil];
    
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [self.photos count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PKPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photo" forIndexPath:indexPath];
    
    
    Photo *photo = self.photos[indexPath.row];
    
    // Configure the cell
    cell.backgroundColor = [UIColor grayColor];
    cell.imageView.image = photo.image;
    
    return cell;
}

# pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerEditedImage];
    
    if (!image) {
        image = info[UIImagePickerControllerOriginalImage];
    }
    
    [self.photos addObject:[self photoFromImage:image]];
    
    [self.collectionView reloadData];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"Canceled");
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - heper methods

- (Photo *)photoFromImage:(UIImage *)image
{
    Photo *photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:[PkCoreDataHelper managedObjectContext]];
    photo.image = image;
    photo.date = [NSDate date];
    photo.albumBook = self.album;
    
    NSError *error = nil;
    
    if (![[photo managedObjectContext] save:&error]) {
        NSLog(@"error in saving %@", error);
    }
    
    return photo;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
