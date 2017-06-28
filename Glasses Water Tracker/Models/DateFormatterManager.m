//
//  DateFormatterManager.m
//  Glasses Water Tracker
//
//  Created by Immanuel Kannan on 25/06/2017.
//  Copyright © 2017 Immanuel Kannan. All rights reserved.
//

#import "DateFormatterManager.h"

@interface DateFormatterManager ()

@property (nonatomic, strong) NSDateFormatter *formatter;

@end

@implementation DateFormatterManager

+ (instancetype)sharedManager {
    static DateFormatterManager *dateFormatterManager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        dateFormatterManager = [[self alloc] init];
    });
    
    return dateFormatterManager;
}

- (instancetype)init {
    if (self = [super init]) {
        self.formatter = [[NSDateFormatter alloc] init];
    }
    
    return self;
}

- (NSDateFormatter *)entryDateFormat {
    self.formatter.dateFormat = @"yyyy-MM-dd";
    
    return self.formatter;
}

- (NSUInteger)weekNumberForDate: (NSDate *)date {
//    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [calendar setFirstWeekday:2];
//    NSInteger *weekNumber = [calendar component:(NSWeekOfYearCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:date];
//    NSDateComponents *dateComponents = [calendar components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekOfYear) fromDate:date];
//    NSUInteger weekOfYear = [calendar components:NSCalendarUnitWeekOfYear fromDate:date];
    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitWeekOfYear fromDate:date];
    NSUInteger weekOfYear = dateComponents.weekOfYear;
//    NSUInteger integers = dateComponents.weekOfYear;
    
    return weekOfYear;
}

- (NSUInteger)currentNumberOfWeek: (NSDate *)date {
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    gregorian.firstWeekday = 2;
    
    NSUInteger currentWeekNumber = [gregorian component:NSCalendarUnitWeekOfYear fromDate:date];
    
    return currentWeekNumber;
    
}

- (NSUInteger)currentYear: (NSDate *)date {
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSUInteger currentYear = [gregorian component:NSCalendarUnitYear fromDate:date];
    return currentYear;
    
}

- (NSDictionary *)firstAndLastDateOfWeekGiven: (NSDate *)date {
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    gregorian.firstWeekday = 2;
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.weekday = gregorian.firstWeekday;
    components.weekOfYear = [self currentNumberOfWeek:date];
    components.year = [self currentYear:date];
    
    NSDate *startOfWeek = [gregorian dateFromComponents:components];
    NSDate *endOfWeek = [gregorian dateByAddingUnit:NSCalendarUnitDay value:6 toDate:startOfWeek options:0];
    
    NSDictionary *datesDictionary = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:startOfWeek, endOfWeek, nil] forKeys:[NSArray arrayWithObjects:@"startDate", @"endDate", nil]];
    
    return datesDictionary;
//
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    formatter.dateFormat = @"yyyy-MM-dd";
//
//    NSLog(@"Start of Week: %@", startOfWeek);
//    NSLog(@"End of Week: %@", endOfWeek);
    
}

@end
