//
//  ASMyScene.h
//  SpriteKitWithGameController
//

//  Copyright (c) 2014年 Akiyoshi Samukawa. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <GameController/GameController.h>

@interface ASMyScene : SKScene
@property (nonatomic) GCGamepad *gamepad;
@property (nonatomic, retain) SKLabelNode *myLabel;
@end
