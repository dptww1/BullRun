//
//  MapViewController.m
//  Bull Run
//
//  Created by Dave Townsend on 12/24/12.
//  Copyright (c) 2012 Dave Townsend. All rights reserved.
//

#import "MapViewController.h"
#import "HexMapCoordinateTransformer.h"
#import "InfoBarView.h"

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
                                                                     numRows:12
                                                                  numColumns:17];
        
        [self setCoordXformer:[[HexMapCoordinateTransformer alloc] initWithGeometry:geometry
                                                                             origin:CGPointMake(35, 42)
                                                                            hexSize:CGSizeMake(56, 56)]];
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
            if ([[[self coordXformer] geometry] legal:hex])
                NSLog(@"Touch at screen (%f,%f) hex (%02d%02d)", p.x, p.y, hex.column, hex.row);
            else
                NSLog(@"Touch at screen (%f,%f) isn't a legal hex!", p.x, p.y);
        }
    }
}

@end
