//
//  SysUtil.m
//  Bull Run
//
//  Created by Dave Townsend on 1/7/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import "SysUtil.h"

@implementation SysUtil

+ (NSString*)applicationFileDir {
    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
}

@end
