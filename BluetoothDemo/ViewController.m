//
//  ViewController.m
//  BluetoothDemo
//
//  Created by Dan Fellmeth on 8/21/12.
//  Copyright (c) 2012 Globus Medical Inc. All rights reserved.
//

#import "ViewController.h"
#import "BluetoothManager.h"
#import "BluetoothPeripheral.h"
#import "PeripheralViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize tableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	btManager = [[BluetoothManager alloc] init];
	btManager.delegate = self;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

-(void)startScan:(id)sender
{
	[btManager scanForPeripherals];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	int count = btManager.discoveredPeripherals.count;
	NSLog(@"%d", count);
	return count;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	NSLog(@"prepare for segue: peripheral: %@", btManager.connectedPeripheral);
	PeripheralViewController* pvc = (PeripheralViewController*)segue.destinationViewController;
	pvc.peripheral = btManager.connectedPeripheral;
}

-(UITableViewCell*) tableView:(UITableView *)atableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@"%s", __FUNCTION__);
	UITableViewCell *cell = [atableView dequeueReusableCellWithIdentifier:@"PeripheralCell"];
	
	BluetoothPeripheral *curPeripheral = [btManager.discoveredPeripherals objectAtIndex:indexPath.row];
	
	cell.textLabel.text = curPeripheral.name;
	
	return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	BluetoothPeripheral *curPeripheral = [btManager.discoveredPeripherals objectAtIndex:indexPath.row];
	
	[btManager connectToPeripheral:curPeripheral];
}

-(void)bluetoothManager:(BluetoothManager *)bluetoothManager didDiscoverPeripheral:(BluetoothPeripheral *)peripheral
{
	[self.tableView reloadData];
}

-(void)bluetoothManager:(BluetoothManager *)bluetoothManager didConnectPeripheral:(BluetoothPeripheral *)peripheral
{
	[self performSegueWithIdentifier:@"MySegue" sender:self];
}
@end
