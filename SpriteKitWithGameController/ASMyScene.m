//
//  ASMyScene.m
//  SpriteKitWithGameController
//
//  Created by 寒川 明好 on 2014/03/05.
//  Copyright (c) 2014年 Akiyoshi Samukawa. All rights reserved.
//

#import "ASMyScene.h"
@implementation ASMyScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        self.myLabel.text = @"Hello, World!";
        self.myLabel.fontColor = [UIColor blackColor];
        self.myLabel.fontSize = 20;
        self.myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                            CGRectGetMidY(self.frame));
        [self addChild:self.myLabel];
        
        SKSpriteNode *searchNode = [SKSpriteNode spriteNodeWithImageNamed:@"icon_search"];
        searchNode.name = @"search";
        searchNode.position = CGPointMake(100, 240);
        [self addChild:searchNode];
        
        SKSpriteNode *closeNode = [SKSpriteNode spriteNodeWithImageNamed:@"icon_close"];
        closeNode.name = @"close";
        closeNode.position = CGPointMake(200, 240);
        [self addChild:closeNode];
        
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        // ゲームコントローラが接続されたときの通知
        [center addObserver:self
                   selector:@selector(controllerDidConnect)
                       name:GCControllerDidConnectNotification
                     object:nil];
        // ゲームコントローラの接続が途絶えたときの通知
        [center addObserver:self
                   selector:@selector(controllerDidDisconnect)
                       name:GCControllerDidDisconnectNotification
                     object:nil];
    }
    return self;
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    if ([@"search" isEqualToString:node.name]) {
        self.myLabel.text = @"startWirelessControllerDiscovery";
        // ワイヤレスゲームコントローラの検索をおこなう
        [GCController startWirelessControllerDiscoveryWithCompletionHandler:^{
            [self completionWirelessControllerDiscovery];
        }];
    } else if ([@"close" isEqualToString:node.name]) {
        // ワイアレスコントローラの検索を停止する
        [GCController stopWirelessControllerDiscovery];
    }
}

- (void)completionWirelessControllerDiscovery
{
    self.myLabel.text = @"completionWirelessControllerDiscovery";
    
    NSArray *controllers = [GCController controllers];
    for (GCController *controller in controllers) {
        [self setEventController:controller];
    }
}

- (void)setEventController:(GCController *)controller
{
    __weak typeof(self) weakSelf = self;
    
    // ポーズボタンイベント
    controller.controllerPausedHandler = ^(GCController *controller) {
        [self pausedOnController:controller];
    };
    
    if (!self.gamepad && controller.gamepad) {
        self.gamepad = controller.gamepad;
        // それぞれのボタンイベント
        self.gamepad.valueChangedHandler = ^(GCGamepad *gamepad, GCControllerElement *element) {
            if (gamepad.buttonA.isPressed) [weakSelf pressedButtonA];
            if (gamepad.buttonB.isPressed) [weakSelf pressedButtonB];
            if (gamepad.buttonX.isPressed) [weakSelf pressedButtonX];
            if (gamepad.buttonY.isPressed) [weakSelf pressedButtonY];
            if (gamepad.rightShoulder.isPressed)    [weakSelf pressedButtonRight];
            if (gamepad.leftShoulder.isPressed)     [weakSelf pressedButtonLeft];
            if (gamepad.dpad.up.isPressed)      [weakSelf pressedDpadUp];
            if (gamepad.dpad.down.isPressed)    [weakSelf pressedDpadDown];
            if (gamepad.dpad.right.isPressed)   [weakSelf pressedDpadRight];
            if (gamepad.dpad.left.isPressed)    [weakSelf pressedDpadLeft];
            // 十字キーのX軸：gamepad.dpad.xAxis.value
            // 十字キーのY軸：gamepad.dpad.yAxis.value
        };
    }
    
    // Aボタンだけのイベント
    self.gamepad.buttonA.valueChangedHandler = ^(GCControllerButtonInput *button, float value, BOOL pressed) {
        if (pressed) [weakSelf pressedButtonA];
    };
}

#pragma mark - NSNotificationCenter
- (void)controllerDidConnect
{
    self.myLabel.text = @"GamePad Connected";
    
    NSArray *controllers = [GCController controllers];
    for (GCController *controller in controllers) {
        [self setEventController:controller];
    }
}

- (void)controllerDidDisconnect
{
    self.myLabel.text = @"GamePad Disconnected";
    self.gamepad = nil;
}

#pragma mark - GCController EventHandler
- (void)pausedOnController:(GCController *)controller
{
    self.myLabel.text = @"Pause";
}
- (void)pressedButtonA
{
    self.myLabel.text = @"A";
}
- (void)pressedButtonB
{
    self.myLabel.text = @"B";
}
- (void)pressedButtonX
{
    self.myLabel.text = @"X";
}
- (void)pressedButtonY
{
    self.myLabel.text = @"Y";
}
- (void)pressedButtonRight
{
    self.myLabel.text = @"R";
}
- (void)pressedButtonLeft
{
    self.myLabel.text = @"L";
}
- (void)pressedDpadUp
{
    self.myLabel.text = @"UP";
}
- (void)pressedDpadDown
{
    self.myLabel.text = @"Down";
}
- (void)pressedDpadLeft
{
    self.myLabel.text = @"Left";
}
- (void)pressedDpadRight
{
    self.myLabel.text = @"Right";
}
@end
