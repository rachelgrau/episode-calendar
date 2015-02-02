/**
 * File: EpisodeViewController.m
 * ------------------------------
 * Implementation of EpisodeViewController. Just sets some 
 * labels.
 */
#import "EpisodeViewController.h"

@interface EpisodeViewController ()
@property (strong, nonatomic) IBOutlet UILabel *showLabel;
@property (strong, nonatomic) IBOutlet UITextView *nameTextField;
@end

@implementation EpisodeViewController

@synthesize name;
@synthesize show;
@synthesize season;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.nameTextField.text = self.name;
    self.showLabel.text = [NSString stringWithFormat:@"%@ (Season %d)", self.show, self.season];
    [self.showLabel setFont:[UIFont systemFontOfSize:22]];
    [self.nameTextField setFont:[UIFont systemFontOfSize:16]];
    self.showLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.showLabel.numberOfLines = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
