//
//  SCGSettings.h
//  StringsAndCoins
//
//  Created by David S Reich on 2/03/2014.
//  Copyright (c) 2014 Stellar Software Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCGLevel.h"

@interface SCGSettings : NSObject <NSCoding>

@property (assign, nonatomic) LevelType levelType;
@property (assign, nonatomic) LevelShape levelShape;
@property (assign, nonatomic) LevelSize levelSize;
@property (assign, nonatomic) int numberOfPlayers;
@property (assign, nonatomic) int paletteNumber;
@property (assign, nonatomic) BOOL gameInProgress;
@property (assign, nonatomic) BOOL gameOver;
@property (assign, nonatomic) BOOL newGame;
@property (assign, nonatomic) BOOL isIphone;
@property (assign, nonatomic) BOOL isIphone4;   //only 3.5", not 4"
@property (assign, nonatomic) BOOL isAI;
@property (assign, nonatomic) int aiSpeed;  //0 is slow, 1 is fast

- (void) setDefaultSettings;

@end
