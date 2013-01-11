//
//  OrderOfBattle.h
//  Bull Run
//
//  Created by Dave Townsend on 1/5/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Hex.h"
#import "BullRun.h"

@class Unit;

@interface OrderOfBattle : NSObject

@property (nonatomic, strong) NSArray* units;

+ (OrderOfBattle*)createFromFile:(NSString*)filepath;

- (BOOL)saveToFile:(NSString*)filename;
- (Unit*)unitInHex:(Hex) hex;
- (NSArray*)unitsForSide:(PlayerSide)side;

@end
