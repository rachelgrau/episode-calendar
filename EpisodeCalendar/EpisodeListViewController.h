/**
 * File: EpisodeListViewController.h
 * ---------------------------------
 * View Controller for the iphone Episode Calendar. Displays a list view of 
 * dates (in chronological order from newest to oldest) along with which
 * episodes are playing on each date.
 */

#import <UIKit/UIKit.h>

@interface EpisodeListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@end
