//
//  CalendarDayCell.h
//  EpisodeCalendar
//
//  Created by Rachel on 1/28/15.
//  Copyright (c) 2015 Rachel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarDayCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UIView *backgroundView;
@property NSMutableArray *shows;

- (void)setDateLabelText:(NSString *)dateString;
- (void)setTableViewDataSourceDelegate:(id<UITableViewDataSource, UITableViewDelegate>)dataSourceDelegate index:(NSInteger)index;
- (void)setTableView;
@end
