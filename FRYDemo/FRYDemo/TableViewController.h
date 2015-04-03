//
//  TableViewController.h
//  FRY
//
//  Created by Brian King on 11/8/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TableViewTitleForRow(i) ({[NSString stringWithFormat:@"Item %zd", i];})

@interface TableViewController : UITableViewController

@end
