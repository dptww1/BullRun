//
//  BAReinforcementInfo.h
//  Bull Run
//
//  Created by Dave Townsend on 2/20/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMHex.h"

@interface BAReinforcementInfo : NSObject <NSCoding>

@property (nonatomic, readonly) NSString* unitName;
@property (nonatomic)           HMHex     entryLocation;
@property (nonatomic)           int       entryTurn;

@end
