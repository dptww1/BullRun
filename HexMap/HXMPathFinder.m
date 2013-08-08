//
//  HXMPathFinder.m
//  Bull Run
//
//  Created by Dave Townsend on 5/29/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import "HXMMap.h"
#import "HXMPathFinder.h"
#import "NSValue+HXMHex.h"

//==============================================================================
@interface HXMPathNode : NSObject

@property (nonatomic)      HXMHex       hex;
@property (nonatomic)      float        fCost;
@property (nonatomic)      float        gCost;
@property (nonatomic,weak) HXMPathNode* parent;

+ (HXMPathNode*)nodeWithHex:(HXMHex)hex;
+ (HXMPathNode*)nodeWithHex:(HXMHex)hex fCost:(float)fCost gCost:(float)gCost parent:(HXMPathNode*)parent;

@end

//==============================================================================
@implementation HXMPathNode

- (NSString*)description {
    return [NSString stringWithFormat:@"HXMPathNode (%02d%02d) fCost %.1f gCost %.1f",
            _hex.column, _hex.row, _fCost, _gCost];
}

- (BOOL)isEqual:(id)object {
    return [object isKindOfClass:[self class]]
        && [self hash] == [object hash];
}

- (NSUInteger)hash {
    return _hex.column * 10000 + _hex.row;
}

+ (HXMPathNode*)nodeWithHex:(HXMHex)hex {
    return [HXMPathNode nodeWithHex:hex fCost:0.0f gCost:0.0f parent:nil];
}

+ (HXMPathNode*)nodeWithHex:(HXMHex)hex fCost:(float)fCost gCost:(float)gCost parent:(HXMPathNode*)parent {
    HXMPathNode* n = [[HXMPathNode alloc] init];

    if (n) {
        [n setHex:hex];
        [n setFCost:fCost];
        [n setGCost:gCost];
        [n setParent:parent];
    }

    return n;
}

@end

//==============================================================================
@interface HXMPathFinderClosedSet : NSObject

@property (nonatomic,strong) NSMutableArray* nodes;

+ (HXMPathFinderClosedSet*)closedSet;
- (HXMPathNode*)findHex:(HXMHex)hex;
- (void)addNode:(HXMPathNode*)node;

@end

//==============================================================================
@implementation HXMPathFinderClosedSet

+ (HXMPathFinderClosedSet*)closedSet {
    HXMPathFinderClosedSet* set = [[HXMPathFinderClosedSet alloc] init];
    [set setNodes:[NSMutableArray array]];
    return set;
}

- (HXMPathNode*)findHex:(HXMHex)hex {
    for (HXMPathNode* node in _nodes)
        if (HXMHexEquals([node hex], hex))
            return node;

    return nil;
}

- (void)addNode:(HXMPathNode*)node {
    [_nodes addObject:node];
}

@end

//==============================================================================
@interface HXMPathFinderOpenSet : NSObject

@property (nonatomic,strong) NSMutableArray* nodes;

+ (HXMPathFinderOpenSet*)openSetWithNode:(HXMPathNode*)node;
- (HXMPathNode*)getLowestFCostNode;
- (HXMPathNode*)findHex:(HXMHex)hex;
- (void)addNode:(HXMPathNode*)node;
- (BOOL)isEmpty;

@end

//==============================================================================
@implementation HXMPathFinderOpenSet

+ (HXMPathFinderOpenSet*)openSetWithNode:(HXMPathNode*)node {
    HXMPathFinderOpenSet* set = [[HXMPathFinderOpenSet alloc] init];
    [set setNodes:[NSMutableArray arrayWithObject:node]];
    return set;
}

- (HXMPathNode*)getLowestFCostNode {
    if ([_nodes count] == 0)
        return nil;

    int          lowestIdx  = 0;
    HXMPathNode* lowestNode = _nodes[0];

    for (int i = 1; i < [_nodes count]; ++i) {
        HXMPathNode* node = _nodes[i];
        if ([node fCost] < [lowestNode fCost]) {
            lowestNode = node;
            lowestIdx = i;
        }
    }

    [_nodes removeObjectAtIndex:lowestIdx];

    return lowestNode;
}

- (HXMPathNode*)findHex:(HXMHex)hex {
    for (HXMPathNode* node in _nodes)
        if (HXMHexEquals([node hex], hex))
            return node;

    return nil;
}

- (void)addNode:(HXMPathNode*)node {
    [_nodes addObject:node];
}

- (BOOL)isEmpty {
    return [_nodes count] == 0;
}
@end


//==============================================================================
@interface HXMPathFinder ()

@property (nonatomic,strong) HXMMap* map;
@property (nonatomic,assign) float  minCost;

@end


//==============================================================================
@implementation HXMPathFinder (Private)

- (NSMutableArray*)buildPathIntoArray:(NSMutableArray*)array fromNode:(HXMPathNode*)node {
    if (node) {
        [self buildPathIntoArray:array fromNode:[node parent]];
        [array addObject:[NSValue valueWithHex:[node hex]]];
    }

    return array;
}

@end

//==============================================================================
@implementation HXMPathFinder

+ (HXMPathFinder*)pathFinderOnMap:(HXMMap*)map withMinCost:(float)minCost {
    return [[HXMPathFinder alloc] initForMap:map withMinCost:minCost];
}

- (HXMPathFinder*)initForMap:(HXMMap*)map withMinCost:(float)minCost {
    self = [super init];

    if (self) {
        _map     = map;
        _minCost = minCost;
    }

    return self;
}

- (NSArray*)findPathFrom:(HXMHex)start to:(HXMHex)end using:(HXMPathFinderCostFn)fn {
    HXMPathNode* startNode = [HXMPathNode nodeWithHex:start];

    HXMPathFinderOpenSet* open = [HXMPathFinderOpenSet openSetWithNode:startNode];
    HXMPathFinderClosedSet* closed = [HXMPathFinderClosedSet closedSet];

    while (![open isEmpty]) {
        HXMPathNode* curNode = [open getLowestFCostNode];
        HXMHex curHex = [curNode hex];

        //NSLog(@"curHex %02d%02d fcost %f gcost %f", curHex.column, curHex.row, [curNode fCost], [curNode gCost]);

        if (HXMHexEquals(curHex, end))
            return [self buildPathIntoArray:[NSMutableArray array] fromNode:curNode];

        // else we're not at the end yet
        [closed addNode:curNode];

        for (int i = 0; i < 6; ++i) {
            HXMHex neighbor = [[self map] hexAdjacentTo:curHex inDirection:i];
            if (![[self map] legal:neighbor])
                continue;

            float cost = fn(curHex, neighbor);

            if (cost < 0.0f)
                continue;
            else
                cost /= _minCost;

            float gCost = cost + [curNode gCost];
            float fCost = gCost + [_map distanceFrom:neighbor to:end];

            HXMPathNode* closedNeighbor = [closed findHex:neighbor];
            if (closedNeighbor && gCost >= [closedNeighbor gCost])
                continue;

            HXMPathNode* openNeighbor = [open findHex:neighbor];

            if (!openNeighbor) {
                openNeighbor = [HXMPathNode nodeWithHex:neighbor
                                                  fCost:fCost
                                                  gCost:gCost
                                                 parent:curNode];
                [open addNode:openNeighbor];
            }

            else if (gCost < [openNeighbor gCost]) {
                [openNeighbor setParent:curNode];
                [openNeighbor setGCost:gCost];
                [openNeighbor setFCost:fCost];
            }
        }
    }

    // If we exited the loop, then the open set is empty and no path
    // from the 'start' to 'end' is possible.
    return [NSMutableArray array];
}

@end
