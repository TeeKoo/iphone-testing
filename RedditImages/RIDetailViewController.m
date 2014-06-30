//
//  RIDetailViewController.m
//  RedditImages
//
//  Created by Taneli Kärkkäinen on 12/06/14.
//  Copyright (c) 2014 Taneli Kärkkäinen. All rights reserved.
//

#import "RIDetailViewController.h"

@interface RIDetailViewController ()
- (void)configureView;
@end

@implementation RIDetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        //self.detailDescriptionLabel.text = [self.detailItem description];
        UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[self.detailItem description]]]];
        self.instagramDetail.image = img;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
