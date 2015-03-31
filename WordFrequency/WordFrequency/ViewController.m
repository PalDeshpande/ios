//
//  ViewController.m
//  WordFrequency
//
//  Created by Pallavi Keskar on 2/25/15.
//  Copyright (c) 2015 Pallavi Keskar. All rights reserved.
//

#import "ViewController.h"
#import "WordsByFrequencyTableViewController.h"

@interface ViewController ()
@property (strong, nonatomic)NSArray *sortedWords;

@property (weak, nonatomic) IBOutlet UITextView *textField;
@property (weak, nonatomic) IBOutlet UITextField *numberofItemsField;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[WordsByFrequencyTableViewController class]]) {
        WordsByFrequencyTableViewController *destinationVC = segue.destinationViewController;
        destinationVC.wordsWithFrequency = self.wordWithFrequency;
        destinationVC.noOfWordsToReturn = [self.numberofItemsField.text intValue];
    }
}

#pragma mark - helper method

//Method to extract words from the test string into an array..
- (NSArray *) convertTextStringToArrayOfWords
{
    NSMutableCharacterSet *separators = [NSMutableCharacterSet punctuationCharacterSet];
    
    [separators formUnionWithCharacterSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSCharacterSet *whiteSpcaes = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *textString = [self.textField.text stringByTrimmingCharactersInSet:whiteSpcaes];
    NSArray *words = [textString componentsSeparatedByCharactersInSet:separators];
    return words;
    
}

//Prepare nsdictionary with word frequency
- (void)setUpDictionaryWithWordfFrequency: (NSArray *)words
{
    
    self.wordWithFrequency = [[NSMutableDictionary alloc] init];
    
    for (NSString *word in words) {
        if (word.length > 0) {
            if ([self.wordWithFrequency objectForKey:[word lowercaseString]]) {
                NSNumber *numberOfOccurences = [self.wordWithFrequency objectForKey:[word lowercaseString]];
                NSNumber *increment = [NSNumber numberWithInt:(1 + [numberOfOccurences intValue])];
                [self.wordWithFrequency setValue:increment forKey:[word lowercaseString]];
            }
            else
            {
                [self.wordWithFrequency setObject:[NSNumber numberWithInt:1] forKey:[word lowercaseString]];
            }
        }
        
    }
    
    
}

//When done button is pressed it takes the input string and creates a nsdictionary containing words and their frequency.

- (IBAction)doneButtonPressed:(UIButton *)sender {
    int noOfRequestedWords = [self.numberofItemsField.text intValue];
    
    if (noOfRequestedWords < 1) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"invalid word count" message:@"Invalid number of words requested" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
    }else
    {
        NSArray *words = [self convertTextStringToArrayOfWords];
        [self setUpDictionaryWithWordfFrequency: words];
        
        [self performSegueWithIdentifier:@"toWords" sender:nil];
    }
    
}

@end
