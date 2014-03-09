//
//  SCGSettings.h
//  StringsAndCoins
//
//  Created by David S Reich on 2/03/2014.
//  Copyright (c) 2014 Stellar Software Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCGLevel.h"

@interface SCGSettings : NSObject

@property (assign, nonatomic) LevelType levelType;
@property (assign, nonatomic) LevelShape levelShape;
@property (assign, nonatomic) LevelSize levelSize;
@property (assign, nonatomic) int numberOfPlayers;

@end