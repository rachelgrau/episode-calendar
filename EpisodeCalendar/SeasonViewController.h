/**
 * File: SeasonViewController.h
 * ------------------------------
 * View Controller that displays a list of all episodes from the same
 * show and season as |episode|. Also displays |episode| in that list,
 * but highlighted gray.
 * 
 * For each episode, displays its name, season, number, and air date.
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
@end
