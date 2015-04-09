//
//  TWSplitMenuViewController.h
//  TransientHub
//
//  Created by Kevin Hunt on 2015-04-03.
//  Copyright (c)  2015 Prophet Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TWBaseViewController.h"

@interface TWSplitMenuViewController : TWBaseViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)unwindToSidePanelMenuViewController:(UIStoryboardSegue *)segue;


@end

