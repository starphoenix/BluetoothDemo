//
//  PeripheralViewController.h
//  BluetoothDemo
//
//  Created by Dan Fellmeth on 8/27/12.
//  Copyright (c) 2012 Globus Medical Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BluetoothPeripheral.h"

@class BluetoothPeripheral;

@interface PeripheralViewController : UITableViewController<BluetoothPeripheralDelegate> 

@property (weak, nonatomic) BluetoothPeripheral* peripheral;

@end
