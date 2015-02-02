//
//  SeasonViewController.m
//  EpisodeCalendar
//
//  Created by Rachel on 2/1/15.
//  Copyright (c) 2015 Rachel. All rights reserved.
//

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

- (Episode *)getEpisodeFromIndexPath:(NSIndexPath *)indexPath {
    return [self.episodes objectAtIndex:indexPath.row];
}

/* Returns cell that should go at given index path */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *episodeTableIdentifier = @"EpisodeSeasonTableCell";
    EpisodeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:episodeTableIdentifier];
    if (cell == nil) {
        cell = [[EpisodeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:episodeTableIdentifier];
    }
    Episode *ep = [self getEpisodeFromIndexPath:indexPath];
    NSString *episodeSeason = [NSString stringWithFormat:@"%dx%d", ep.season, ep.number];
    [cell setUpperLeftLabelText:episodeSeason];
    [cell setLowerLeftLabelText:ep.name];
    [cell setRightLabelText:[EpisodeDateUtility lexicalStringFromDate:ep.airDate]];
    return cell;
}


@end
