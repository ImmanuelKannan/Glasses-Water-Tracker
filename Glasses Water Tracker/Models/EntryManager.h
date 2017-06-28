//
//  EntryManager.h
//  Glasses Water Tracker
//
//  Created by Immanuel Kannan on 24/06/2017.
//  Copyright © 2017 Immanuel Kannan. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreData;
@class Entry;

@interface EntryManager : NSObject

@property (nonatomic, weak) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, strong) Entry *entryForToday;
@property (nonatomic, strong) Entry *entryCurrentlySelected;
@property (nonatomic, strong) NSArray *entriesForCurrentWeek;

+ (instancetype)sharedManager;

@end
