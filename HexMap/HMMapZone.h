//
//  HMMapZone.h
//  Bull Run
//
//  Created by Dave Townsend on 2/5/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMHex.h"

@interface HMMapZone : NSObject <NSCoding>

// Keys:Column Numbers (as NSNumber)  Values: NSArray of NSRanges
@property (nonatomic, strong) NSDictionary* columns;

// Designated Initializer
- (id)init;

- (BOOL)containsHex:(HMHex)hex;

- (void)addRange:(NSRange)range forColumn:(int)column;

@end
