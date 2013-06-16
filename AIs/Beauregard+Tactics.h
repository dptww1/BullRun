//
//  Beauregard+Tactics.h
//  Bull Run
//
//  Created by Dave Townsend on 6/16/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import "Beauregard.h"

@class BAAIInfluenceMap;

@interface Beauregard (Tactics)

- (BOOL)assignAttacker;
- (BOOL)assignDefender:(BAAIInfluenceMap*)imap;

@end
