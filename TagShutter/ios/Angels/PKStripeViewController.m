//
//  PKStripeViewController.m
//  Angels
//
//  Created by Pallavi Keskar on 1/20/15.
//  Copyright (c) 2015 pallavi.com. All rights reserved.
//

#import "PKStripeViewController.h"
#import "Stripe.h"
#import "RWCheckoutDisplayCell.h"
#import "RWCheckoutInputCell.h"
#import <Parse/Parse.h>
#import "PKViewCartViewController.h"

#define STRIPE_TEST_PUBLIC_KEY @"pk_test_15i5yueM5JeQ1evPt8FXR0a0"
#define STRIPE_TEST_POST_URL

@interface PKStripeViewController ()<UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView* tableView;
@property (strong, nonatomic) IBOutlet UIView* buttonView;
@property (strong, nonatomic) IBOutlet UIButton* completeButton;

@property (strong, nonatomic) UITextField* nameTextField;
@property (strong, nonatomic) UITextField* emailTextField;
@property (strong, nonatomic) UITextField* expirationDateTextField;
@property (strong, nonatomic) UITextField* cardNumber;
@property (strong, nonatomic) UITextField* CVCNumber;

@property (strong, nonatomic) NSArray* monthArray;
@property (strong, nonatomic) NSNumber* selectedMonth;
@property (strong, nonatomic) NSNumber* selectedYear;
@property (strong, nonatomic) UIPickerView *expirationDatePicker;

@property (strong, nonatomic) STPCard *stripeCard;

@end

@implementation PKStripeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.monthArray = @[@"01 - January", @"02 - February", @"03 - March",
                        @"04 - April", @"05 - May", @"06 - June", @"07 - July", @"08 - August", @"09 - September",
                        @"10 - October", @"11 - November", @"12 - December"];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Stripe

- (IBAction)completeButtonTapped:(id)sender
{
    self.stripeCard = [[STPCard alloc] init];
    self.stripeCard.name = self.nameTextField.text;
    self.stripeCard.number = self.cardNumber.text;
    self.stripeCard.cvc = self.CVCNumber.text;
    self.stripeCard.expMonth = [self.selectedMonth integerValue];
    self.stripeCard.expYear = [self.selectedYear integerValue];
    
    if ([self validateCustomerInfo]) {
        [self performStripeOperation];
    }
    
    STPAPIClient *client = [[STPAPIClient alloc] initWithPublishableKey:STRIPE_TEST_PUBLIC_KEY];
    
    [client createTokenWithCard:self.stripeCard completion:^(STPToken *token, NSError *error) {
        if (error) {
            [self handleStripeError:error];
        } else {
            [self createBackendChargeWithToken:token];
        }
    }];
}

- (void)handleStripeError:(NSError *) error {
    
    //1
    if ([error.domain isEqualToString:@"StripeDomain"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:[error localizedDescription]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    //2
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Please try again"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    self.completeButton.enabled = YES;
}

- (void)createBackendChargeWithToken:(STPToken *)token
{
    PFObject *stripeToken = [PFObject objectWithClassName:@"Stripe_token"];
    [stripeToken setObject:[PFUser currentUser] forKey:@"user"];
    [stripeToken setObject:token.tokenId forKey:@"token"];
    [stripeToken saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [self chargeDidSucceed];
        }else{
            [self chargeDidNotSuceed];
        }
    }];
    
}




- (BOOL)validateCustomerInfo
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Please try again"
                                                     message:@"Please enter all required information"
                                                    delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
    
    //Validate name and email.
    
    if (self.nameTextField.text == 0 || self.emailTextField.text.length == 0) {
        [alert show];
        return NO;
    }
    
    //Vlidate card number, cvc, expire date.
    NSError *error = nil;
    [self.stripeCard validateCardReturningError:&error];
    
    if (error) {
        alert.message = [error localizedDescription];
        return NO;
    }
    
    return YES;
}

- (void)performStripeOperation
{
    self.completeButton.enabled = NO;
    
    
}




- (void)chargeDidSucceed {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                    message:@"yayy! Order is on it's way!"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [self clearCart];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)clearCart
{
    [self.delegate clearCart];
}

- (void)chargeDidNotSuceed {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Payment not successful"
                                                    message:@"Please try again later."
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];}


/* The methods below implement the user interface. You don't need to change anything. */

