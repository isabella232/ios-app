//
//  LSEmailLoginViewController.m
//  Likeastore
//
//  Created by Dmitri Voronianski on 08.05.14.
//  Copyright (c) 2014 Dmitri Voronianski. All rights reserved.
//

#import "LSEmailLoginViewController.h"
#import "LSLikeastoreHTTPClient.h"

#import <ALPValidator/ALPValidator.h>
#import <NSURL+ParseQuery/NSURL+QueryParser.h>

@interface LSEmailLoginViewController ()

@end

@implementation LSEmailLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNeedsStatusBarAppearanceUpdate];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (IBAction)login:(id)sender {
    NSString *email = [self.emailField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    ALPValidator *emailValidator = [ALPValidator validatorWithType:ALPValidatorTypeString];
    [emailValidator addValidationToEnsurePresenceWithInvalidMessage:@"Make sure you enter an email!"];
    [emailValidator addValidationToEnsureValidEmailWithInvalidMessage:@"Your email looks incorrect!"];
    [emailValidator validate:email];
    
    if (!emailValidator.isValid) {
        [self showErrorAlert:emailValidator.errorMessages[0]];
        return;
    }
    
    NSString *password = [self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    ALPValidator *passwordValidator = [ALPValidator validatorWithType:ALPValidatorTypeString];
    [passwordValidator addValidationToEnsurePresenceWithInvalidMessage:@"Make sure you enter a password!"];
    [passwordValidator addValidationToEnsureRegularExpressionIsMetWithPattern:@"^[0-9A-z-_.+=@!#()&%?]+$" invalidMessage:@"Your password contains not allowed symbols"];
    [passwordValidator validate:password];
    
    if (!passwordValidator.isValid) {
        [self showErrorAlert:passwordValidator.errorMessages[0]];
        return;
    }
    
    LSLikeastoreHTTPClient *api = [LSLikeastoreHTTPClient create];
    NSDictionary *credentials = @{@"email": email, @"password": password};
    [api loginWithCredentials:credentials success:^(AFHTTPRequestOperation *operation, id responseObject) {
        /* if first time user go to setup
         if (<#condition#>) {
            <#statements#>
        } */
        
        NSURL *appUrl = [NSURL URLWithString:[responseObject objectForKey:@"applicationUrl"]];
        NSDictionary *query = [appUrl parseQuery];
        
        [api getAccessToken:query success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"success: %@", responseObject);
            [self performSegueWithIdentifier:@"fromEmailAuthToFeed" sender:self];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self showErrorAlert:@"Something bad happened on our side. Please try again later!"];
        }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showErrorAlert:@"Email and password do not match!"];
    }];
}

- (void)showErrorAlert:(NSString *)message {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops!" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

#pragma mark - Gestures

- (IBAction)swipeGestureHandle:(UISwipeGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateEnded &&
        recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        [self performSegueWithIdentifier:@"backToSocialLogin" sender:self];
    }
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end