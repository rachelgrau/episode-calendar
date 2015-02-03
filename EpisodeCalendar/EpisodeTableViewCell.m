/**
 * File: EpisodeTableViewCell.m
 * ------------------------------
 * Implementation of EpisodeTableViewCell.
 */
#import "EpisodeTableViewCell.h"

@interface EpisodeTableViewCell()
@property (strong, nonatomic) IBOutlet UILabel *upperLeftLabel;
@property (strong, nonatomic) IBOutlet UILabel *lowerLeftLabel;
@property (strong, nonatomic) IBOutlet UILabel *rightLabel;

@end

@implementation EpisodeTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)awakeFromNib
{
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

/* Set upper left label and font */
-(void)setUpperLeftLabelText:(NSString *)text
{
    self.upperLeftLabel.text = text;
    self.upperLeftLabel.font = [UIFont systemFontOfSize:12];
}

/* Set lower left label and font */
-(void)setLowerLeftLabelText:(NSString *)text
{
    self.lowerLeftLabel.text = text;
    self.lowerLeftLabel.font = [UIFont systemFontOfSize:8];
}

/* Set right label and font */
-(void)setRightLabelText:(NSString *)text
{
    self.rightLabel.text = text;
    self.rightLabel.font = [UIFont systemFontOfSize:12];
    [self.rightLabel sizeToFit];
}

@end
