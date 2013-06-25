//
//  NSArray+DPTUtilTests.m
//
//  Created by Dave Townsend on 6/25/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import "NSArray+DPTUtil.h"
#import "NSArray+DPTUtilTests.h"

@implementation NSArrayDPTUtilTests

- (void)testMinEmpty {
    NSArray* a = @[];
    int minVal = [a dpt_min_idx:nil];
    STAssertEquals(minVal, -1, nil);
}

- (void)testMinOneElement {
    NSArray* a = @[ @123 ];
    int minVal = [a dpt_min_idx:^NSNumber*(NSNumber* elt) {
        return elt;
    }];
    STAssertEquals(minVal, 0, nil);
 }

- (void)testMinSimple {
    NSArray* a = @[ @10, @5, @20 ];
    int minVal = [a dpt_min_idx:^NSNumber*(NSNumber* elt) {
        return elt;
    }];
    STAssertEquals(minVal, 1, nil);
}

- (void)testMinMultiple {
    NSArray* a = @[ @40, @20, @30, @20 ];
    int minVal = [a dpt_min_idx:^NSNumber*(NSNumber* elt) {
        return elt;
    }];
    STAssertEquals(minVal, 1, nil);
}

- (void)testMaxEmpty {
    NSArray* a = @[];
    int maxVal = [a dpt_max_idx:nil];
    STAssertEquals(maxVal, -1, nil);
}

- (void)testMaxOneElement {
    NSArray* a = @[ @123 ];
    int maxVal = [a dpt_max_idx:^NSNumber*(NSNumber* elt) {
        return elt;
    }];
    STAssertEquals(maxVal, 0, nil);
}

- (void)testMaxSimple {
    NSArray* a = @[ @10, @5, @20 ];
    int maxVal = [a dpt_max_idx:^NSNumber*(NSNumber* elt) {
        return elt;
    }];
    STAssertEquals(maxVal, 2, nil);
}

- (void)testMaxMultiple {
    NSArray* a = @[ @40, @30, @40, @20 ];
    int maxVal = [a dpt_max_idx:^NSNumber*(NSNumber* elt) {
        return elt;
    }];
    STAssertEquals(maxVal, 0, nil);
}

@end

