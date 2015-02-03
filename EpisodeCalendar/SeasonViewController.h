/**
 * File: SeasonViewController.h
 * ------------------------------
 * View Controller that displays a list of all episodes from the same
 * show and season as |episode|. Also displays |episode| in that list,
 * but highlighted gray.
 * 
 * For each episode, displays its name, season, number, and air date.
 * 
 * Note: You need to pass this view controller a list of all episodes
 * that you want to search from (this list should be returned from 
 * a call to [EpisodeManager fetchAll])
 */

#import <UIKit/UIKit.h>
#import "Episode.h"

@interface SeasonViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
/**
 * Property: episode
 * ------------------------------
 * We will display all the episodes in the season that this episode
 * belongs to. This episode will be highlighted (light gray background).
 */
@property Episode *episode;

/**
 * Property: episodes
 * ------------------------------
 * A list of all episodes we want to search from. This array should come
 * from a call to [EpisodeManager fetchAll].
 */
@property NSArray *episodes;
@end
