//
//  DateManager.h
//  Glasses Water Tracker
//
//  Created by Immanuel Kannan on 28/06/2017.
//  Copyright © 2017 Immanuel Kannan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateManager : NSObject

+ (instancetype)sharedManager;

- (NSDateFormatter *)formatterForEntryDate;

/**
 @brief Returns the week number of the year for a provided date
 
 @param  date       NSDate of which the week of year will be determined
 @return NSUInteger The week of year of the given date
*/
- (NSUInteger)weekNumberForDate: (NSDate *)date;

- (NSUInteger)yearForDate: (NSDate *)date;

- (NSDictionary *)startAndEndOfWeekForDate: (NSDate *)date;

@end
