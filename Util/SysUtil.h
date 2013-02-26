//
//  SysUtil.h
//  Bull Run
//
//  Created by Dave Townsend on 1/7/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

@interface SysUtil : NSObject

+ (NSString*)applicationFileDir;

@end
