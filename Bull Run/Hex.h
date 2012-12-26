//
//  Hex.h
//  Bull Run
//
//  Created by Dave Townsend on 12/25/12.
//  Copyright (c) 2012 Dave Townsend. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Hex : NSObject

- (id)initWithColumn:(int)col row:(int)row;
- (int)row;
- (int)column;

@end
