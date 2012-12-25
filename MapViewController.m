//
//  MapViewController.m
//  Bull Run
//
//  Created by Dave Townsend on 12/24/12.
//  Copyright (c) 2012 Dave Townsend. All rights reserved.
//

#import "MapViewController.h"
#import "HexMapCoordinateTransformer.h"

#define DEGREES_TO_RADIANS(angle) (angle / 180.0 * M_PI)

@interface MapViewController ()

@end

@implementation MapViewController

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
                                                                             origin:CGPointMake(0, 0)
                                                                            hexSize:CGSizeMake(56, 56)]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch* t in touches) {
        CGPoint p = [t locationInView:[self view]];
        Hex hex = [[self coordXformer] screenToHex:p];
        NSLog(@"Touch at screen (%f,%f) hex (%02d%02d)", p.x, p.y, hex.column, hex.row);
    }
}

@end
