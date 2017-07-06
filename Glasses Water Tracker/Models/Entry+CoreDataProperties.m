//
//  Entry+CoreDataProperties.m
//  Glasses Water Tracker
//
//  Created by Immanuel Kannan on 25/06/2017.
//  Copyright © 2017 Immanuel Kannan. All rights reserved.
//
//

#import "Entry+CoreDataProperties.h"

@implementation Entry (CoreDataProperties)

+ (NSFetchRequest<Entry *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Entry"];
}

@dynamic date;
@dynamic dateString;
@dynamic numberOfGlasses;

@end
