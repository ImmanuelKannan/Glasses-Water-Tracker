//
//  EntryManager.m
//  Glasses Water Tracker
//
//  Created by Immanuel Kannan on 24/06/2017.
//  Copyright © 2017 Immanuel Kannan. All rights reserved.
//

#import "EntryManager.h"
#import "Entry+CoreDataClass.h"
#include "DateManager.h"
#include "Constants.h"

@interface EntryManager ()

@property (nonatomic, strong) DateManager *dateManager;

@end

@implementation EntryManager

#pragma mark - Initializers

+ (instancetype)sharedManager {
    static EntryManager *entryManager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        entryManager = [[self alloc] init];
    });
    
    return entryManager;
}

- (instancetype)init {
    if (self = [super init]) {
        self.dateManager = [DateManager sharedManager];
    }
    
    return self;
}

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    _managedObjectContext = managedObjectContext;
    
    if (self.managedObjectContext) {
        NSLog(@"EntryManager, -(setManagedObjectContext:): self.managedObjectContext was successfully set!");
        
        NSDateFormatter *dateFormatter = [self.dateManager formatterForEntryDate];
        NSDate *today = [NSDate date];
        
        NSDictionary *datesDictionary = [self.dateManager startAndEndOfWeekForDate:today];
        NSDate *startOfWeek = [datesDictionary objectForKey:@"startOfWeek"];
        NSDate *endOfWeek = [datesDictionary objectForKey:@"endOfWeek"];
        
        if (!(self.entryForToday = [self entryForDateString:[dateFormatter stringFromDate:today]])) {
            
            for (NSDate *date = [startOfWeek copy]; [date compare:endOfWeek] <= 0; date = [date dateByAddingTimeInterval:24*60*60]) {
                [self createEntryForDateString:[dateFormatter stringFromDate:date]];
            }
            
            self.entryForToday = [self entryForDateString:[dateFormatter stringFromDate:today]];
            self.entryCurrentlySelected = self.entryForToday;
            self.entriesForCurrentWeek = [self entriesForWeekWithStartDate:startOfWeek endDate:endOfWeek];
        }
        
        else {
            self.entryForToday = [self entryForDateString:[dateFormatter stringFromDate:today]];
            self.entryCurrentlySelected = self.entryForToday;
            self.entriesForCurrentWeek = [self entriesForWeekWithStartDate:startOfWeek endDate:endOfWeek];
        }
    }
    
    else {
        NSLog(@"EntryManager, -(setManagedObjectContext:): self.managedObjectContext was not set!");
    }
}

#pragma mark - Entry retrieval methods

- (Entry *)entryForDateString: (NSString *)dateString {
    /* Checks if an entry already exists in Core Data for the passed-in date */
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"dateString == %@", dateString];
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Entry"];
    fetchRequest.predicate = predicate;
    
    NSError *error = nil;
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (array.count == 1) {
        NSLog(@"EntryManager, -(entryForDate:): Entry with date %@ found in Core Data", dateString);
        return [array firstObject];
    }
    
    else {
        NSLog(@"EntryManager, -(entryForDate:): Entry with date %@ not found in Core Data", dateString);
        return nil;
    }
    
}

- (NSArray *)entriesForWeekWithStartDate: (NSDate *)startDate endDate: (NSDate *)endDate {
    
    NSPredicate *weekPredicate = [NSPredicate predicateWithFormat:@"((date >= %@) AND (date <= %@)) || (date = nil)", startDate, endDate];
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:kEntryEntityName];
    fetchRequest.predicate = weekPredicate;
    
    NSError *error = nil;
    NSArray *daysArray = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (daysArray.count != 0) {
        NSLog(@"EntryManager, -(entriesForWeekWithStartDate:endDate:): Week exists in Core Data");
        NSLog(@"%@", startDate);
        NSLog(@"%@", endDate);
        for (Entry *entry in daysArray) {
            NSLog(@"EntryManager, -(entriesForWeekWithStartDate:endDate:): %@", entry.description);
        }
        
        return daysArray;
    }
    
    else {
        NSLog(@"EntryManager, -(entriesForWeekWithStartDate:endDate:): Week doesn't exist in Core Data");
        
        return nil;
    }
    
}

#pragma mark - Entry creation methods

