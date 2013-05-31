//
//  HMPathFinder.m
//  Bull Run
//
//  Created by Dave Townsend on 5/29/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import "HMMap.h"
#import "HMPathFinder.h"

//==============================================================================
@interface HMPathNode : NSObject

@property (nonatomic)      HMHex            hex;
@property (nonatomic)      float            cost;
@property (nonatomic,weak) HMPathNode* parent;

+ (HMPathNode*)nodeWithHex:(HMHex)hex cost:(float)cost;
+ (HMPathNode*)nodeWithHex:(HMHex)hex cost:(float)cost parent:(HMPathNode*)parent;

@end

//==============================================================================
@implementation HMPathNode

+ (HMPathNode*)nodeWithHex:(HMHex)hex cost:(float)cost {
    return [HMPathNode nodeWithHex:hex cost:cost parent:nil];
}

+ (HMPathNode*)nodeWithHex:(HMHex)hex cost:(float)cost parent:(HMPathNode*)parent {
    HMPathNode* n = [[HMPathNode alloc] init];

    if (n) {
        [n setHex:hex];
        [n setCost:cost];
        [n setParent:parent];
    }

    return n;
}

@end

//==============================================================================
@interface HMTraversalClosedSet : NSObject
+ (HMTraversalClosedSet*)closedSet;
- (HMPathNode*)findHex:(HMHex)hex;
- (void)addNode:(HMPathNode*)node;
- (void)removeNode:(HMPathNode*)node;
@end

//==============================================================================
@implementation HMTraversalClosedSet

+ (HMTraversalClosedSet*)closedSet {
    return nil;
}

- (HMPathNode*)findHex:(HMHex)hex {
    return nil;
}

- (void)addNode:(HMPathNode*)node {
}

- (void)removeNode:(HMPathNode*)node {
}

@end

//==============================================================================
@interface HMTraversalOpenSet : NSObject
+ (HMTraversalOpenSet*)openSetWithNode:(HMPathNode*)node;
- (HMPathNode*)getLowestCostNode;
- (HMPathNode*)findHex:(HMHex)hex;
- (void)addNode:(HMPathNode*)node;
- (void)removeNode:(HMPathNode*)node;
- (BOOL)isEmpty;
@end

//==============================================================================
@implementation HMTraversalOpenSet

+ (HMTraversalOpenSet*)openSetWithNode:(HMPathNode *)node {
    return nil;
}

- (HMPathNode*)getLowestCostNode {
    return nil;
}

- (HMPathNode*)findHex:(HMHex)hex {
    return nil;
}

- (void)addNode:(HMPathNode*)node {
}

- (void)removeNode:(HMPathNode*)node {
}

- (BOOL)isEmpty {
    return YES;
}
@end


//==============================================================================
@interface HMPathFinder ()

@property (nonatomic,strong) HMMap* map;

@end


//==============================================================================
@implementation HMPathFinder (Private)

- (NSMutableArray*)buildPathIntoArray:(NSMutableArray*)array fromNode:(HMPathNode*)node {
    if (!node) {
        [self buildPathIntoArray:array fromNode:[node parent]];
        [array addObject:node];
    }

    return array;
}

@end

//==============================================================================
@implementation HMPathFinder

+ (HMPathFinder*)pathFinderOnMap:(HMMap *)map {
    return [[HMPathFinder alloc] initForMap:map];
}

- initForMap:(HMMap*)map {
    self = [super init];

    if (self) {
        _map = map;
    }

    return self;
}

- (NSArray*)findPathFrom:(HMHex)start to:(HMHex)end using:(HMPathFinderEvalFn)fn {
    // Handle degenerate case
    if (HMHexEquals(start, end))
        return [NSArray array];

    HMPathNode* startNode = [HMPathNode nodeWithHex:start cost:0.0f];

    HMTraversalOpenSet* open = [HMTraversalOpenSet openSetWithNode:startNode];
    HMTraversalClosedSet* closed = [HMTraversalClosedSet closedSet];

    while (![open isEmpty]) {
        HMPathNode* curNode = [open getLowestCostNode];
        HMHex curHex = [curNode hex];

        if (HMHexEquals(curHex, end))
            return [self buildPathIntoArray:[NSMutableArray array] fromNode:curNode];

        // else we're not at the end yet
        [closed addNode:curNode];

        for (int i = 0; i < 6; ++i) {
            HMHex neighbor = [[self map] hexAdjacentTo:curHex inDirection:i];
            if (![[self map] legal:neighbor])
                continue;

            float cost = fn(curHex, neighbor);

            HMPathNode* openNeighbor = [open findHex:neighbor];
            if (openNeighbor && cost < [openNeighbor cost])
                [open removeNode:openNeighbor];

            HMPathNode* closedNeighbor = [closed findHex:neighbor];
            if (closedNeighbor && cost < [closedNeighbor cost])
                [closed removeNode:closedNeighbor];

            if (!openNeighbor && !closedNeighbor) {
                HMPathNode* n = [HMPathNode nodeWithHex:neighbor
                                                   cost:cost
                                                 parent:curNode];
                [open addNode:n];
            }
        }
    }

    // If we exited the loop, then the open set is empty and no path
    // from the 'start' to 'end' is possible.
    return [NSMutableArray array];
}

@end
