//
//  UnitView.h
//  Bull Run
//
//  Created by Dave Townsend on 1/16/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <Foundation/Foundation.h>

// NB: Not really a "View" in the UIKit sense of the word.  Maybe UnitGfx would be better?
// (Or UnitGEL as a nod to the Amiga....)

@class Unit;

@interface UnitView : CALayer

+ (UnitView*)createForUnit:(Unit*)unit;
+ (UnitView*)findByName:(NSString*)unitName;

@end
