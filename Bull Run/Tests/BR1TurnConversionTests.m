//
//  BR1TurnConversionTests.m
//  Bull Run
//
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import "BattleAt.h"
#import "BR1GameDelegate.h"
#import "BR1TurnConversionTests.h"

static int turns[] = {
      1,          2,         3,         4,         10,         11,
     12,         13,        14,        15,         16,         17
};
static char* strings[] = {
     "6:30 AM",  "7:00 AM", "7:30 AM", "8:00 AM", "11:00 AM", "11:30 AM",
    "12:00 PM", "12:30 PM", "1:00 PM", "1:30 PM",  "2:00 PM",  "2:30 PM"
};

@implementation BR1TurnConversionTests

- (void)testConvertTurnToString {
    for (int i = 0; i < sizeof(turns)/sizeof(turns[0]); ++i) {
        int turn = turns[i];
        NSString* actual = [[game delegate] convertTurnToString:turn];
        NSString* expected = [NSString stringWithUTF8String:strings[i]];
        STAssertEqualObjects(actual, expected, nil);
    }
}

- (void)testConvertStringToTurn {
    for (int i = 0; i < sizeof(turns)/sizeof(turns[0]); ++i) {
        NSString* input = [NSString stringWithUTF8String:strings[i]];
        int actual = [[game delegate] convertStringToTurn:input];
        int expected = turns[i];
        STAssertEquals(actual, expected, nil);
    }
}

@end