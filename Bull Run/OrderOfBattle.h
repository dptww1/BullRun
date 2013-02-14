//
//  OrderOfBattle.h
//  Bull Run
//
//  Created by Dave Townsend on 1/5/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BullRun.h"
#import "HMHex.h"

@class Unit;

@interface OrderOfBattle : NSObject

@property (nonatomic, strong) NSArray* units;

+ (OrderOfBattle*)createFromFile:(NSString*)filepath;

- (BOOL)saveToFile:(NSString*)filename;
- (Unit*)unitInHex:(HMHex) hex;
- (NSArray*)unitsForSide:(PlayerSide)side;

@end
