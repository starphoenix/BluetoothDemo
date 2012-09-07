//
//  ServiceViewController.h
//  BluetoothDemo
//
//  Created by Dan Fellmeth on 8/30/12.
//  Copyright (c) 2012 Globus Medical Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BluetoothPeripheral.h"

@class CBService;

@interface ServiceViewController : UITableViewController<BluetoothPeripheralDelegate>

@property (weak, nonatomic) BluetoothPeripheral *peripheral;
@property (weak, nonatomic) CBService* service;

@end
