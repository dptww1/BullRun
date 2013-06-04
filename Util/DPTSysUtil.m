//
//  DPTSysUtil.m
//  Bull Run
//
//  Created by Dave Townsend on 1/7/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import "DPTSysUtil.h"

@implementation DPTSysUtil

+ (NSString*)applicationFileDir {
    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
}

@end
