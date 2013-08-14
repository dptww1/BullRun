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
                 fromChoices:(NSArray*)choices
                  usingIndex:(int)idx {

    // Get selected choice, removing the "this is the historical choice" marker
    NSString* choiceStr = [choices[idx]
                           stringByReplacingOccurrencesOfString:@"*"
                           withString:@""];

    if ([choiceStr isEqualToString:@"At Start"]) {
        DEBUG_REINFORCEMENTS(@"%@ starting in hex %02d%02d",
                             name, startHex.column, startHex.row);
        [[game oob] addStartingUnit:name atHex:startHex];

    } else if ([choiceStr isEqualToString:@"Not in Battle"]) {
        DEBUG_REINFORCEMENTS(@"%@ removed from game", name);
        [[game oob] removeFromGame:name];

    } else { // must be formatted as "hh:mm pm/cc.rr"
        NSArray* elts = [choiceStr componentsSeparatedByString:@"/"];
        int turn = [[game delegate] convertStringToTurn:elts[0]];

        elts = [elts[1] componentsSeparatedByString:@"."];
        HXMHex hex = HXMHexMake([elts[0] intValue], [elts[1] intValue]);

        DEBUG_REINFORCEMENTS(@"%@ arriving turn %d at %02d%02d",
                             name, turn, hex.column, hex.row);

        [[game oob] addReinforcingUnit:name atHex:hex onTurn:turn];
    }
}

- (void)toggleStartStateForUnit:(NSString*)name atHex:(HXMHex)hex withSelectState:(int)state {
    DEBUG_REINFORCEMENTS(@"%@ (%02d%0d) set to state %d",
                         name, hex.column, hex.row, state);
    if (state == 0) // then not in battle
        [[game oob] removeFromGame:name];

    else // shows up at start
        [[game oob] addStartingUnit:name atHex:hex];
}

- (IBAction)sgCtlMilitia:(id)sender {
    [self toggleStartStateForUnit:@"Militia"
                            atHex:HXMHexMake(13, 3)
                  withSelectState:[sender selectedSegmentIndex]];
}

- (IBAction)sgCtlVolunteers:(id)sender {
    [self toggleStartStateForUnit:@"Volunteers"
                            atHex:HXMHexMake(13, 4)
                  withSelectState:[sender selectedSegmentIndex]];
}

- (IBAction)sgCtlHolmes:(id)sender {
    [self toggleStartStateForUnit:@"Holmes"
                            atHex:HXMHexMake(13, 11)
                  withSelectState:1 - [sender selectedSegmentIndex]];
}

- (IBAction)sgCtlSmith:(id)sender {
    [self setStartStateForUnit:@"Smith"
                      startHex:HXMHexMake(-1, -1)
                   fromChoices:@[@"12:00 PM/09.12", @"Not in Battle"]
                    usingIndex:[sender selectedSegmentIndex]];
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
