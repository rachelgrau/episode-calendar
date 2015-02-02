/**
 * File: EpisodeCalendarViewController.h
 * -------------------------------------
 * View Controller for the ipad Episode Calendar. Displays a month view of a 
 * calendar with a list of which shows are playing each day.
 */

#import <UIKit/UIKit.h>

@interface EpisodeCalendarViewController : UIViewController
/**
 * Property: dateToDisplay
 * -------------------------------------
 * An NSDate. The only part that matters is its month, because 
 * that is the month we will display.
 */
@property NSDate *dateToDisplay;
@end
