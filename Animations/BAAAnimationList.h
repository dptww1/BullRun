//
//  BAAAnimationList.h
//  Bull Run
//
//  Created by Dave Townsend on 4/8/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BAAAnimationListItem;
@class HMCoordinateTransformer;

@interface BAAAnimationList : NSObject

@property (strong,nonatomic) NSMutableArray*          items;
@property (nonatomic)        int                      nextItemIdx;
@property (weak,nonatomic)   HMCoordinateTransformer* xformer;
@property (copy)             void                    (^completionBlock)(void);

+ (BAAAnimationList*) listWithCoordXFormer:(HMCoordinateTransformer*)xformer;

- (void)addItem:(BAAAnimationListItem*)item;
- (void)reset;
- (void)run:(void (^)(void))completionBlock;

@end
