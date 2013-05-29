//
//  McDowell+Tactics.h
//  Bull Run
//
//  Created by Dave Townsend on 5/25/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import "McDowell.h"

@class BAAIInfluenceMap;

@interface McDowell (Tactics)

- (BOOL)assignAttacker;
- (BOOL)assignDefender:(BAAIInfluenceMap*)imap;
- (BOOL)assignFlanker;
- (BOOL)reRoute;

@end
