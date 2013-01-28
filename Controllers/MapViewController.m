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

- (void)addMoveOrderWayPoint:(Hex)h {
    CGPoint pt = [[self coordXformer] hexToScreen:h];
    pt.x += [[self coordXformer] hexSize].width  / 2;
    pt.y += [[self coordXformer] hexSize].height / 2;
    NSLog(@"addMoveOrderWayPoint:(%d,%d)", (int)pt.x, (int)pt.y);
    
    [[self moveOrderWayPoints] addObject:[NSValue valueWithCGPoint:pt]];
    [[self moveOrderLayer] setNeedsDisplay];
}

- (void)clearMoveOrderWayPoints {
    NSLog(@"clearMoveOrderwayPoints");
    [[self moveOrderWayPoints] removeAllObjects];
    [[self moveOrderLayer] setNeedsDisplay];
}

- (void)backtrackMoveOrderWayPoints {
    NSLog(@"backtrackMoveOrderwayPoints");
    [[self moveOrderWayPoints] removeLastObject];
    [[self moveOrderLayer] setNeedsDisplay];
}

- (void)initMoveOrderWayPoints {
    [self clearMoveOrderWayPoints];
    
    MoveOrders* mos = [[self currentUnit] moveOrders];
    
    if ([mos numHexes] == 0)
        return;
    
    [self addMoveOrderWayPoint:[[self currentUnit] location]];
     
    for (int i = 0; i < [mos numHexes]; ++i)
     [self addMoveOrderWayPoint:[mos hex:i]];
}

@end

@implementation MapViewController

#pragma mark - Initialization

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        _coordXformer = [[HexMapCoordinateTransformer alloc] initWithGeometry:[[game board] geometry]
                                                                       origin:CGPointMake(67, 58)
                                                                      hexSize:CGSizeMake(51, 51)];
        _currentUnit = nil;
        _moveOrderWayPoints = [NSMutableArray arrayWithCapacity:20];
        [self setWantsFullScreenLayout:YES];
    }
    
    return self;
}

- (void)drawLayer:(CALayer *)theLayer inContext:(CGContextRef)ctx {
    if (!_moveOrderWayPoints || [_moveOrderWayPoints count] == 0)
        return;
    
    UIGraphicsPushContext(ctx);
    
    CGContextSetLineWidth(ctx, 7.0);
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
    
    CGContextSetStrokeColorWithColor(ctx, [_currentUnit side] == CSA
                                            ? [[UIColor colorWithRed:0.7f green:0.3f blue:0.3f alpha:1.0f] CGColor]
                                            : [[UIColor colorWithRed:0.3f green:0.3f blue:0.7f alpha:1.0f] CGColor]);
    CGContextStrokePath(ctx);
    
    UIGraphicsPopContext();
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
        
        CGSize vSize = [v bounds].size;
        CGSize parentViewSize = [[self view] bounds].size;
        
        [v setCenter:CGPointMake(parentViewSize.height - vSize.width / 2.0, vSize.height / 2.0)];
        
        [self setInfoBarView:v];
        
        [[self view] addSubview:v];
        
        [v showInfoForUnit:nil];
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
                
                [self initMoveOrderWayPoints];
                
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
            
                [self addMoveOrderWayPoint:[_currentUnit location]];
            }
            
            // Account for backtracking, where h == moveOrders[-2]
            if ([[_currentUnit moveOrders] isBacktrack:h] ||
                ((HexEquals([_currentUnit location], h) && [_moveOrderWayPoints count] == 2))) {

                NSLog(@"Orders for %@: BACKTRACK to %02d%02d", [_currentUnit name], h.column, h.row);
                [[_currentUnit moveOrders] backtrack];
                [self backtrackMoveOrderWayPoints];
            }
            
            // Add this hex on to the end of the list, unless it it's repeat of what's already there
            else if (HexEquals([[_currentUnit moveOrders] lastHex], h)) {
                
                // Don't keep putting on the same hex on the end of the queue
                    
            } else { // it's a new hex
                    
                NSLog(@"Orders for %@: ADD %02d%02d", [_currentUnit name], h.column, h.row);
                [[_currentUnit moveOrders] addHex:h];
                [self addMoveOrderWayPoint:h];
            }
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!_currentUnit)
        return;
    
    NSLog(@"Orders for %@: END", [_currentUnit name]);
    _currentUnit = nil;
    
    [self clearMoveOrderWayPoints];
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
