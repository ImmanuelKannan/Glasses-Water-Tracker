//
//  DateManager.m
//  Glasses Water Tracker
//
//  Created by Immanuel Kannan on 28/06/2017.
//  Copyright © 2017 Immanuel Kannan. All rights reserved.
//

#import "DateManager.h"

@interface DateManager ()

@property (nonatomic, strong) NSCalendar *calendar;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation DateManager

#pragma mark - Initializers

+ (instancetype)sharedManager {
    static DateManager *dateManager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        dateManager = [[DateManager alloc] init];
    });
    
    return dateManager;
}

- (instancetype)init {
    if (self = [super init]) {
        self.dateFormatter = [[NSDateFormatter alloc] init];
        self.dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
        [self setupCalendar];
    }
    
    return self;
}

- (void)setupCalendar {
    self.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    self.calendar.firstWeekday = 2;
    self.calendar.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
}

#pragma mark - Date formatting methods

- (NSDateFormatter *)formatterForEntryDate {
    self.dateFormatter.dateFormat = @"yyyy-MM-dd";
    return self.dateFormatter;
}


#pragma mark - Date manipulation methods

- (NSUInteger)weekNumberForDate: (NSDate *)date {
    if (!self.calendar) {
        [self setupCalendar];
    }
    
    NSUInteger currentWeekNumber = [self.calendar component:NSCalendarUnitWeekOfYear fromDate:date];
    
    return currentWeekNumber;
}

- (NSUInteger)yearForDate: (NSDate *)date {
    if (!self.calendar) {
        [self setupCalendar];
    }
    
    NSUInteger currentYearNumber = [self.calendar component:NSCalendarUnitYear fromDate:date];
    return currentYearNumber;
}

- (NSDictionary *)startAndEndOfWeekForDate: (NSDate *)date {
    if (!self.calendar) {
        [self setupCalendar];
    }
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.weekday = self.calendar.firstWeekday;
    dateComponents.weekOfYear = [self weekNumberForDate:date];
    dateComponents.year = [self yearForDate:date];
    
    NSDate *startOfWeek = [self.calendar dateFromComponents:dateComponents];
//    NSDate *endOfWeek = [startOfWeek dateByAddingTimeInterval:24*60*60];
    NSDate *endOfWeek = [self.calendar dateByAddingUnit:NSCalendarUnitDay value:6 toDate:startOfWeek options:0];
    
    NSDictionary *datesDictionary = [NSDictionary dictionaryWithObjects:@[startOfWeek, endOfWeek] forKeys:@[@"startOfWeek", @"endOfWeek"]];
    return datesDictionary;
}

#pragma mark - Unused Methods

/*
- (NSDate *)startOfWeekForDate: (NSDate *)date {
    if (!self.calendar) {
        [self setupCalendar];
    }
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.weekday = self.calendar.firstWeekday;
    dateComponents.weekOfYear = [self weekNumberForDate:date];
    dateComponents.year = [self yearForDate:date];
    
    NSDate *startOfWeek = [self.calendar dateFromComponents:dateComponents];
    return startOfWeek;
}
*/

/*
- (NSDate *)endOfWeekForDate: (NSDate *)date {
    NSDate *startOfWeek = [self startOfWeekForDate:date];
    NSDate *endOfWeek = [startOfWeek dateByAddingTimeInterval:24*60*60];
    
    return endOfWeek;
}
*/

@end

