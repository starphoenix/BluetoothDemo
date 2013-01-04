//
//  PeripheralViewController.m
//  BluetoothDemo
//
//  Created by Dan Fellmeth on 8/27/12.
//  Copyright (c) 2012 Globus Medical Inc. All rights reserved.
//

#import "PeripheralViewController.h"
#import "BluetoothPeripheral.h"
#import "ServiceViewController.h"
#import "ViewController.h"

@interface PeripheralViewController ()

@end

@implementation PeripheralViewController

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setPeripheral:(BluetoothPeripheral *)aPeripheral
{
	peripheral = aPeripheral;
	
	aPeripheral.delegate = self;
	
	[peripheral scanForServices];
	
	[self.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
}

-(void) viewWillAppear:(BOOL)animated
{
	peripheral.delegate = self;
}

-(void) bluetoothPeripheral:(BluetoothPeripheral *)peripheral didDiscoverServices:(NSArray *)services
{
	NSLog(@"%s", __FUNCTION__);
	[self.tableView reloadData];
}

-(void) bluetoothPeripheralDidUpdateName:(BluetoothPeripheral *)peripheral
{
	NSLog(@"%s", __FUNCTION__);
	[self.tableView reloadData];
}

-(void) bluetoothPeripheralDidUpdateRSSI:(BluetoothPeripheral *)peripheral
{
	NSLog(@"%s", __FUNCTION__);
	[self.tableView reloadData];
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
		return 3;//UUID, RSSI, name
	}
	else if ( section == 1 )
	{
		return peripheral.peripheral.services.count;
	}
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DataCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if ( indexPath.section == 0 )
	{
		switch ( indexPath.row )
		{
			case 0:
				cell.textLabel.text = (__bridge_transfer NSString *)CFUUIDCreateString(NULL, peripheral.peripheral.UUID);
				break;
			case 1:
				cell.textLabel.text = [peripheral.peripheral.RSSI stringValue];
				break;
			case 2:
				cell.textLabel.text = peripheral.peripheral.name;
			default:
				break;
		}
	}
	else if ( indexPath.section == 1 )
	{
		CBService *service = [peripheral.peripheral.services objectAtIndex:indexPath.row];
		cell.textLabel.text = [NSString stringWithFormat:@"%@", service.UUID];//(__bridge_transfer NSString *)CFUUIDCreateString(NULL, service.UUID);
	}
    return cell;
}

-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if ( section == 0 )
	{
		return @"Info";
	}
	else if ( section == 1 )
	{
		return @"Services";
	}
	else return @"";
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
	if ( indexPath.section == 0 )
	{
		switch ( indexPath.row )
		{
			case 0:
				break;
			case 1:
				[peripheral.peripheral readRSSI];
				break;
			case 2:
				break;
		}
	}
	if ( indexPath.section == 1 )
	{
		CBService *service = [peripheral.peripheral.services objectAtIndex:indexPath.row];
		ServiceViewController *serviceViewCon = [self.storyboard instantiateViewControllerWithIdentifier:@"ServiceViewController"];
		serviceViewCon.service = service;
		serviceViewCon.peripheral = peripheral;
		peripheral.delegate = serviceViewCon;
		[self.navigationController pushViewController:serviceViewCon animated:YES];
	}
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (IBAction)refresh:(UIRefreshControl*)ref
{
	[peripheral scanForServices];
	[ref endRefreshing];
}

- (IBAction)disconnect:(id)sender
{
	[[ViewController btInstance] disconnectPeripheral:peripheral];
	[self.navigationController popToRootViewControllerAnimated:YES];
}
@end
