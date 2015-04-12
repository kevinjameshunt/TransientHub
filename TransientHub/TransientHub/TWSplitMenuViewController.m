//
//  TWSplitMenuViewController.m
//  TransientHub
//
//  Created by Kevin Hunt on 2015-04-03.
//  Copyright (c)  2015 Prophet Studios. All rights reserved.
//

#import "TWSplitMenuViewController.h"
#import "TWDataManager.h"

@interface TWSplitMenuViewController ()

@property NSMutableArray *objects;
@end

@implementation TWSplitMenuViewController

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor blackColor];
    self.view.tintColor = [UIColor whiteColor];
    
    self.tableView.backgroundColor = [UIColor blackColor];
    self.tableView.tintColor = [UIColor whiteColor];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    // iphone on change of tableview height, needs to resize the side panel menu cells
    [self.tableView reloadData];
    [self.view layoutIfNeeded];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
}

- (IBAction)unwindToSidePanelMenuViewController:(UIStoryboardSegue *)segue {
}


#pragma mark - Table View

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 2;
            break;
        case 1:
            return 7;
            break;
        case 2:
            return 5;
            break;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    switch (section) {
        case 0: {
            if (row ==0) {
                cell = [tableView dequeueReusableCellWithIdentifier:@"WatchListCell"];
            } else if (row ==1) {
                cell = [tableView dequeueReusableCellWithIdentifier:@"HomeCell"];
            }
            break;
        }
        case 1: {
            if (row ==0) {
                cell = [tableView dequeueReusableCellWithIdentifier:@"GCNFeedCell"];
            } else if (row ==1) {
                cell = [tableView dequeueReusableCellWithIdentifier:@"SwiftFeedCell"];
            } else if (row ==2) {
                cell = [tableView dequeueReusableCellWithIdentifier:@"CRTSFeedCell"];
            } else if (row ==3) {
                cell = [tableView dequeueReusableCellWithIdentifier:@"ESAFeedCell"];
            } else if (row ==4) {
                cell = [tableView dequeueReusableCellWithIdentifier:@"IAUFeedCell"];
            } else if (row ==5) {
                cell = [tableView dequeueReusableCellWithIdentifier:@"AFeedCell"];
            } else if (row ==6) {
                cell = [tableView dequeueReusableCellWithIdentifier:@"AddFeedCell"];
            }
            break;
        }
        case 2: {
            switch (row) {
                case 0:
                    cell = [tableView dequeueReusableCellWithIdentifier:@"GlossaryCell"];
                    break;
                case 1:
                    cell = [tableView dequeueReusableCellWithIdentifier:@"SettingsCell"];
                    break;
                case 2:
                    cell = [tableView dequeueReusableCellWithIdentifier:@"FeedbackCell"];
                    break;
                case 3:
                    cell = [tableView dequeueReusableCellWithIdentifier:@"AboutCell"];
                    break;
                case 4:
                    cell = [tableView dequeueReusableCellWithIdentifier:@"TermsCell"];
                    break;
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
    
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.tintColor = [UIColor colorWithRed:0.0f/255.0f green:161.0f/255.0f blue:196.0f/255.0f alpha:1.0f];

    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

@end
