//
//  BluetoothManager.m
//  BluetoothDemo
//
//  Created by Dan Fellmeth on 8/24/12.
//  Copyright (c) 2012 Globus Medical Inc. All rights reserved.
//

#import "BluetoothManager.h"
#import "BluetoothPeripheral.h"

@interface BluetoothManager()
{
	NSTimer* rssiTimer;
}

@end

@implementation BluetoothManager

@synthesize discoveredPeripherals=_discoveredPerpherals;
@synthesize delegate;
@synthesize connectedPeripheral;

-(id) init
{
	self = [super init];
	if ( self )
	{
		centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];
		_discoveredPerpherals = [[NSMutableArray alloc] init];
		connectedPeripheral = nil;
	}
	
	return self;
}

-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
	NSLog(@"%s", __FUNCTION__);
	[peripheral readRSSI];
	
//	rssiTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(checkRSSI:) userInfo:nil repeats:YES];
	
	if ( delegate != nil )
	{
		[delegate bluetoothManager:self didConnectPeripheral:connectedPeripheral];
	}
}

-(void) checkRSSI:(NSTimer*)timer
{
	if ( connectedPeripheral != nil )
	{
		[connectedPeripheral.peripheral readRSSI];
	}
}

-(void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
	NSLog(@"%s", __FUNCTION__);
}

-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
	NSLog(@"Advertisement data: %@", advertisementData);
	NSLog(@"Found peripheral: %@", [peripheral name]);
	NSLog(@"Advertised name: %@", [advertisementData objectForKey:CBAdvertisementDataLocalNameKey]);
	for ( BluetoothPeripheral* p in _discoveredPerpherals )
	{
		if ( [p.peripheral isEqual:peripheral] )
		{
			//already contained, return
			return;
		}
	}
	BluetoothPeripheral *btPeripheral = [[BluetoothPeripheral alloc] initWithPeripheral:peripheral];
	[_discoveredPerpherals addObject:btPeripheral];
	if ( delegate != nil )
	{
		[delegate bluetoothManager:self didDiscoverPeripheral:btPeripheral];
	}
	NSLog(@"BT Name: %@", [btPeripheral getName]);
	
}

-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
	NSLog(@"%s", __FUNCTION__);
	
}

-(void)centralManager:(CBCentralManager *)central didRetrieveConnectedPeripherals:(NSArray *)peripherals
{
	NSLog(@"%s", __FUNCTION__);
	
}

-(void)centralManager:(CBCentralManager *)central didRetrievePeripherals:(NSArray *)peripherals
{
	NSLog(@"%s", __FUNCTION__);
	
}

-(void)centralManagerDidUpdateState:(CBCentralManager *)central
{
	NSLog(@"%s", __FUNCTION__);
}

-(void) scanForPeripherals
{
	if ( connectedPeripheral != nil )
	{
		[centralManager cancelPeripheralConnection:connectedPeripheral.peripheral];
		connectedPeripheral = nil;
	}
	NSDictionary	*options	= [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:CBCentralManagerScanOptionAllowDuplicatesKey];
	NSLog(@"%s, %@ : %@", __FUNCTION__, centralManager, options);
	[centralManager scanForPeripheralsWithServices:nil options:options];
}

-(void) connectToPeripheral:(BluetoothPeripheral*) peripheral
{
	if ( connectedPeripheral != nil )
	{
		[centralManager cancelPeripheralConnection:connectedPeripheral.peripheral];
		connectedPeripheral = nil;
	}
	[centralManager stopScan];
	[centralManager connectPeripheral:peripheral.peripheral options:nil];
	connectedPeripheral = peripheral;
}

@end
