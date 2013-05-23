//
//  McDowell.m
//  Bull Run
//
//  Created by Dave Townsend on 5/8/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import "McDowell.h"
#import "McDowell+Strategy.h"
#import "BAGame.h"
#import "BAUnit.h"
#import "BRMap.h"
#import "CollectionUtil.h"
#import "HMGeometry.h"
#import "HMHex.h"

@implementation McDowell

- (id)init {
    if (self) {
        _side = USA;

        _unitRoles = [NSMutableDictionary dictionary];
        [_unitRoles setObject:[NSNumber numberWithInt:ROLE_DEFEND] forKey:@"Blenker"];
        [_unitRoles setObject:[NSNumber numberWithInt:ROLE_FLANK]  forKey:@"Burnside"];
        [_unitRoles setObject:[NSNumber numberWithInt:ROLE_DEFEND] forKey:@"Davies"];
        [_unitRoles setObject:[NSNumber numberWithInt:ROLE_FLANK]  forKey:@"Franklin"];
        [_unitRoles setObject:[NSNumber numberWithInt:ROLE_FLANK]  forKey:@"Howard"];
        [_unitRoles setObject:[NSNumber numberWithInt:ROLE_ATTACK] forKey:@"Keyes"];
        [_unitRoles setObject:[NSNumber numberWithInt:ROLE_DEFEND] forKey:@"Militia"];
        [_unitRoles setObject:[NSNumber numberWithInt:ROLE_FLANK]  forKey:@"Porter"];
        [_unitRoles setObject:[NSNumber numberWithInt:ROLE_DEFEND] forKey:@"Richardson"];
        [_unitRoles setObject:[NSNumber numberWithInt:ROLE_ATTACK] forKey:@"Schenck"];
        [_unitRoles setObject:[NSNumber numberWithInt:ROLE_ATTACK] forKey:@"Sherman"];
        [_unitRoles setObject:[NSNumber numberWithInt:ROLE_DEFEND] forKey:@"Volunteers"];
        [_unitRoles setObject:[NSNumber numberWithInt:ROLE_FLANK]  forKey:@"Willcox"];
    }

    return self;
}

- (void)freeSetup:(BAGame*)game { }

- (void)giveOrders:(BAGame*)game {
    [self strategize:game];
}

@end
