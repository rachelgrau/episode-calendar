//
//  EpisodeViewController.m
//  EpisodeCalendar
//
//  Created by Rachel on 23/01/2015.
//  Copyright (c) 2015 Rachel. All rights reserved.
//

#import "EpisodeViewController.h"
#import "Episode.h"

@interface EpisodeViewController ()
@property NSArray *tvShows;
@property NSDictionary *tvShowsDict;
@property NSMutableArray *dates;
@end

@implementation EpisodeViewController

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

/* Datasource method */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *episodeTableIdentifier = @"EpisodeTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:episodeTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:episodeTableIdentifier];
    }
    
    NSDate *date = [self.dates objectAtIndex:[indexPath section]];
    NSArray *epsInSection = [self.tvShowsDict objectForKey:date];
    Episode *ep = [epsInSection objectAtIndex:[indexPath row]];
    cell.textLabel.text = ep.show;
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
