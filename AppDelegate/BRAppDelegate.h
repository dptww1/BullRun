//
//  BRAppDelegate.h
//  Bull Run
//
//  Created by Dave Townsend on 12/13/12.
//  Copyright (c) 2012 Dave Townsend. All rights reserved.
//

#import <UIKit/UIKit.h>


@class BR1GameDelegate;
@class MenuController;


/** The Bull Run-specific application delegate. */
@interface BRAppDelegate : UIResponder <UIApplicationDelegate>

/** The application window. */
@property (strong, nonatomic) UIWindow* window;

/** The root navigation control. */
@property (nonatomic, strong) MenuController* menuController;

/** 
 * Convenience accessor for retrieving the global app delegate as the
 * proper type.
 *
 * @return the global instance of the application
 */
+ (BRAppDelegate*)app;

@end

/** Global instance of game delegate. */
extern BR1GameDelegate* BR1gameDelegate;