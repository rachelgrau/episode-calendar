//
//  EpisodeViewController.m
//  EpisodeCalendar
//
//  Created by Rachel on 25/01/2015.
//  Copyright (c) 2015 Rachel. All rights reserved.
//

#import "EpisodeViewController.h"

@interface EpisodeViewController ()
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *showLabel;
@end

@implementation EpisodeViewController

@synthesize name;
@synthesize show;
@synthesize season;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.nameLabel.text = self.name;
    self.showLabel.text = [NSString stringWithFormat:@"%@ (Season %d)", self.show, self.season];
    [self.showLabel setFont:[UIFont systemFontOfSize:22]];
    [self.nameLabel setFont:[UIFont systemFontOfSize:16]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
