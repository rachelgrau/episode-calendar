/**
 * File: EpisodeListViewController.h
 * ---------------------------------
 * Implementation of the view controller for the iphone Episode Calendar. 
 * Uses a table view to display "sections" (dates). Each section/date
 * has a list of episodes that occur on that date. So, this view controller
 * serves as the data source and delegate for that table view. When you click
 * on a cell, it transitions to another view controller that displays some
 * details about the show.
 *
 * Design: store a dictionary where keys = dates and values = a list
 * of episodes that occur on that date. Also store an array of all the 
 * dates that have episodes, and keep it in order. This way, in the table
 * view callbacks, we can use the index of a cell to figure out which date
 * goes there. Then, we can pass that date into the dictionary as a key 
 * and retrieve all the episodes for that date.
 */

#import "EpisodeListViewController.h"
#import "Episode.h"
#import "EpisodeManager.h"
#import "EpisodeViewController.h"
#import "EpisodeDateUtility.h"

@interface EpisodeListViewController ()
@property NSDictionary *tvShowsDict; // Dictionary where keys = date strings and values = array of episodes on that date
@property NSMutableArray *dates; // List of dates that have episodes, in chronological order (newest - oldest)
@property (strong, nonatomic) IBOutlet UITableView *tableView; // Table view that displays shows
@property UINavigationController *nvc; // Navigation view controller
@end

@implementation EpisodeListViewController

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
    /* Fetch episodes and dates */
    self.dates = [[NSMutableArray alloc] init];
    self.tvShowsDict = [EpisodeManager fetchAllByDate:self.dates];
    self.nvc = [self navigationController];
}

- (void) viewDidAppear:(BOOL)animated {
    /* Make table view cell stop looking like it was selected */
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

/* Given an NSIndexPath for our table view, return the Episode that
    should go at that index path in the table. */
- (Episode *) getEpisodeFromIndexPath:(NSIndexPath *)indexPath {
    /* Get the date for this index. */
    NSDate *date = [self.dates objectAtIndex:[indexPath section]];
    /* Get all of the episodes for this date. */
    NSArray *epsInSection = [self.tvShowsDict objectForKey:date];
    /* Return the |indexPath.row|th episode  */
    return [epsInSection objectAtIndex:indexPath.row];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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

/* Returns the title of the section (date in string form, e.g. "Jan. 2nd") */
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDate *dateToShow = [self.dates objectAtIndex:section];
    return [EpisodeDateUtility lexicalStringFromDate:dateToShow];
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
