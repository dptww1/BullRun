//
//  Board.h
//  Bull Run
//
//  Created by Dave Townsend on 1/11/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HexMapGeometry.h"

@interface Board : NSObject

@property (readonly, strong) HexMapGeometry* geometry;

@end
