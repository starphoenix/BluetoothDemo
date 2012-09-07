//
//  CharacteristicViewController.h
//  BluetoothDemo
//
//  Created by Dan Fellmeth on 8/30/12.
//  Copyright (c) 2012 Globus Medical Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BluetoothPeripheral.h"

@class CBCharacteristic;

@interface CharacteristicViewController : UITableViewController<BluetoothPeripheralDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) BluetoothPeripheral *peripheral;
@property (weak, nonatomic) CBCharacteristic* characteristic;

@end
