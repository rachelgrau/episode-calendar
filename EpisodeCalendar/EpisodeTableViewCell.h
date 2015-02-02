/**
 * File: EpisodeTableViewCell.h
 * -------------------------
 * Subclass of UITableViewCell. Has an upper left label with size 12 
 * font, a lower left label with size 8 font, and those two labels are
 * vertically aligned. It also has a label that's right-aligned and 
 * vertically centered.
 */
#import <UIKit/UIKit.h>

@interface EpisodeTableViewCell : UITableViewCell

/**
 * Method: setUpperLeftLabelText
 * Usage: [cell setUpperLeftLabelText:@"Upper left label text!"];
 * ----------------------------------------------------------------------
 * Sets the upper left label's text to be |text| in size 12 system font.
 */
-(void)setUpperLeftLabelText:(NSString *)text;

/**
 * Method: setLowerLeftLabelText
 * Usage: [cell setLowerLeftLabelText:@"Lower left label text!"];
 * ----------------------------------------------------------------------
 * Sets the lower left label's text to be |text| in size 8 system font.
 */
-(void)setLowerLeftLabelText:(NSString *)text;

/**
 * Method: setRightLabelText
 * Usage: [cell setRightLabelText:@"Right  label text!"];
 * ----------------------------------------------------------------------
 * Sets the right label's text to be |text| in size 12 system font.
 */
-(void)setRightLabelText:(NSString *)text;
@end
