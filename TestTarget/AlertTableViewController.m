//
//  AlertTableViewController.m
//  FRY
//
//  Created by Brian King on 11/6/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "AlertTableViewController.h"
#import "CellItem.h"
NS_ENUM(NSUInteger, AlertType) {
    AlertTypeAlert = 0,
    AlertTypeAction,
    AlertTypeCount
};

@interface AlertTableViewController ()

@property (copy, nonatomic) NSArray *alerts;
@property (copy, nonatomic) NSArray *actions;
@end

@implementation AlertTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"1"];
    self.alerts = @[
                    [CellItem itemWithTitle:@"One" block:^{
                        [[[UIAlertView alloc] initWithTitle:@"Title" message:@"Message" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                    }],
                    [CellItem itemWithTitle:@"Two" block:^{
                        [[[UIAlertView alloc] initWithTitle:@"Title" message:@"Message" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:@"Two", nil] show];
                    }],

                    [CellItem itemWithTitle:@"Three" block:^{
                        [[[UIAlertView alloc] initWithTitle:@"Title" message:@"Message" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:@"Two", @"Three", nil] show];
                    }],
                    ];
    
    self.actions = @[
                     [CellItem itemWithTitle:@"Action One" block:^{
                         [[[UIActionSheet alloc] initWithTitle:@"Title" delegate:nil cancelButtonTitle:@"OK" destructiveButtonTitle:@"Destructive" otherButtonTitles:@"Other", nil] showInView:self.view];
                     }],
                    ];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return AlertTypeCount;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return section == AlertTypeAlert ? @"Alert" : @"Action";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self itemsForSection:section].count;
}

- (NSArray *)itemsForSection:(NSUInteger)section
{
    return section == AlertTypeAlert ? self.alerts : self.actions;
}

- (CellItem *)cellItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [[self itemsForSection:indexPath.section] objectAtIndex:indexPath.row];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"1" forIndexPath:indexPath];
    cell.textLabel.text = [self cellItemAtIndexPath:indexPath].title;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSelector:@selector(triggerBlockAtIndexPath:) withObject:indexPath afterDelay:0.5];
//    [self triggerBlockAtIndexPath:indexPath];
}

- (void)triggerBlockAtIndexPath:(NSIndexPath *)indexPath
{
    [self cellItemAtIndexPath:indexPath].block();
}

@end
