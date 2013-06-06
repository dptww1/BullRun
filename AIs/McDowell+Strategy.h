//
//  McDowell+Strategy.h
//  Bull Run
//
//  Created by Dave Townsend on 5/22/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BAAIProtocol.h"
#import "BullRun.h"
#import "McDowell.h"
#import "NSArray+DPTUtil.h"


enum UnitRole {
    ROLE_ATTACK,
    ROLE_FLANK,
    ROLE_DEFEND
};


/**
 * McDowell's private properties.
 */
@interface McDowell ()

/** The USA game side. */
@property (nonatomic) PlayerSide side;

/** 
 * The strategic role assigned to each USA unit.
 * key: (NSString)unitName  
 * value: UnitRole enum value
 */
@property (nonatomic, strong) NSMutableDictionary* unitRoles;

@end


/** USA AI Strategic thinking. */
@interface McDowell (Strategy)

/** BAAIProtocol implementation. */
- (void)strategize:(BAGame*)game;

/** BAAIProtocol implementation. */
- (DPTUtilFilter)isUsaUnitDefending;

@end