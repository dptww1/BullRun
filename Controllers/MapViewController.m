//
//  MapViewController.m
//  Bull Run
//
//  Created by Dave Townsend on 12/24/12.
//  Copyright (c) 2012 Dave Townsend. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "BullRun.h"
#import "MapViewController.h"
#import "HexMapCoordinateTransformer.h"
#import "InfoBarView.h"
#import "OrderOfBattle.h"
#import "Unit.h"
#import "Game.h"
#import "Board.h"

#define DEGREES_TO_RADIANS(angle) (angle / 180.0 * M_PI)

@implementation MapViewController

#pragma mark - Initialization

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Orient the view to the same alignment as the map, which expects (0,0) in the upper left corner
        // rather than the lower left corner with rotated axes.
        [[self view] setTransform:CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(90.0))];

        [self setCoordXformer:[[HexMapCoordinateTransformer alloc] initWithGeometry:[[game board] geometry]
                                                                             origin:CGPointMake(66, 59)
                                                                            hexSize:CGSizeMake(50, 51)]];

        CGColorRef usaColor = [[UIColor colorWithRed:0.3 green:0.3 blue:0.7 alpha:1.0] CGColor];
        CGColorRef csaColor = [[UIColor colorWithRed:0.7 green:0.3 blue:0.3 alpha:1.0] CGColor];
        
        for (int i = 0; i < [[[game oob] units] count]; ++i) {
            Unit* unit = [[[game oob] units] objectAtIndex:i];
            
            if ([unit side] == [game userSide] || [unit sighted]) {
            
                if ([[[game board] geometry] legal:[unit location]]) {
                    CGPoint xy = [_coordXformer hexToScreen:[unit location]];
                    xy.x += 25;
                    xy.y += 25;
                
                    CALayer* unitLayer = [[CALayer alloc] init];
                    [unitLayer setBounds:CGRectMake(0.0, 0.0, 30.0, 30.0)];
                    [unitLayer setPosition:xy];
                    [unitLayer setBackgroundColor:([unit side] == USA) ? usaColor : csaColor];

                    [[[self view] layer] addSublayer:unitLayer];
                }
            }
        }
    }
    return self;
}

#pragma mark - Callbacks

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!_infoBarView) {
        NSArray* infoBarObjects = [[NSBundle mainBundle] loadNibNamed:@"InfoBarView" owner:self options:nil];
        
        InfoBarView* v = infoBarObjects[0];
        
        CGRect vFrame = [v frame];
        vFrame.origin.x = [[self view] frame].size.height - [v frame].size.width;
        [v setFrame:vFrame];
        
        [self setInfoBarView:v];
        
        [[self view] addSubview:v];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch* t in touches) {
        CGPoint p = [t locationInView:[self view]];
        if (CGRectContainsPoint([[self infoBarView] frame], p)) {
            NSLog(@"Touched InfoBox!");
        } else {
            Hex hex = [[self coordXformer] screenToHex:p];
            if ([[[self coordXformer] geometry] legal:hex]) {
                
                // TODO: Remove this temp code once the map plist file is complete
                if (hex.row == 2 && hex.column == 2) {
                    [[game board] saveToFile:@"map.plist"];
                }
                
                NSLog(@"Touch at screen (%f,%f) hex (%02d%02d) terrain 0x%02x", p.x, p.y, hex.column, hex.row, [[game board] terrainAt:hex]);
                
                Unit* unit = [[game oob] unitInHex:hex];
                [[self infoBarView] showInfoForUnit:unit];
                [[self view] setNeedsDisplay];
            } else
                NSLog(@"Touch at screen (%f,%f) isn't a legal hex!", p.x, p.y);
        }
    }
}

#pragma mark - Battle@ Callbacks
- (void)unitNowHidden:(Unit *)unit {
    NSLog(@"MapViewController#unitNowHidden:%@, viewLoaded=%d", [unit name], [self isViewLoaded]);
}

- (void)unitNowSighted:(Unit *)unit {
    NSLog(@"MapViewController#unitNowSighted:%@, viewLoaded=%d", [unit name], [self isViewLoaded]);
}

#pragma mark - Debugging

- (IBAction)playerIsUsa:(id)sender {
    NSLog(@"Now player is USA");
    [game hackUserSide:USA];
    [[self view] setNeedsDisplay];
}

- (IBAction)playerIsCsa:(id)sender {
    NSLog(@"Now player is CSA");
    [game hackUserSide:CSA];
    [[self view] setNeedsDisplay];
}

@end
