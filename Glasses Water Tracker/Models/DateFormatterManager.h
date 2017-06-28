//
//  DateFormatterManager.h
//  Glasses Water Tracker
//
//  Created by Immanuel Kannan on 25/06/2017.
//  Copyright © 2017 Immanuel Kannan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateFormatterManager : NSObject

+ (instancetype)sharedManager;

- (NSDateFormatter *)entryDateFormat;
- (NSUInteger)weekNumberForDate: (NSDate *)date;

- (NSDictionary *)firstAndLastDateOfWeekGiven: (NSDate *)date;

@end
