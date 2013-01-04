//
//  BluetoothManager.h
//  BluetoothDemo
//
//  Created by Dan Fellmeth on 8/24/12.
//  Copyright (c) 2012 Globus Medical Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@class BluetoothPeripheral;
@class BluetoothManager;

@protocol BluetoothManagerDelegate <NSObject>

-(void) bluetoothManager:(BluetoothManager*)bluetoothManager didDiscoverPeripheral:(BluetoothPeripheral*) peripheral;
-(void) bluetoothManager:(BluetoothManager *)bluetoothManager didConnectPeripheral:(BluetoothPeripheral *)peripheral;

@end

@interface BluetoothManager : NSObject<CBCentralManagerDelegate>
{
	CBCentralManager *centralManager;
	NSMutableArray *_discoveredPerpherals;
	BluetoothPeripheral *connectedPeripheral;
}

@property (nonatomic, strong) NSArray *discoveredPeripherals;
@property (nonatomic, readonly) BluetoothPeripheral* connectedPeripheral;
@property (nonatomic, weak) id<BluetoothManagerDelegate> delegate;

-(void) scanForPeripherals;
-(void) connectToPeripheral:(BluetoothPeripheral*)peripheral;
-(void) disconnectPeripheral:(BluetoothPeripheral*)peripheral;

@end
