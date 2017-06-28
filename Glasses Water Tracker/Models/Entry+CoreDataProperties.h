//
//  Entry+CoreDataProperties.h
//  Glasses Water Tracker
//
//  Created by Immanuel Kannan on 25/06/2017.
//  Copyright © 2017 Immanuel Kannan. All rights reserved.
//
//

#import "Entry+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Entry (CoreDataProperties)

+ (NSFetchRequest<Entry *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *date;
@property (nullable, nonatomic, copy) NSString *dateString;
@property (nonatomic) NSNumber *numberOfGlasses;

@end

NS_ASSUME_NONNULL_END
