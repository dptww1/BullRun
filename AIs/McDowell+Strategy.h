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
#import "CollectionUtil.h"
#import "McDowell.h"


enum UnitRole {
    ROLE_ATTACK,
    ROLE_FLANK,
    ROLE_DEFEND
};


@interface McDowell ()

@property (nonatomic) PlayerSide side;

// key: (NSString)unitName  value: UnitRole enum value
@property (nonatomic, strong) NSMutableDictionary* unitRoles;

@end


@interface McDowell (Strategy)

- (void)strategize:(BAGame*)game;
- (CUFilter)isUsaUnitDefending;

@end