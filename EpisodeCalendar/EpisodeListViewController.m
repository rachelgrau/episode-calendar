//
//  EpisodeListViewController.m
//  EpisodeCalendar
//
//  Created by Rachel on 25/01/2015.
//  Copyright (c) 2015 Rachel. All rights reserved.
//

#import "EpisodeListViewController.h"
#import "Episode.h"
#import "EpisodeViewController.h"

@interface EpisodeListViewController ()
@property NSArray *tvShows;
@property NSDictionary *tvShowsDict;
@property NSMutableArray *dates;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property UINavigationController *nvc;
@end

@implementation EpisodeListViewController

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
    
    self.tvShows = [Episode fetchAll];
    self.dates = [[NSMutableArray alloc] init];
    self.tvShowsDict = [Episode fetchAllByDate:self.dates];
    self.nvc = [self navigationController];
    
    // Do any additional setup after loading the view.
}

- (void) viewDidAppear:(BOOL)animated {
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

/* Given an NSIndexPath for our table view, return the Episode that
    exists at that index path in the table. */
- (Episode *) getEpisodeFromIndexPath:(NSIndexPath *)indexPath {
    NSDate *date = [self.dates objectAtIndex:[indexPath section]];
    NSArray *epsInSection = [self.tvShowsDict objectForKey:date];
    return [epsInSection objectAtIndex:[indexPath row]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
 
 /* Prepare information about selected cell to send to EpisodeViewController */
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
     if ([segue.identifier isEqualToString:@"toEpisodeDetail"]) {
         EpisodeViewController *destViewController = segue.destinationViewController;
         /* Get the selected episode based on index path */
         NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
         Episode *ep = [self getEpisodeFromIndexPath:indexPath];
         /* Set properties of EpisodeViewController to display info about selected episode */
         [destViewController setName:ep.name];
         [destViewController setShow:ep.show];
         [destViewController setSeason:ep.season];
     }
 }

#pragma mark - UITableView Datasource

/* Returns # of sections in the table view (number of dates) */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.dates count];
}

/* Returns the title of the section (date in string form) */
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDate *dateToShow = [self.dates objectAtIndex:section];
    NSDateFormatter *monthAndDay = [[NSDateFormatter alloc] init];
    
    /* Get components so we can get day in int form */
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:dateToShow];
    
    /* Make sure we display "1st" "2nd" "3rd" and "nth" for all n > 3 */
    if ([components day] == 1) {
        [monthAndDay setDateFormat:@"MMM. d'st' '('EEE')'"];
    } else if ([components day] == 2) {
        [monthAndDay setDateFormat:@"MMM. d'nd' '('EEE')'"];
    } else if ([components day] == 3) {
        [monthAndDay setDateFormat:@"MMM. d'rd' '('EEE')'"];
    } else {
        [monthAndDay setDateFormat:@"MMM. d'th' '('EEE')'"];
    }
    
    return [monthAndDay stringFromDate:dateToShow];
}

/* Returns number of rows in a certain section (# of episodes with a certain date) */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDate *date = [self.dates objectAtIndex:section];
    NSArray *epsWithThisDate = [self.tvShowsDict objectForKey:date];
    return [epsWithThisDate count];
}

/* Returns cell that should go at given index path */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *episodeTableIdentifier = @"EpisodeTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:episodeTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:episodeTableIdentifier];
    }
    Episode *ep = [self getEpisodeFromIndexPath:indexPath];
    cell.textLabel.text = ep.show;
    cell.detailTextLabel.text = ep.name;
    return cell;
}

@end
