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
    
    // Do any additional setup after loading the view.
}

/* Datasource method */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.dates count];
}

/* Datasource method, returns the title of the section (date in string form) */
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

/* Datasource method */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDate *date = [self.dates objectAtIndex:section];
    NSArray *epsWithThisDate = [self.tvShowsDict objectForKey:date];
    return [epsWithThisDate count];
}

- (Episode *) getEpisodeFromIndexPath:(NSIndexPath *)indexPath {
    NSDate *date = [self.dates objectAtIndex:[indexPath section]];
    NSArray *epsInSection = [self.tvShowsDict objectForKey:date];
    return [epsInSection objectAtIndex:[indexPath row]];
}

/* Datasource method */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *episodeTableIdentifier = @"EpisodeTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:episodeTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:episodeTableIdentifier];
    }
    
    Episode *ep = [self getEpisodeFromIndexPath:indexPath];
    cell.textLabel.text = ep.show;
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Episode *ep = [self getEpisodeFromIndexPath:indexPath];
    [self performSegueWithIdentifier:@"toEpisodeDetail" sender:ep];
}

 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
     if ([segue.identifier isEqualToString:@"toEpisodeDetail"]) {
         EpisodeViewController *destViewController = segue.destinationViewController;
         Episode *ep = sender;
         destViewController.name = ep.name;
         destViewController.show = ep.show;
     }
 }
 

@end
