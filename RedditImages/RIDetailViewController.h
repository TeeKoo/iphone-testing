//
//  RIDetailViewController.h
//  RedditImages
//
//  Created by Taneli Kärkkäinen on 12/06/14.
//  Copyright (c) 2014 Taneli Kärkkäinen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RIDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UIImageView *instagramDetail;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
