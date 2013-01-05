//
//  Unit.h
//  Bull Run
//
//  Created by Dave Townsend on 1/5/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Hex.h"

@interface Unit : NSObject

#pragma mark - Read-only Properties

@property (readonly) NSString* name;
@property (readonly) int       originalStrength;

#pragma mark - Modifiable Properties

@property            int       strength;
@property            Hex       location;

- (id)initWithName:(NSString*) name strength:(int) strength location:(Hex)hex;
@end
