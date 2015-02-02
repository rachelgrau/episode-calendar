/**
 * File: CalendarDayCell.h
 * -------------------------
 * Extension of UICollectionViewCell. This CollectionViewCell has a label on top with a 
 * light gray background around it, and a white table view below that.
 */

#import <UIKit/UIKit.h>

@interface CalendarDayCell : UICollectionViewCell

/**
 * Property: dateLabel
 * ---------------------------------------------
 * Label that goes on the top of Calendar cell.
 */
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;

/**
 * Property: backgroundView
 * ---------------------------------------------
 * Background view of the cell.
 */
@property (strong, nonatomic) IBOutlet UIView *backgroundView;

/**
 * Method: setDateLabelText
 * Usage: [cell setDateLabelText:@"text here"];
 * ----------------------------------------------------------------------
 * Set's this cell's dateLabel text to be |dateString|. In other words, 
 * |dateString| will appear at the top of the cell.
 */
- (void)setDateLabelText:(NSString *)dateString;

/**
 * Method: setTableViewDataSourceDelegate
 * Usage: [cell setTableViewDataSourceDelegate:self index:indexPath.row];
 * ----------------------------------------------------------------------
 * Sets this cell's tableview's data source and delegate to be |dataSourceDelegate|. Also
 * sets the tableview's tag to be |index|. Also reloads the tableview's data.
 */
- (void)setTableViewDataSourceDelegate:(id<UITableViewDataSource, UITableViewDelegate>)dataSourceDelegate index:(NSInteger)index;

/**
 * Method: setTableView
 * Usage: [cell setTableView]
 * ----------------------------------------------------------------------
 * Sets up and displays a table view for this cell, if one wasn't already set up.
 */
- (void)setTableView;
@end