#pragma mark - UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2; // (1) user details, (2) credit card details
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return (section == 0) ? @"Customer Info" : @"Credit Card Details";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (section == 0) ? 2 : 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (section == 0 && row == 0) {
        RWCheckoutInputCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"CheckoutInputCell"];
        cell.nameLabel.text = @"Name";
        cell.textField.placeholder = @"Required";
        cell.textField.keyboardType = UIKeyboardTypeAlphabet;
        self.nameTextField = cell.textField;
        return cell;
    }
    else if (section == 0 && row == 1) {
        RWCheckoutInputCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"CheckoutInputCell"];
        cell.nameLabel.text = @"E-mail";
        cell.textField.placeholder = @"Required";
        self.emailTextField = cell.textField;
        cell.textField.keyboardType = UIKeyboardTypeAlphabet;
        return cell;
    }
    else if (section == 1 && row == 0) {
        RWCheckoutInputCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"CheckoutInputCell"];
        cell.nameLabel.text = @"Card Number";
        cell.textField.placeholder = @"Required";
        cell.textField.keyboardType = UIKeyboardTypeNumberPad;
        self.cardNumber = cell.textField;
        return cell;
    }
    else if (section == 1 && row == 1) {
        RWCheckoutInputCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"CheckoutInputCell"];
        cell.nameLabel.text = @"Exp. Date";
        cell.textField.text = @"Required";
        cell.textField.textColor = [UIColor lightGrayColor];
        self.expirationDateTextField = cell.textField;
        return cell;
    }
    else if (section == 1 && row == 2) {
        RWCheckoutInputCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"CheckoutInputCell"];
        cell.nameLabel.text = @"CVC Number";
        cell.textField.placeholder = @"Required";
        self.CVCNumber = cell.textField;
        cell.textField.keyboardType = UIKeyboardTypeNumberPad;
        [self configurePickerView];
        return cell;
    }
    
    return nil;
}

#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - UIPicker data source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return (component == 0) ? 12 : 10;
}

#pragma mark - UIPicker delegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if (component == 0) {
        //Expiration month
        return self.monthArray[row];
    }
    else {
        //Expiration year
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy"];
        NSInteger currentYear = [[dateFormatter stringFromDate:[NSDate date]] integerValue];
        return [NSString stringWithFormat:@"%li", currentYear + row];
    }
    
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (component == 0) {
        self.selectedMonth = @(row + 1);
    }
    else {
        NSString *yearString = [self pickerView:self.expirationDatePicker titleForRow:row forComponent:1];
        self.selectedYear = @([yearString integerValue]);
    }
    
    
    if (!self.selectedMonth) {
        [self.expirationDatePicker selectRow:0 inComponent:0 animated:YES];
        self.selectedMonth = @(1); //Default to January if no selection
    }
    
    if (!self.selectedYear) {
        [self.expirationDatePicker selectRow:0 inComponent:1 animated:YES];
        NSString *yearString = [self pickerView:self.expirationDatePicker titleForRow:0 forComponent:1];
        self.selectedYear = @([yearString integerValue]); //Default to current year if no selection
    }
    
    self.expirationDateTextField.text = [NSString stringWithFormat:@"%@/%@", self.selectedMonth, self.selectedYear];
    self.expirationDateTextField.textColor = [UIColor blackColor];
}

#pragma mark - UIPicker configuration

- (void)configurePickerView {
    self.expirationDatePicker = [[UIPickerView alloc] init];
    self.expirationDatePicker.delegate = self;
    self.expirationDatePicker.dataSource = self;
    self.expirationDatePicker.showsSelectionIndicator = YES;
    
    //Create and configure toolabr that holds "Done button"
    UIToolbar *pickerToolbar = [[UIToolbar alloc] init];
    pickerToolbar.barStyle = UIBarStyleBlackTranslucent;
    [pickerToolbar sizeToFit];
    
    UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc]
                                          initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                          target:nil
                                          action:nil];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(pickerDoneButtonPressed)];
    
    [pickerToolbar setItems:[NSArray arrayWithObjects:flexibleSpaceLeft, doneButton, nil]];
    
    
    self.expirationDateTextField.inputView = self.expirationDatePicker;
    self.expirationDateTextField.inputAccessoryView = pickerToolbar;
    self.nameTextField.inputAccessoryView = pickerToolbar;
    self.emailTextField.inputAccessoryView = pickerToolbar;
    self.cardNumber.inputAccessoryView = pickerToolbar;
    self.CVCNumber.inputAccessoryView = pickerToolbar;
}

- (void)pickerDoneButtonPressed {
    [self.view endEditing:YES];
}

@end