- (void)createEntryForDateString: (NSString *)dateString {
    
//    NSDateFormatter *entryDateFormat = [self.dateFormatterManager entryDateFormat];
    NSDateFormatter *entryDateFormatter = [self.dateManager formatterForEntryDate];
    
    Entry *entry = [NSEntityDescription insertNewObjectForEntityForName:@"Entry" inManagedObjectContext:self.managedObjectContext];
    [entry setValue:dateString forKey:@"dateString"];
//    [entry setValue:[entryDateFormat dateFromString:dateString] forKey:@"date"];
    [entry setValue:[entryDateFormatter dateFromString:dateString] forKey:@"date"];
    [entry setValue:[NSNumber numberWithInt:0] forKey:@"numberOfGlasses"];
    
    NSLog(@"EntryManager, -(createEntryForDate:): Created Entry %@", entry.description);
}


#pragma mark - Entry manipulation methods

#pragma mark - Unused methods

//- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
//
//    _managedObjectContext = managedObjectContext;
//
//    if (self.managedObjectContext) {
//        NSLog(@"EntryManager, -(setManagedObjectContext:): Context was successfully set");
//        NSDateFormatter *entryDateFormat = [self.dateFormatter entryDateFormat];
//
//        if (!(self.todayEntry = [self entryForDate:[entryDateFormat stringFromDate:[NSDate date]]])) {
//            NSLog(@"EntryManager, -(setManagedObjectContext:): Entry for today does not exist and will need to be created");
//            [self createEntryForDate:[entryDateFormat stringFromDate:[NSDate date]]];
//            self.todayEntry = [self entryForDate:[entryDateFormat stringFromDate:[NSDate date]]];
//            self.currentlySelectedEntry = self.todayEntry;
//        }
//
//        else {
//            NSLog(@"EntryManager, -(setManagedObjectContext:): Entry for today already exists");
//            self.currentlySelectedEntry = self.todayEntry;
//        }
//
//        self.currentWeekNumber = (long)[self.dateFormatter weekNumberForDate:[NSDate date]];
//        NSLog(@"%ld", self.currentWeekNumber);
//
//        NSUInteger December = (long)[self.dateFormatter weekNumberForDate:[entryDateFormat dateFromString:@"2016-12-27"]];
//        NSLog(@"THIS IS DECEMBER %ld", December);
//
//        [self entriesForCurrentWeekNumber:1];
//    }
//
//}

//- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
//    _managedObjectContext = managedObjectContext;
//
//    if (self.managedObjectContext) {
//        NSLog(@"EntryManager, -(setManagedObjectContext:): Context was successfully set");
//        NSDateFormatter *entryDateFormat = self.dateFormatterManager.entryDateFormat;
//
//        Entry *entry = [self entryForDate:[entryDateFormat stringFromDate:[NSDate date]]];
//        if (entry) {
//
//        }
//
//        NSString *dateString = @"2016-12-14";
//        NSDate *date = [[self.dateFormatterManager entryDateFormat] dateFromString:dateString];
//
//        [self.dateFormatterManager firstAndLastDateOfWeekGiven:date];
//        NSArray *array = [self entriesFromCurrentWeek];
//        for (Entry *entry in array) {
//            NSLog(@"%@", entry.description);
//        }
//    }
//}

//- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
//    _managedObjectContext = managedObjectContext;
//
//    if (self.managedObjectContext) {
//        NSLog(@"EntryManager, -(setManagedObjectContext:): Context was successfully set");
//        NSDateFormatter *entryDateFormat = [self.dateFormatterManager entryDateFormat];
//        NSDate *today = [NSDate date];
//        if (!(self.todayEntry = [self entryForDate:[entryDateFormat stringFromDate:today]])) {
//            NSDictionary *datesDictionary = [self.dateFormatterManager firstAndLastDateOfWeekGiven:[NSDate date]];
//            NSDate *startDate = [datesDictionary objectForKey:@"startDate"];
//            NSDate *endDate = [datesDictionary objectForKey:@"endDate"];
//
//            NSLog(@"Start Date: %@", startDate);
//            NSLog(@"End Date: %@", endDate);
//
//            for (NSDate *date = [startDate copy]; [date compare:endDate] <= 0; date = [date dateByAddingTimeInterval:24*60*60]) {
//                [self createEntryForDate:[entryDateFormat stringFromDate:date]];
//            }
//
//            self.todayEntry = [self entryForDate:[entryDateFormat stringFromDate:today]];
//            self.currentlySelectedEntry = self.todayEntry;
//
//
//        }
//
//        else {
//
//            NSSortDescriptor *dateDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES selector:@selector(localizedStandardCompare:)];
////            NSArray *sortDescriptors = [NSArray arrayWithObject:dateDescriptor];
//
////            self.currentWeekEntries = [[self currentWeekEntries] sortedArrayUsingDescriptors:@[dateDescriptor]];
//
//            self.currentWeekEntries = [self entriesFromCurrentWeek];
//
//            for (Entry *entry in self.currentWeekEntries) {
//                NSLog(@"shit%@", entry.description);
//            }
//        }
//    }
//}









