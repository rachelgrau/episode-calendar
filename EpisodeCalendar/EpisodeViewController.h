/**
 * File: EpisodeViewController.h
 * ------------------------------
 * Simple View Controller that dislpays some details about an episode--its name, 
 * the show it's a part of, and the season it's on.
 */

#import <UIKit/UIKit.h>

@interface EpisodeViewController : UIViewController
@property NSString *name; // Episode name
@property NSString *show; // Show name
@property int season; // Season name
@end
