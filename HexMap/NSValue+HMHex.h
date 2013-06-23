//
//  NSValue+HMHex.h
//  Bull Run
//
//  Created by Dave Townsend on 5/29/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMHex.h"

@interface NSValue (HMHex)

+ (id)valueWithHex:(HMHex)hex;
- (HMHex)hexValue;

@end
