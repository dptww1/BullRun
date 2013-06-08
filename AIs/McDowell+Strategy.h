//
//  McDowell+Strategy.h
//  Bull Run
//
//  Created by Dave Townsend on 5/22/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BAAIProtocol.h"
#import "McDowell.h"
#import "NSArray+DPTUtil.h"


/** USA AI Strategic thinking. */
@interface McDowell (Strategy)

/** BAAIProtocol implementation. */
- (void)strategize:(BAGame*)game;

/** BAAIProtocol implementation. */
- (DPTUtilFilter)isUsaUnitDefending;

@end