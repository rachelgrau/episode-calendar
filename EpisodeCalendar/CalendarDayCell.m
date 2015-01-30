//
//  CalendarDayCell.m
//  EpisodeCalendar
//
//  Created by Rachel on 1/28/15.
//  Copyright (c) 2015 Rachel. All rights reserved.
//

#import "CalendarDayCell.h"

@implementation CalendarDayCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setDateLabelText:(NSString *)dateString
{
    self.dateLabel.text = dateString;
    self.dateLabel.font = [UIFont systemFontOfSize:12];
}

@end
