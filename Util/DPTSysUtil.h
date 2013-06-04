//
//  DPTSysUtil.h
//  Bull Run
//
//  Created by Dave Townsend on 1/7/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import <Foundation/Foundation.h>

/** Common conversion.  Humans like degrees, iOS prefers radians. */
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

/**
 * iOS-specific system utilities.
 */
@interface DPTSysUtil : NSObject

/**
 * Returns the application document directory.  This is trivial in
 * iOS, but tediously verbose.
 */
+ (NSString*)applicationFileDir;

@end
