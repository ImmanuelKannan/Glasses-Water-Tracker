//
//  Entry+CoreDataClass.m
//  Glasses Water Tracker
//
//  Created by Immanuel Kannan on 25/06/2017.
//  Copyright © 2017 Immanuel Kannan. All rights reserved.
//
//

#import "Entry+CoreDataClass.h"

@implementation Entry

- (NSString *)description {
    return [NSString stringWithFormat:@"DateString: %@, Date: %@, Number of Glasses: %@", self.dateString, self.date, self.numberOfGlasses];
}

@end
