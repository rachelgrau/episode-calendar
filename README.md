# episode-calendar
An iOS app to display a schedule of TV episodes. 

The iPhone version of this app displays a list of TV shows on each day, from newest to oldest.

The iPad version displays the same data but in a calendar month view instead of a list.

When you select an epsidode, you can view a list of all the episodes from the season that the selected episode was in.

Implementation: 

Model:
- <b>Episode</b>: this class represents an Episode object. It stores the episode's name, air date, season, show, number, and whether or not it was watched. 
- <b>EpisodeManager</b>: this class handles loading episodes. The idea is that you call fetchAll once, which returns an array of episode objects, and then you can pass this array into other EpisodeManager functions that filter the episodes and give you just the ones you want (like getting all the episodes between two dates, or getting episodes from a certain show and season).

iPhone:
- <b>EpisodeListViewController</b>: on the iPhone, the first thing you'll see is a list of all the episodes, displayed by this view controller. It uses a table view where each section is a date and each cell within a certain section is an episode that occurs on that date. 

iPad:
- <b>EpisodeCalendarViewController</b> On the iPad, the first thing you'll see is a month view of a calendar--this is displayed by the EpisodeCalendarViewController. It uses a collection view where each collection view cell (CalendarDayCell) represents a day in that month. Since each day has to display a list of episodes that occur on that day, the CalendarDayCell has a table view whose delegate & data source are this class (EpisodeCalendarViewController). We tag each tableview with its index in the collection view so that we can figure out what date it should display episodes for in the delegate & data source callbacks. 
- <b>CalendarDayCell</b> This cell has a label on top that we use to display the date, and a table view that we use to display a list of all episodes on that date.

Both iPad & iPhone:
- <b>SeasonViewController</b>: when you click on a cell in either the EpisodeListViewController or EpisodeCalendarViewController, it takes you to this view controller, which shows you a list of all the episodes from the show & season that the episode you selected was in. Uses a table view as well.
