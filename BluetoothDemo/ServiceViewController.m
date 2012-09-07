//
//  ServiceViewController.m
//  BluetoothDemo
//
//  Created by Dan Fellmeth on 8/30/12.
//  Copyright (c) 2012 Globus Medical Inc. All rights reserved.
//

#import "ServiceViewController.h"
#import "BluetoothPeripheral.h"
#import "CharacteristicViewController.h"

@interface ServiceViewController ()

@end

@implementation ServiceViewController

@synthesize service;
@synthesize peripheral;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
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

-(void) viewWillAppear:(BOOL)animated
{
	peripheral.delegate = self;
	[service.peripheral discoverCharacteristics:nil forService:service];
	[service.peripheral discoverIncludedServices:nil forService:service];
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
	if ( service.includedServices != nil && service.includedServices.count > 0 )
	{
		return 2;
	}
	else
	{
		return 1;
	}
}

-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if ( service.includedServices != nil && service.includedServices.count > 0 )
	{
		switch ( section )
		{
			case 0:
				return @"Included Services";
				break;
			case 1:
				return @"Characteristics";
				break;
				
			default:
				return @"";
				break;
		}
	}
	else
	{
		return @"Characteristics";
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
	if ( service.includedServices != nil && service.includedServices.count > 0 )
	{
		switch (section)
		{
			case 0:
				return service.includedServices.count;
				break;
		
			case 1:
				return service.characteristics.count;
				break;
				
			default:
				break;
		}
	}
	else
	{
		return service.characteristics.count;
	}
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ServiceCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
	cell.textLabel.adjustsFontSizeToFitWidth = YES;
	
	if ( service.includedServices != nil && service.includedServices.count > 0  && indexPath.section == 0 )
	{
		CBService *incServ = [service.includedServices objectAtIndex:indexPath.row];
		cell.textLabel.text = [NSString stringWithFormat:@"%@", incServ.UUID];
	}
	else
	{
		
		CBCharacteristic* chara = [service.characteristics objectAtIndex:indexPath.row];
		cell.textLabel.text = [NSString stringWithFormat:@"%@:%@", chara.UUID, chara.value];
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
	if ( service.includedServices != nil && service.includedServices.count > 0  && indexPath.section == 0 )
	{
		CBService *incServ = [service.includedServices objectAtIndex:indexPath.row];
		ServiceViewController *serviceViewCon = [self.storyboard instantiateViewControllerWithIdentifier:@"ServiceViewController"];
		serviceViewCon.service = incServ;
		serviceViewCon.peripheral = peripheral;
		peripheral.delegate = serviceViewCon;
		[self.navigationController pushViewController:serviceViewCon animated:YES];
	}
	else
	{
		CBCharacteristic* chara = [service.characteristics objectAtIndex:indexPath.row];
		CharacteristicViewController *charaViewCon = [self.storyboard instantiateViewControllerWithIdentifier:@"CharacteristicViewController"];
		charaViewCon.characteristic = chara;
		charaViewCon.peripheral = peripheral;
		peripheral.delegate = charaViewCon;
		[self.navigationController pushViewController:charaViewCon animated:YES];
	}
	
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

#pragma mark - BluetoothPeripheralDelegate

-(void) bluetoothPeripheral:(BluetoothPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service
{
	[self.tableView reloadData];
}

-(void)bluetoothPeripheral:(BluetoothPeripheral *)peripheral didDiscoverIncludedServicesForService:(CBService *)service
{
	[self.tableView reloadData];
}

-(void) bluetoothPeripheral:(BluetoothPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic
{
	[self.tableView reloadData];
}

@end
