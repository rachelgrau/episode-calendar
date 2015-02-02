//
//  SeasonViewController.h
//  EpisodeCalendar
//
//  Created by Rachel on 2/1/15.
//  Copyright (c) 2015 Rachel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Episode.h"

@interface SeasonViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property Episode *episode;
@end
