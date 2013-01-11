//
//  MapViewController.h
//  Bull Run
//
//  Created by Dave Townsend on 12/24/12.
//  Copyright (c) 2012 Dave Townsend. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HexMapCoordinateTransformer;
@class InfoBarView;
@class OrderOfBattle;

@interface MapViewController : UIViewController

@property (nonatomic, strong) HexMapCoordinateTransformer* coordXformer;
@property (nonatomic, weak)   InfoBarView*                 infoBarView;

@end
