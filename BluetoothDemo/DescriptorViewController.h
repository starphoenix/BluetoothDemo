//
//  DescriptorViewController.h
//  BluetoothDemo
//
//  Created by Dan Fellmeth on 9/4/12.
//  Copyright (c) 2012 Globus Medical Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BluetoothPeripheral.h"

@interface DescriptorViewController : UITableViewController<BluetoothPeripheralDelegate>

@property (weak, nonatomic) BluetoothPeripheral *peripheral;
@property (weak, nonatomic) CBDescriptor *descriptor;

@end