//- (NSArray *)entriesFromCurrentWeek {
//
//    NSDate *today = [NSDate date];
////    [self.dateFormatterManager firstAndLastDateOfWeekGiven:today];
//    NSDictionary *datesDictionary = [self.dateFormatterManager firstAndLastDateOfWeekGiven:today];
//
//    NSPredicate *weekPredicate = [NSPredicate predicateWithFormat:@"((date >= %@) AND (date <= %@)) || (date = nil)", [datesDictionary objectForKey:@"startDate"], [datesDictionary objectForKey:@"endDate"]];
//    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:kEntryEntityName];
//    fetchRequest.predicate = weekPredicate;
//
//    NSError *error = nil;
//    NSArray *daysArray = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
//    if ([daysArray containsObject:[Entry class]]) {
//        NSLog(@"WEEK EXISTS, HERE THEY ARE!");
//
//        for (Entry *entry in daysArray) {
//            NSLog(@"piss %@", entry.description);
//        }
//    }
//
//    else {
//        NSLog(@"WEEK DOES NOT EXIST");
//    }
//
//    return daysArray;
//
//}

//- (NSArray *)entriesFromCurrentWeek {
//    NSArray *currentWeekEntriesArray;
//
//    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
//    [gregorian setFirstWeekday:2];
//
//    NSDateComponents *components = [gregorian components:(NSCalendarUnitYear | NSCalendarUnitWeekOfYear) fromDate:[NSDate date]];
//    NSUInteger currentWeekNumber = components.weekOfYear;
//}

//- (void)entriesForCurrentWeekNumber: (NSUInteger)weekNumber {
//    NSDateFormatter *entryDateFormatter = [self.dateFormatterManager entryDateFormat];
//    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
//    [gregorian setFirstWeekday:2];
//    NSDateComponents *components = [gregorian components:NSCalendarUnitYear fromDate:[NSDate date]];
//    [components setWeekOfYear:weekNumber];
//    [components setWeekday:2];
//
//    NSDate *firstDateOfWeek = [gregorian dateFromComponents:components];
//    NSLog(@"FIRST DATE OF WEEK %ld: %@", weekNumber, firstDateOfWeek);
//
//    NSDateComponents *components2 = [gregorian components:NSCalendarUnitWeekday fromDate:[entryDateFormatter dateFromString:@"2017-08-24"]];
//    NSUInteger weekday = components2.weekday;
//    NSLog(@"current week day number: %ld", (long)weekday);
//
//}

//- (NSUInteger)currentNumberOfWeek: (NSDate *)date {
//
//    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
//    gregorian.firstWeekday = 2;
//
//    NSUInteger currentWeekNumber = [gregorian component:NSCalendarUnitWeekOfYear fromDate:date];
//
//    return currentWeekNumber;
//
//
//}

//- (NSUInteger)currentYear: (NSDate *)date {
//
//    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
//    gregorian.firstWeekday = 2;
//
//    NSUInteger currentYearNumber = [gregorian component:NSCalendarUnitYear fromDate:date];
//    return currentYearNumber;
//
//}
//
//- (NSDictionary *)firstAndLastDayOfWeek: (NSDate *)date {
//    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
//    gregorian.firstWeekday = 2;
//
//    NSDateComponents *components = [[NSDateComponents alloc] init];
//    components.weekday = gregorian.firstWeekday;
//    components.weekOfYear = [self currentNumberOfWeek:date];
//    components.year = [self currentYear:date];
//
//    NSDate *startOfWeek = [gregorian dateFromComponents:components];
//    NSDate *endOfWeek = [gregorian dateByAddingUnit:NSCalendarUnitDay value:6 toDate:startOfWeek options:0];
//
//    NSDictionary *dictionary = [[NSDictionary alloc] initWithObjects:@[startOfWeek, endOfWeek] forKeys:@[@"start", @"end"]];
//    return dictionary;
//}

@end
