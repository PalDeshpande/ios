//
//  PKStripeViewController.h
//  Angels
//
//  Created by Pallavi Keskar on 1/20/15.
//  Copyright (c) 2015 pallavi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PKStripeViewControllerDelegate <NSObject>

@required
-(void)clearCart;

@end

@interface PKStripeViewController : UIViewController
@property(weak, nonatomic)id <PKStripeViewControllerDelegate> delegate;

@end
