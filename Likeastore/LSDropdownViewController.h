//
//  LSDropdownViewController.h
//  Likeastore
//
//  Created by Dmitri Voronianski on 29.04.14.
//  Copyright (c) 2014 Dmitri Voronianski. All rights reserved.
//

#import "DropdownMenuController.h"

@interface LSDropdownViewController : DropdownMenuController

@property (weak, nonatomic) IBOutlet UIImageView *logoView;
- (IBAction)logout:(id)sender;

@end
