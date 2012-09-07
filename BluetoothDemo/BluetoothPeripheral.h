//
//  BluetoothPeripheral.h
//  BluetoothDemo
//
//  Created by Dan Fellmeth on 8/24/12.
//  Copyright (c) 2012 Globus Medical Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@class BluetoothPeripheral;

@protocol BluetoothPeripheralDelegate <NSObject>

@optional
-(void) bluetoothPeripheral:(BluetoothPeripheral*) peripheral didDiscoverServices:(NSArray*)services;
-(void) bluetoothPeripheralDidUpdateName:(BluetoothPeripheral*)peripheral;
-(void) bluetoothPeripheralDidUpdateRSSI:(BluetoothPeripheral*)peripheral;

-(void) bluetoothPeripheral:(BluetoothPeripheral*) peripheral didDiscoverCharacteristicsForService:(CBService*) service;
-(void) bluetoothPeripheral:(BluetoothPeripheral*) peripheral didDiscoverIncludedServicesForService:(CBService*) service;

-(void) bluetoothPeripheral:(BluetoothPeripheral*) peripheral didUpdateValueForCharacteristic:(CBCharacteristic*) characteristic;
-(void) bluetoothPeripheral:(BluetoothPeripheral*) peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic*) characteristic;
-(void) bluetoothPeripheral:(BluetoothPeripheral*) peripheral didWriteValueForCharacteristic:(CBCharacteristic*)characteristic;

-(void) bluetoothPeripheral:(BluetoothPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor*) descriptor;
-(void) bluetoothPeripheral:(BluetoothPeripheral*) peripheral didWriteValueForDescriptor:(CBDescriptor*) descriptor;

@end

@interface BluetoothPeripheral : NSObject<CBPeripheralDelegate>
{
	CBPeripheral *peripheral;
}

-(id) initWithPeripheral:(CBPeripheral*) p;
-(void) scanForServices;

@property (nonatomic, readonly, getter = getName) NSString *name;
@property (nonatomic, readonly) CBPeripheral* peripheral;
@property (weak, nonatomic) id<BluetoothPeripheralDelegate> delegate;
@end
