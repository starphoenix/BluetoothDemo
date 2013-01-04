//
//  BluetoothPeripheral.m
//  BluetoothDemo
//
//  Created by Dan Fellmeth on 8/24/12.
//  Copyright (c) 2012 Globus Medical Inc. All rights reserved.
//

#import "BluetoothPeripheral.h"

@implementation BluetoothPeripheral

@synthesize name;
@synthesize peripheral;
@synthesize delegate;

-(NSString *)getName
{
	return (__bridge_transfer NSString *)CFUUIDCreateString(NULL, peripheral.UUID);;
}

-(id)initWithPeripheral:(CBPeripheral *)p
{
	self = [super init];
	if ( self )
	{
		peripheral = p;
		peripheral.delegate = self;
	}

	return self;
}

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
	NSLog(@"%@:%s", self, __FUNCTION__);
	if ( error != nil )
	{
		NSLog(@"ERROR: %@", error );
	}
	
	if ( delegate != nil && [delegate respondsToSelector:@selector(bluetoothPeripheral:didDiscoverCharacteristicsForService:)] )
	{
		[delegate bluetoothPeripheral:self didDiscoverCharacteristicsForService:service];
	}
	
	for ( CBCharacteristic *chara in service.characteristics )
	{
		[self.peripheral readValueForCharacteristic:chara];
	}
}

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
	NSLog(@"%@:%s", self, __FUNCTION__);
	if ( error != nil )
	{
		NSLog(@"ERROR: %@", error );
	}
	
	if ( delegate != nil && [delegate respondsToSelector:@selector(bluetoothPeripheral:didDiscoverDescriptorsForCharacteristic:)] )
	{
		[delegate bluetoothPeripheral:self didDiscoverDescriptorsForCharacteristic:characteristic];
	}
	
	for ( CBDescriptor *desc in characteristic.descriptors )
	{
		[self.peripheral readValueForDescriptor:desc];
	}
}

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverIncludedServicesForService:(CBService *)service error:(NSError *)error
{
	NSLog(@"%@:%s", self, __FUNCTION__);
	if ( error != nil )
	{
		NSLog(@"ERROR: %@", error );
	}
	
	if ( delegate != nil && [delegate respondsToSelector:@selector(bluetoothPeripheral:didDiscoverIncludedServicesForService:)] )
	{
		[delegate bluetoothPeripheral:self didDiscoverIncludedServicesForService:service];
	}
}

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
	NSLog(@"%@:%s", self, __FUNCTION__);
	if ( error != nil )
	{
		NSLog(@"ERROR: %@", error );
	}
	
	if ( delegate != nil && [delegate respondsToSelector:@selector(bluetoothPeripheral:didDiscoverServices:)] )
	{
		[delegate bluetoothPeripheral:self didDiscoverServices:self.peripheral.services];
	}
}

-(void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
	NSLog(@"%@:%s", self, __FUNCTION__);
	if ( error != nil )
	{
		NSLog(@"ERROR: %@", error );
	}
	
}

-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
	NSLog(@"%@:%s", self, __FUNCTION__);
	NSLog(@"Characteristic: %@", characteristic.UUID);
	if ( error != nil )
	{
		NSLog(@"ERROR: %@", error );
	}
	
	if ( delegate != nil && [delegate respondsToSelector:@selector(bluetoothPeripheral:didUpdateValueForCharacteristic:)] )
	{
		[delegate bluetoothPeripheral:self didUpdateValueForCharacteristic:characteristic];
	}
}

-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error
{
	NSLog(@"%@:%s", self, __FUNCTION__);
	NSLog(@"Descriptor: %@", descriptor.UUID);
	if ( error != nil )
	{
		NSLog(@"ERROR: %@", error );
	}
	
	if ( delegate != nil && [delegate respondsToSelector:@selector(bluetoothPeripheral:didUpdateValueForDescriptor:)] )
	{
		[delegate bluetoothPeripheral:self didUpdateValueForDescriptor:descriptor];
	}
}

-(void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
	NSLog(@"%@:%s", self, __FUNCTION__);
	if ( error != nil )
	{
		NSLog(@"ERROR: %@", error );
	}
	
	if ( delegate != nil && [delegate respondsToSelector:@selector(bluetoothPeripheral:didWriteValueForCharacteristic:)] )
	{
		[delegate bluetoothPeripheral:self didWriteValueForCharacteristic:characteristic];
	}
}

-(void)peripheral:(CBPeripheral *)peripheral didWriteValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error
{
	NSLog(@"%@:%s", self, __FUNCTION__);
	if ( error != nil )
	{
		NSLog(@"ERROR: %@", error );
	}
	
	if ( delegate != nil && [delegate respondsToSelector:@selector(bluetoothPeripheral:didWriteValueForDescriptor:)] )
	{
		[delegate bluetoothPeripheral:self didWriteValueForDescriptor:descriptor];
	}
}

-(void)peripheralDidInvalidateServices:(CBPeripheral *)peripheral
{
	NSLog(@"%@:%s", self, __FUNCTION__);	
}

-(void)peripheralDidUpdateName:(CBPeripheral *)peripheral
{
	NSLog(@"%@:%s", self, __FUNCTION__);
	if ( delegate != nil && [delegate respondsToSelector:@selector(bluetoothPeripheralDidUpdateName:)] )
	{
		[delegate bluetoothPeripheralDidUpdateName:self];
	}
	
}

-(void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error
{
	//	NSLog(@"%@:%s:%@", self, __FUNCTION__, delegate);
	if ( error != nil )
	{
		NSLog(@"ERROR: %@", error );
	}
	
	if ( delegate != nil && [delegate respondsToSelector:@selector(bluetoothPeripheralDidUpdateRSSI:)] )
	{
		[delegate bluetoothPeripheralDidUpdateRSSI:self];
	}
	
}

-(void) scanForServices
{
	[peripheral discoverServices:nil];
}

@end
