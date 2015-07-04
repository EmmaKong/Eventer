//
//  contactListVCViewController.h
//  Eventer
//
//  Created by admin on 15/7/2.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactCell.h"
@interface contactListViewController : UIViewController<ContactCellDelegate, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
{
    
    NSMutableArray *searchResults;
    UISearchBar *contactsSearchBar;
    UISearchDisplayController *searchDisplayController;
    
}
@end