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

#define DEGREES_TO_RADIANS(angle) (angle / 180.0 * M_PI)

@implementation MapViewController

#pragma mark - Initialization

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Orient the view to the same alignment as the map, which expects (0,0) in the upper left corner
        // rather than the lower left corner with rotated axes.
        [[self view] setTransform:CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(90.0))];
        
        HexMapGeometry* geometry = [[HexMapGeometry alloc] initWithLongGrain:NO
                                                           firstColumnIsLong:NO
                                                                     numRows:13
                                                                  numColumns:17];
        
        [self setCoordXformer:[[HexMapCoordinateTransformer alloc] initWithGeometry:geometry
                                                                             origin:CGPointMake(66, 59)
                                                                            hexSize:CGSizeMake(50, 51)]];
        [self setOob:[[OrderOfBattle alloc] init]];
        
        CGColorRef usaColor = [[UIColor colorWithRed:0.3 green:0.3 blue:0.7 alpha:1.0] CGColor];
        CGColorRef csaColor = [[UIColor colorWithRed:0.7 green:0.3 blue:0.3 alpha:1.0] CGColor];
        
        for (int i = 0; i < [[_oob units] count]; ++i) {
            Unit* unit = [[_oob units] objectAtIndex:i];
            
            if ([geometry legal:[unit location]]) {
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
                NSLog(@"Touch at screen (%f,%f) hex (%02d%02d)", p.x, p.y, hex.column, hex.row);
                Unit* unit = [[self oob] unitInHex:hex];
                [[self infoBarView] showInfoForUnit:unit];
                [[self view] setNeedsDisplay];
            } else
                NSLog(@"Touch at screen (%f,%f) isn't a legal hex!", p.x, p.y);
        }
    }
}

@end
