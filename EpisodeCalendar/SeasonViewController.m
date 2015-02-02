/**
 * File: SeasonViewController.m
 * ------------------------------
 * Implementation of Season View Controller. This view controller is the 
 * delegate and data source for its table view, where it displays the list
 * of all episodes in the same show/season as |episode|.
 */

#import "SeasonViewController.h"
#import "EpisodeManager.h"
#import "EpisodeTableViewCell.h"
#import "EpisodeDateUtility.h"

@interface SeasonViewController ()
@property (strong, nonatomic) IBOutlet UILabel *showLabel;
@property (strong, nonatomic) IBOutlet UILabel *seasonLabel;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property NSArray *episodes;
@end

@implementation SeasonViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.seasonLabel.text = [NSString stringWithFormat:@"Season %d", self.episode.season];
    self.seasonLabel.font = [UIFont systemFontOfSize:16];
    self.showLabel.text = self.episode.show;
    self.showLabel.font = [UIFont boldSystemFontOfSize:18];
    self.episodes = [EpisodeManager fetchEpisodesFromShow:self.episode.show season:self.episode.season];
    self.tableView.allowsSelection = NO;
    self.tableView.separatorColor = [UIColor groupTableViewBackgroundColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Datasource

/* Returns # of sections in the table view (number of dates) */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

/* Returns number of rows in a certain section (# of episodes with a certain date) */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.episodes.count;
}

/* Returns cell that should go at given index path */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *episodeTableIdentifier = @"EpisodeSeasonTableCell";
    EpisodeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:episodeTableIdentifier];
    if (cell == nil) {
        cell = [[EpisodeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:episodeTableIdentifier];
    }
    Episode *ep = [self.episodes objectAtIndex:indexPath.row];
    if (ep.number == self.episode.number) {
        cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
    } else {
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    NSString *episodeSeason = [NSString stringWithFormat:@"%dx%d", ep.season, ep.number];
    [cell setUpperLeftLabelText:episodeSeason];
    [cell setLowerLeftLabelText:ep.name];
    [cell setRightLabelText:[EpisodeDateUtility lexicalStringFromDate:ep.airDate]];
    return cell;
}


@end
