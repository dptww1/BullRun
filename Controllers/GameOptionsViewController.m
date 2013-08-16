//
//  GameOptionsViewController.m
//  Bull Run
//
//  Created by Dave Townsend on 7/11/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import "BattleAt.h"
#import "HexMap.h"
#import "GameOptionsViewController.h"
#import "MenuController.h"

//==============================================================================
@implementation GameOptionsViewController

- (void)setStartStateForUnit:(NSString*)name
                    startHex:(HXMHex)startHex
            reinforcementHex:(HXMHex)reinforcementHex
              basedOnControl:(id)segmentedControl {

    // Get the selected segment title
    NSString* choiceStr =
        [segmentedControl titleForSegmentAtIndex:[segmentedControl selectedSegmentIndex]];

    // Remove the "this is the historical choice" marker
    choiceStr = [choiceStr stringByReplacingOccurrencesOfString:@"*"
                                                     withString:@""];

    if ([choiceStr isEqualToString:@"At Start"]) {
        DEBUG_REINFORCEMENTS(@"%@ starting in hex %02d%02d",
                             name, startHex.column, startHex.row);
        [[game oob] addStartingUnit:name atHex:startHex];

    } else if ([choiceStr isEqualToString:@"Not in Battle"]) {
        DEBUG_REINFORCEMENTS(@"%@ removed from game", name);
        [[game oob] removeFromGame:name];

    } else {
        // Must be a reinforcement; remove the "Arrives " leading text
        choiceStr = [choiceStr stringByReplacingOccurrencesOfString:@"Arrives "
                                                         withString:@""];
        // The labels use "Noon" instead of "12:00 PM"
        if ([choiceStr isEqualToString:@"Noon"])
            choiceStr = @"12:00 PM";

        // Convert 8AM, 4PM into canonical form
        if ([choiceStr length] <= 4) {
            NSString* hr = [choiceStr substringToIndex:[choiceStr length] - 2];
            choiceStr = [NSString stringWithFormat:@"%@:00 %@",
                         hr,
                         [choiceStr substringFromIndex:[choiceStr length] - 2]];
        }

        int turn = [[game delegate] convertStringToTurn:choiceStr];

        DEBUG_REINFORCEMENTS(@"%@ arriving turn %d at %02d%02d",
                             name, turn,
                             reinforcementHex.column, reinforcementHex.row);

        [[game oob] addReinforcingUnit:name atHex:reinforcementHex onTurn:turn];
    }
}

- (IBAction)sgCtlMilitia:(id)sender {
    [self setStartStateForUnit:@"Militia"
                      startHex:HXMHexMake(13, 3)
              reinforcementHex:HXMHexMake(13, 3)
                basedOnControl:sender];
}

- (IBAction)sgCtlVolunteers:(id)sender {
    [self setStartStateForUnit:@"Volunteers"
                      startHex:HXMHexMake(13, 4)
              reinforcementHex:HXMHexMake(13, 4)
                basedOnControl:sender];
}

- (IBAction)sgCtlBartow:(id)sender {
    [self setStartStateForUnit:@"Bartow"
                      startHex:HXMHexMake(12, 10)
              reinforcementHex:HXMHexMake(9, 12)
                basedOnControl:sender];
}

- (IBAction)sgCtlBee:(id)sender {
    [self setStartStateForUnit:@"Bee"
                      startHex:HXMHexMake(11, 10)
              reinforcementHex:HXMHexMake(9, 12)
                basedOnControl:sender];
}

- (IBAction)sgCtlHolmes:(id)sender {
    [self setStartStateForUnit:@"Holmes"
                      startHex:HXMHexMake(13, 11)
              reinforcementHex:HXMHexMake(13, 11)
                basedOnControl:sender];
}

- (IBAction)sgCtlJackson:(id)sender {
    [self setStartStateForUnit:@"Jackson"
                      startHex:HXMHexMake(11, 9)
              reinforcementHex:HXMHexMake(9, 12)
                basedOnControl:sender];
}

- (IBAction)sgCtlSmith:(id)sender {
    [self setStartStateForUnit:@"Smith"
                      startHex:HXMHexMake(9, 12)
              reinforcementHex:HXMHexMake(9, 12)
                basedOnControl:sender];
}

- (IBAction)btnDoneTouched:(id)sender {
    [[MenuController sharedInstance] popController];
}

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
