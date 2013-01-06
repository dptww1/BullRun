//
//  OrderOfBattle.h
//  Bull Run
//
//  Created by Dave Townsend on 1/5/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Hex.h"

@class Unit;

@interface OrderOfBattle : NSObject

@property (nonatomic, strong) NSArray* units;

- (Unit*)unitInHex:(Hex) hex;

@end
