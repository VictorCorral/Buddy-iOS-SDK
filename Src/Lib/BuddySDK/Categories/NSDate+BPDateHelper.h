#import <Foundation/Foundation.h>

@interface NSDate (BPDateHelper)

#define D_MINUTE	60
#define D_HOUR		3600
#define D_DAY		86400
#define D_WEEK		604800
#define D_YEAR		31556926


// Relative dates from the current date
+ (NSDate *) bp_dateTomorrow;
+ (NSDate *) bp_dateYesterday;
+ (NSDate *) bp_dateWithDaysFromNow: (NSInteger) days;
+ (NSDate *) bp_dateWithDaysBeforeNow: (NSInteger) days;
+ (NSDate *) bp_dateWithHoursFromNow: (NSInteger) dHours;
+ (NSDate *) bp_dateWithHoursBeforeNow: (NSInteger) dHours;
+ (NSDate *) bp_dateWithMinutesFromNow: (NSInteger) dMinutes;
+ (NSDate *) bp_dateWithMinutesBeforeNow: (NSInteger) dMinutes;

// Comparing dates
- (BOOL) bp_isEqualToDateIgnoringTime: (NSDate *) aDate;
- (BOOL) bp_isToday;
- (BOOL) bp_isTomorrow;
- (BOOL) bp_isYesterday;
- (BOOL) bp_isSameWeekAsDate: (NSDate *) aDate;
- (BOOL) bp_isThisWeek;
- (BOOL) bp_isNextWeek;
- (BOOL) bp_isLastWeek;
- (BOOL) bp_isSameMonthAsDate: (NSDate *) aDate;
- (BOOL) bp_isThisMonth;
- (BOOL) bp_isSameYearAsDate: (NSDate *) aDate;
- (BOOL) bp_isThisYear;
- (BOOL) bp_isNextYear;
- (BOOL) bp_isLastYear;
- (BOOL) bp_isEarlierThanDate: (NSDate *) aDate;
- (BOOL) bp_isLaterThanDate: (NSDate *) aDate;
- (BOOL) bp_isInFuture;
- (BOOL) bp_isInPast;

// Date roles
- (BOOL) bp_isTypicallyWorkday;
- (BOOL) bp_isTypicallyWeekend;

// Adjusting dates
- (NSDate *) bp_dateByAddingDays: (NSInteger) dDays;
- (NSDate *) bp_dateBySubtractingDays: (NSInteger) dDays;
- (NSDate *) bp_dateByAddingHours: (NSInteger) dHours;
- (NSDate *) bp_dateBySubtractingHours: (NSInteger) dHours;
- (NSDate *) bp_dateByAddingMinutes: (NSInteger) dMinutes;
- (NSDate *) bp_dateBySubtractingMinutes: (NSInteger) dMinutes;
- (NSDate *) bp_dateAtStartOfDay;

// Retrieving intervals
- (NSInteger) bp_minutesAfterDate: (NSDate *) aDate;
- (NSInteger) bp_minutesBeforeDate: (NSDate *) aDate;
- (NSInteger) bp_hoursAfterDate: (NSDate *) aDate;
- (NSInteger) bp_hoursBeforeDate: (NSDate *) aDate;
- (NSInteger) bp_daysAfterDate: (NSDate *) aDate;
- (NSInteger) bp_daysBeforeDate: (NSDate *) aDate;
- (NSInteger) bp_distanceInDaysToDate:(NSDate *)anotherDate;

// Decomposing dates
@property (readonly) NSInteger bp_nearestHour;
@property (readonly) NSInteger bp_hour;
@property (readonly) NSInteger bp_minute;
@property (readonly) NSInteger bp_seconds;
@property (readonly) NSInteger bp_day;
@property (readonly) NSInteger bp_month;
@property (readonly) NSInteger bp_week;
@property (readonly) NSInteger bp_weekday;
@property (readonly) NSInteger bp_nthWeekday; // e.g. 2nd Tuesday of the month == 2
@property (readonly) NSInteger bp_year;

@end
