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
#import "MoveOrders.h"

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
        _currentUnit = nil;
        _moveOrderWayPoints = [NSMutableArray arrayWithCapacity:20];
    }
    
    return self;
}

- (void)drawLayer:(CALayer *)theLayer inContext:(CGContextRef)ctx {
    if (!_moveOrderWayPoints || [_moveOrderWayPoints count] == 0)
        return;
    
    UIGraphicsPushContext(ctx);
    
    CGContextSetLineWidth(ctx, 3.0);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    //    [[UIColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f] set];
    [[UIColor blackColor] set];
    
    CGPoint start = [(NSValue *)[_moveOrderWayPoints objectAtIndex:0] CGPointValue];
    CGContextMoveToPoint(ctx, start.x, start.y);
    
    NSLog(@"drawRect(): (%d,%d)", (int)start.x, (int)start.y);
    
    for (int i = 1; i < [_moveOrderWayPoints count]; ++i) {
        CGPoint p = [(NSValue*)[_moveOrderWayPoints objectAtIndex:i] CGPointValue];
        CGContextAddLineToPoint(ctx, p.x, p.y);
        NSLog(@"            (%d,%d)", (int)p.x, (int)p.y);
    }
    
    CGContextStrokePath(ctx);
    
    UIGraphicsPopContext();
}
- (void)addMoveOrderWayPoint:(CGPoint)pt {
    NSLog(@"addMoveOrderWayPoint:(%d,%d)", (int)pt.x, (int)pt.y);
    
    [_moveOrderWayPoints addObject:[NSValue valueWithCGPoint:pt]];
    [_moveOrderLayer setNeedsDisplay];
}

- (void)clearMoveOrderWayPoints {
    NSLog(@"clearMoveOrderwayPoints");
    [_moveOrderWayPoints removeAllObjects];
    [_moveOrderLayer setNeedsDisplay];
}

#pragma mark - Callbacks

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!_moveOrderLayer) {
        CGRect bounds = [[self view] bounds];
        
        _moveOrderLayer = [CALayer layer];
        [_moveOrderLayer setBounds:bounds];
        [_moveOrderLayer setPosition:CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds))];
        [_moveOrderLayer setDelegate:self];
        [_moveOrderLayer setZPosition:10.0f];
        
        [[[self view] layer] addSublayer:_moveOrderLayer];
    }
    
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

                _currentUnit = [[game oob] unitInHex:hex];
                [[self infoBarView] showInfoForUnit:_currentUnit];
                [[self view] setNeedsDisplay];
                _givingNewOrders = NO;
                
                // TODO: show orders for current unit
                
            } else
                NSLog(@"Touch at screen (%f,%f) isn't a legal hex!", p.x, p.y);
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!_currentUnit)
        return;

    for (UITouch* t in touches) {
        Hex h = [_coordXformer screenToHex:[t locationInView:[self view]]];
        
        // Just ignore illegal hexes
        if (![[_coordXformer geometry] legal:h])
            return;
            
        if (!_givingNewOrders && HexEquals([_currentUnit location], h)) {

            // The user may wiggle a finger around in the unit's current hex,
            // in which case just keep showing the existing orders.
            NSLog(@"Orders for %@: still in same hex", [_currentUnit name]);
                
        } else { // giving and/or continuing new orders
                
            // If this is the first hex outside the unit's current location, then
            // it's time to give new orders.
            if (!_givingNewOrders) {
                [[_currentUnit moveOrders] clear];
                [self clearMoveOrderWayPoints];
                
                _givingNewOrders = YES;
                
                CGPoint screenPt = [_coordXformer hexToScreen:[_currentUnit location]];
                screenPt.x += 23;
                screenPt.y += 23;
            
                [self addMoveOrderWayPoint:screenPt];
            }
                
            // TODO: Account for backtracking, where h == moveOrders[-2]
                
            // Add this hex on to the end of the list, unless it it's repeat of what's already there
            if (HexEquals([[_currentUnit moveOrders] lastHex], h)) {
                
                // Don't keep putting on the same hex on the end of the queue
                    
            } else { // it's a new hex
                    
                NSLog(@"Orders for %@: ADD %02d%02d", [_currentUnit name], h.column, h.row);
                [[_currentUnit moveOrders] addHex:h];
                
                CGPoint screenPt = [_coordXformer hexToScreen:h];
                screenPt.x += 23;
                screenPt.y += 23;
                
                [self addMoveOrderWayPoint:screenPt];
            }
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!_currentUnit)
        return;
    
    NSLog(@"Orders for %@: END", [_currentUnit name]);
    _currentUnit = nil;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchesEnded:touches withEvent:event];
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
