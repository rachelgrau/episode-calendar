# episode-calendar
An iOS app to view a calendar of TV shows

TO DO: iphone version
- Only show up to certain future date? (e.g. not 2 months from now)
- Asynchronous loading
- Only show up to certain past date? 
- Make UI prettier (especially on EpisodeViewController)
  - Make text wrap if too long

TO DO: ipad version
- If on portrait mode: show something below calendar
  - Shows for selected day?
- Extend NSDate and add all date related functions there
  - Some in Episode.h
  - Some in EpisodeCalendarVC
- Fetch all shows once at beginning and store them in a dictionary based on date
- Make text wrap
- What to do if many shows on 1 day and need to scroll?
- Add checkbox for if watched
- Fix border gray around bottom and right of calendar
