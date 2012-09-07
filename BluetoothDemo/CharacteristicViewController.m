//
//  CharacteristicViewController.m
//  BluetoothDemo
//
//  Created by Dan Fellmeth on 8/30/12.
//  Copyright (c) 2012 Globus Medical Inc. All rights reserved.
//

#import "CharacteristicViewController.h"
#import "DescriptorViewController.h"

@interface CharacteristicViewController ()

@end

@implementation CharacteristicViewController

@synthesize peripheral;
@synthesize characteristic;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
	{
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated
{
	peripheral.delegate = self;
	[characteristic.service.peripheral discoverDescriptorsForCharacteristic:characteristic];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
	if ( section == 0 )
	{
		return 5;
	}
	else
	{
		return MAX(characteristic.descriptors.count,1);
	}
}

-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if ( section == 0 )
	{
		return @"Characteristic";
	}
	else
	{
		return @"Descriptors";
	}
}

-(void) bluetoothPeripheral:(BluetoothPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic
{
	[self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CharacteristicCell";
    UITableViewCell *cell = nil;
    
    // Configure the cell...
	if ( indexPath.section == 0 )
	{
		cell = [tableView dequeueReusableCellWithIdentifier:@"PropertyCell" forIndexPath:indexPath];
		if ( indexPath.row == 0 )
		{
			cell.textLabel.text = @"UUID";
			cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", characteristic.UUID];
		}
		else if ( indexPath.row == 1 )
		{
			cell.textLabel.text = @"Value";
			cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", characteristic.value];
		}
		else if ( indexPath.row == 2 )
		{
			cell.textLabel.text = @"Broadcasting";
			cell.detailTextLabel.text = (characteristic.isBroadcasted?@"YES":@"NO");
		}
		else if ( indexPath.row == 3 )
		{
			cell.textLabel.text = @"Notifying";
			cell.detailTextLabel.text = (characteristic.isNotifying?@"YES":@"NO");
		}
		else if ( indexPath.row == 4 )
		{
			cell.textLabel.text = @"Properties";
			cell.detailTextLabel.text = [NSString stringWithFormat:@"0x%0x", characteristic.properties];
		}
	}
	else
	{
		cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
		if ( characteristic.descriptors.count == 0 )
		{
			cell.textLabel.text = @"No descriptors found";
		}
		else
		{
			CBDescriptor *descriptor = [characteristic.descriptors objectAtIndex:indexPath.row];
			cell.textLabel.adjustsFontSizeToFitWidth = YES;
			cell.textLabel.text = [NSString stringWithFormat:@"%@:%@", descriptor.UUID, descriptor.value];
		}
	}
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if ( indexPath.section == 1 )
	{
		CBDescriptor *descriptor = [characteristic.descriptors objectAtIndex:indexPath.row];
		DescriptorViewController *descView = [self.storyboard instantiateViewControllerWithIdentifier:@"DescriptorViewController"];
		descView.peripheral = self.peripheral;
		descView.descriptor = descriptor;
		
		[self.navigationController pushViewController:descView animated:YES];
	}
	else if ( indexPath.section == 0 && indexPath.row == 1 )
	{
		if ( (characteristic.properties & CBCharacteristicPropertyWrite) != 0 )
		{
			UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"" message:@"Enter a new value:" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
			[av setAlertViewStyle:UIAlertViewStylePlainTextInput];
			[av show];
		}
		if ( ( characteristic.properties & CBCharacteristicPropertyNotify ) != 0 )
		{
			[peripheral.peripheral setNotifyValue:(!characteristic.isNotifying) forCharacteristic:characteristic];
		}
	}
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}
 
#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if ( buttonIndex == alertView.cancelButtonIndex )
	{
		return;
	}
	else
	{
		NSString *strVal = [alertView textFieldAtIndex:0].text;
		int8_t intVal = [strVal intValue];
		NSData *valData = [NSData dataWithBytes:&(intVal) length:sizeof(int8_t)];
		
		[peripheral.peripheral writeValue:valData forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
	}
}

#pragma mark - BluetoothPeripheralDelegate

-(void) bluetoothPeripheral:(BluetoothPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor
{
	[self.tableView reloadData];
}

-(void)bluetoothPeripheral:(BluetoothPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic
{
	[self.tableView reloadData];
}

@end
