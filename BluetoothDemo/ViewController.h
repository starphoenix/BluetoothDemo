//
//  ViewController.h
//  BluetoothDemo
//
//  Created by Dan Fellmeth on 8/21/12.
//  Copyright (c) 2012 Globus Medical Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BluetoothManager.h"

@interface ViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, BluetoothManagerDelegate>
{
	BluetoothManager *btManager;
}

@property (nonatomic, strong) IBOutlet UITableView* tableView;

-(IBAction)startScan:(id)sender;

@end
