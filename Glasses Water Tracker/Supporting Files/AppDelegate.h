//
//  AppDelegate.h
//  Glasses Water Tracker
//
//  Created by Immanuel Kannan on 24/06/2017.
//  Copyright © 2017 Immanuel Kannan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

