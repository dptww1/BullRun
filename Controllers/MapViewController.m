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
#import "MapView.h"
#import "UnitView.h"

#define DEGREES_TO_RADIANS(angle) (angle / 180.0 * M_PI)


#pragma mark - Private Methods

@implementation MapViewController (Private)

- (MapView*)getMapView {
    return (MapView*)[self view];
}

@end

@implementation MapViewController

#pragma mark - Initialization

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        _coordXformer = [[HexMapCoordinateTransformer alloc] initWithGeometry:[[game board] geometry]
                                                                       origin:CGPointMake(66, 59)
                                                                      hexSize:CGSizeMake(50, 51)];
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
            
            if ([[_coordXformer geometry] legal:hex]) {
                
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
    
    CALayer* unitLayer = [UnitView createForUnit:unit];
    [unitLayer removeFromSuperlayer];
    
    [[self view] setNeedsDisplay];
}

- (void)unitNowSighted:(Unit *)unit {
    NSLog(@"MapViewController#unitNowSighted:%@, viewLoaded=%d", [unit name], [self isViewLoaded]);
    
    CGPoint xy = [_coordXformer hexToScreen:[unit location]];
    xy.x += 25;  // TODO: don't hardcode; should be hexSize / 2
    xy.y += 25;
    
    CALayer* unitLayer = [UnitView createForUnit:unit];
    [unitLayer setPosition:xy];
    [[[self view] layer] addSublayer:unitLayer];

    [[self view] setNeedsDisplay];
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
