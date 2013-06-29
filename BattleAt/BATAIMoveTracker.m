//
//  BATAIMoveTracker.m
//
//  Created by Dave Townsend on 6/24/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//


#import "BATAIMoveTracker.h"
#import "NSValue+HXMHex.h"


//==============================================================================
@interface BATAIMoveTracker ()

// Key: NSValue with integer representing impulse #
// Value: NSMutableDictionary
//        Key: NSValue with hex
//        Value: BAUnit*
@property (nonatomic, strong) NSMutableDictionary* impulses;

@end


//==============================================================================
@implementation BATAIMoveTracker

+ (id)tracker {
    return [[BATAIMoveTracker alloc] init];
}

- (id)init {
    self = [super init];

    if (self) {
        _impulses = [NSMutableDictionary dictionary];
    }

    return self;
}

- (void) clear {
    [_impulses removeAllObjects];
}

- (void)track:(BATUnit *)unit movingTo:(HXMHex)hex onImpulse:(int)impulse {
    NSValue* key = [NSValue valueWithBytes:&impulse objCType:@encode(int)];
    NSMutableDictionary* dict = _impulses[key];
    if (!dict) {
        dict = [NSMutableDictionary dictionary];
        _impulses[key] = dict;
    }

    dict[[NSValue valueWithHex:hex]] = unit;
}

- (BATUnit*)unitIn:(HXMHex)hex onImpulse:(int)impulse {
    NSValue* key = [NSValue valueWithBytes:&impulse objCType:@encode(int)];
    NSMutableDictionary* dict = _impulses[key];
    if (!dict)
        return nil;

    return dict[[NSValue valueWithHex:hex]];
}

@end
