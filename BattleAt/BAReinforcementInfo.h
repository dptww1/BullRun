//
//  BAReinforcementInfo.h
//  Bull Run
//
//  Created by Dave Townsend on 2/20/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMHex.h"

@class Unit;

@interface BAReinforcementInfo : NSObject <NSCoding>

@property (nonatomic, readonly) NSString* unitName;
@property (nonatomic)           HMHex     entryLocation;
@property (nonatomic)           int       entryTurn;

+ (BAReinforcementInfo*)createWithUnit:(Unit*)unit onTurn:(int)turn atHex:(HMHex)hex;

- (BAReinforcementInfo*)initWithUnit:(Unit*)unit onTurn:(int)turn atHex:(HMHex)hex;

@end
