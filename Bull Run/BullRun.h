//
//  BullRun.h
//  Bull Run
//
//  Created by Dave Townsend on 1/5/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#ifndef Bull_Run_BullRun_h
#define Bull_Run_BullRun_h

typedef enum { CSA, USA } PlayerSide;

#define OtherPlayer(SIDE) ((SIDE) == CSA ? USA : CSA)

typedef enum { CHARGE, ATTACK, SKIRMISH, DEFEND, WITHDRAW, ROUTED } Mode;


#define DEBUG_MOVEMENT(fmt, ...) NSLog(fmt, ## __VA_ARGS__)
#define DEBUG_MOVEORDERS(fmt, ...) //NSLog(fmt, ## __VA_ARGS__)
#define DEBUG_SIGHTING(fmt, ...) //NSLog(fmt, ## __VA_ARGS__)

#endif
