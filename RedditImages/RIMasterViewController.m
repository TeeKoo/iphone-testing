//
//  RIMasterViewController.m
//  RedditImages
//
//  Created by Taneli Kärkkäinen on 12/06/14.
//  Copyright (c) 2014 Taneli Kärkkäinen. All rights reserved.
//

#import "RIMasterViewController.h"

#import "RIDetailViewController.h"

#import "RIImages.h"

@interface RIMasterViewController () {
    NSMutableArray *_objects;
    NSMutableArray *allImages;
    RIImages *images;
    UIActivityIndicatorView *spinner;
}
@end

@implementation RIMasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //self.navigationItem.leftBarButtonItem = self.editButtonItem;
    //allImages = [[NSMutableArray alloc] init];
    //UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    //self.navigationItem.rightBarButtonItem = addButton;
    
    allImages = [[NSMutableArray alloc] init];
    spinner = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(150, 225, 20, 30)];
    [spinner setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    spinner.color = [UIColor blueColor];
    [self.view addSubview:spinner];
    
    [self getJSONdatas];
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    
    
    
    [refresh addTarget:self action:@selector(crunchNumbers)
      forControlEvents:UIControlEventValueChanged];
    
    self.refreshControl = refresh;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
    /*
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [allImages insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];*/
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [allImages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    NSString *instagramImage = [allImages objectAtIndex:indexPath.row];
    cell.textLabel.text = instagramImage;
    UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:instagramImage]]];
    cell.imageView.image = img;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSString *img = [allImages objectAtIndex:indexPath.row];
        [[segue destinationViewController] setDetailItem:img];
    }
}

- (void)getJSONdatas{
    
    [NSThread detachNewThreadSelector:@selector(threadStartAnimating:) toTarget:self withObject:nil];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL
                                                          URLWithString:@"https://api.instagram.com/v1/media/popular?access_token=1269091895.1fb234f.e112bc323f1146cf91359c9d906ba8dc"]];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
        if ([data length] > 0 && error == nil){
            NSLog(@"OK!");
            NSError *jsonParsingError = nil;
            NSDictionary *instagramArray = [NSJSONSerialization JSONObjectWithData:data
                                                                           options:0 error:&jsonParsingError];
            
            NSDictionary *dataArr = [instagramArray objectForKey:@"data"];
            for (id key in dataArr) {
                NSDictionary *dataArr2 = [key objectForKey:@"images"];
                for (id key2 in dataArr2) {
                    if ([key2 isEqualToString:@"low_resolution"]){
                        NSDictionary *imageData = [dataArr2 objectForKey:key2];
                        NSString *imageURL = [imageData objectForKey:@"url"];
                        [allImages addObject:imageURL];
                    }
                    
                }
                
            }
            [self stopSpinner];
            [self.tableView reloadData];
        }
        else if ([data length] == 0 && error == nil)
            [self stopSpinner];
        else if (error != nil)
            [self stopSpinner];
    }];

}

//Animaatio jutut.

-(void)threadStartAnimating:(id)data
{
    [spinner startAnimating];
}

-(void)stopSpinner{
    [spinner stopAnimating];
}

- (void)stopRefresh
{
    [self.refreshControl endRefreshing];
}

- (void)crunchNumbers
{
    [self getJSONdatas];
    [self performSelector:@selector(stopRefresh) withObject:nil];
}

@end
