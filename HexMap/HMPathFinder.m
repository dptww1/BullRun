//
//  HMPathFinder.m
//  Bull Run
//
//  Created by Dave Townsend on 5/29/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import "HMMap.h"
#import "HMPathFinder.h"
#import "NSValue+HMHex.h"

//==============================================================================
@interface HMPathNode : NSObject

@property (nonatomic)      HMHex       hex;
@property (nonatomic)      float       fCost;
@property (nonatomic)      float       gCost;
@property (nonatomic,weak) HMPathNode* parent;

+ (HMPathNode*)nodeWithHex:(HMHex)hex;
+ (HMPathNode*)nodeWithHex:(HMHex)hex fCost:(float)fCost gCost:(float)gCost parent:(HMPathNode*)parent;

@end

//==============================================================================
@implementation HMPathNode

+ (HMPathNode*)nodeWithHex:(HMHex)hex {
    return [HMPathNode nodeWithHex:hex fCost:0.0f gCost:0.0f parent:nil];
}

+ (HMPathNode*)nodeWithHex:(HMHex)hex fCost:(float)fCost gCost:(float)gCost parent:(HMPathNode*)parent {
    HMPathNode* n = [[HMPathNode alloc] init];

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
@interface HMPathFinderClosedSet : NSObject

@property (nonatomic,strong) NSMutableArray* nodes;

+ (HMPathFinderClosedSet*)closedSet;
- (HMPathNode*)findHex:(HMHex)hex;
- (void)addNode:(HMPathNode*)node;
- (void)removeNode:(HMPathNode*)node;

@end

//==============================================================================
@implementation HMPathFinderClosedSet

+ (HMPathFinderClosedSet*)closedSet {
    HMPathFinderClosedSet* set = [[HMPathFinderClosedSet alloc] init];
    [set setNodes:[NSMutableArray array]];
    return set;
}

- (HMPathNode*)findHex:(HMHex)hex {
    for (HMPathNode* node in _nodes)
        if (HMHexEquals([node hex], hex))
            return node;

    return nil;
}

- (void)addNode:(HMPathNode*)node {
    [_nodes addObject:node];
}

- (void)removeNode:(HMPathNode*)node {
    [_nodes removeObject:node];
}

@end

//==============================================================================
@interface HMPathFinderOpenSet : NSObject

@property (nonatomic,strong) NSMutableArray* nodes;

+ (HMPathFinderOpenSet*)openSetWithNode:(HMPathNode*)node;
- (HMPathNode*)getLowestFCostNode;
- (HMPathNode*)findHex:(HMHex)hex;
- (void)addNode:(HMPathNode*)node;
- (void)removeNode:(HMPathNode*)node;
- (BOOL)isEmpty;

@end

//==============================================================================
@implementation HMPathFinderOpenSet

+ (HMPathFinderOpenSet*)openSetWithNode:(HMPathNode *)node {
    HMPathFinderOpenSet* set = [[HMPathFinderOpenSet alloc] init];
    [set setNodes:[NSMutableArray arrayWithObject:node]];
    return set;
}

- (HMPathNode*)getLowestFCostNode {
    if ([_nodes count] == 0)
        return nil;

    HMPathNode* lowestNode = [_nodes objectAtIndex:0];

    for (int i = 1; i < [_nodes count]; ++i) {
        HMPathNode* node = [_nodes objectAtIndex:i];
        if ([node fCost] < [lowestNode fCost])
            lowestNode = node;
    }

    [self removeNode:lowestNode];

    return lowestNode;
}

- (HMPathNode*)findHex:(HMHex)hex {
    for (HMPathNode* node in _nodes)
        if (HMHexEquals([node hex], hex))
            return node;

    return nil;
}

- (void)addNode:(HMPathNode*)node {
    [_nodes addObject:node];
}

- (void)removeNode:(HMPathNode*)node {
    [_nodes removeObject:node];
}

- (BOOL)isEmpty {
    return [_nodes count] == 0;
}
@end


//==============================================================================
@interface HMPathFinder ()

@property (nonatomic,strong) HMMap* map;
@property (nonatomic,assign) float  minCost;

@end


//==============================================================================
@implementation HMPathFinder (Private)

- (NSMutableArray*)buildPathIntoArray:(NSMutableArray*)array fromNode:(HMPathNode*)node {
    if (node) {
        [self buildPathIntoArray:array fromNode:[node parent]];
        [array addObject:[NSValue valueWithHex:[node hex]]];
    }

    return array;
}

@end

//==============================================================================
@implementation HMPathFinder

+ (HMPathFinder*)pathFinderOnMap:(HMMap *)map withMinCost:(float)minCost {
    return [[HMPathFinder alloc] initForMap:map withMinCost:minCost];
}

- (HMPathFinder*)initForMap:(HMMap*)map withMinCost:(float)minCost {
    self = [super init];

    if (self) {
        _map     = map;
        _minCost = minCost;
    }

    return self;
}

- (NSArray*)findPathFrom:(HMHex)start to:(HMHex)end using:(HMPathFinderCostFn)fn {
    HMPathNode* startNode = [HMPathNode nodeWithHex:start];

    HMPathFinderOpenSet* open = [HMPathFinderOpenSet openSetWithNode:startNode];
    HMPathFinderClosedSet* closed = [HMPathFinderClosedSet closedSet];

    while (![open isEmpty]) {
        HMPathNode* curNode = [open getLowestFCostNode];
        HMHex curHex = [curNode hex];

        NSLog(@"curHex %02d%02d fcost %f gcost %f", curHex.column, curHex.row, [curNode fCost], [curNode gCost]);

        if (HMHexEquals(curHex, end))
            return [self buildPathIntoArray:[NSMutableArray array] fromNode:curNode];

        // else we're not at the end yet
        [closed addNode:curNode];

        for (int i = 0; i < 6; ++i) {
            HMHex neighbor = [[self map] hexAdjacentTo:curHex inDirection:i];
            if (![[self map] legal:neighbor])
                continue;

            float cost = fn(curHex, neighbor);

            if (cost < 0.0f)
                continue;
            else
                cost /= _minCost;

            float gCost = cost + [curNode gCost];
            float fCost = gCost + [_map distanceFrom:neighbor to:end];

            HMPathNode* closedNeighbor = [closed findHex:neighbor];
            if (closedNeighbor && gCost >= [closedNeighbor gCost])
                continue;

            HMPathNode* openNeighbor = [open findHex:neighbor];

            if (!openNeighbor) {
                openNeighbor = [HMPathNode nodeWithHex:neighbor
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
