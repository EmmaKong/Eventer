//
//  ContactViewController.h
//  BRSliderController
//
//  Created by admin on 15/6/16.
//  Copyright (c) 2015年 BR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>

@interface ContactViewController : UITableViewController
- (void)filterContentForSearchText:(NSString*)searchText;
@end
