//
//  ControlsView.m
//  DoodleJump
//
//  Created by Dmitry Ivanov on 8/28/11.
//  Copyright 2011 Sigma Ltd. All rights reserved.
//

#import "ControlsView.h"
#import "cocos2d.h"
#import "WorldView.h"
#import "GameScene.h"
#import "MainMenuScene.h"


@implementation ControlsView

@synthesize world;

- (id)initWithWorld:(World *)aWorld {
    self = [super init];
    if (self) {
        jumpButtonView = [[ButtonView alloc] init];
        jumpButtonView.delegate = self;
        jumpButtonView.position = ccp(40,40);
        [self addChild:jumpButtonView];
        
        shootButtonView = [[ButtonView alloc] init];
        shootButtonView.delegate = self;
        shootButtonView.position = ccp(440,40);
        [self addChild:shootButtonView];
            
        self.world = aWorld;
        
        heroStatusView = [[HeroStatusView alloc] initWithHero:world.hero];
        heroStatusView.position = ccp(470,310);
        [self addChild:heroStatusView];
        
        // pause menu
        _pauseScreenUp=FALSE;
        CCMenuItem *pauseMenuItem = [CCMenuItemImage itemFromNormalImage:@"pause.png" selectedImage:@"pause_selected.png" target:self selector:@selector(PauseButtonTapped:)];
        pauseMenuItem.position = ccp(30, 290);
        pauseMenuItem.scale = 0.25;
        CCMenu *upgradeMenu = [CCMenu menuWithItems:pauseMenuItem, nil];
        upgradeMenu.position = CGPointZero;
        [self addChild:upgradeMenu z:2];
        
        
        
        
    }
    return self;
}

- (void)dealloc {
    
    [jumpButtonView release];
    [shootButtonView release];
    
    [super dealloc];
}

- (void)buttonTouchedUpInside:(id)sender forTime:(double)dt
{
    if (_deathScreenUp == TRUE) return;
    
    if (sender == jumpButtonView)
    {
        [world jumpWithStrength:dt];
    }
    if (sender == shootButtonView)
    {
        [world shoot];
    }
    
}

// game over menu
- (void)showGameOverMenu
{    
    _deathScreenUp = TRUE;
    
    [[CCDirector sharedDirector] pause];
    CGSize s = [[CCDirector sharedDirector] winSize];
    pauseLayer = [CCColorLayer layerWithColor: ccc4(150, 150, 150, 125) width: s.width height: s.height];
    pauseLayer.position = CGPointZero;
    [self addChild: pauseLayer z:8];
    
    _pauseScreen =[[CCSprite spriteWithFile:@"background-menu.png"] retain];
    _pauseScreen.position= ccp(250,150);
    [self addChild:_pauseScreen z:8];
     
    CCMenuItem *MainMenuItem = [CCMenuItemImage
                                itemFromNormalImage:@"menu_button.png" selectedImage:@"menu_button_highlighted.png"
                                target:self selector:@selector(MainMenuButtonTapped:)];
    
    CCLabelTTF* mainMenuIconLabel = [CCLabelTTF labelWithString:@"Main menu" dimensions:CGSizeMake(140, 50) alignment:UITextAlignmentCenter lineBreakMode:UILineBreakModeWordWrap fontName:@"Courier" fontSize:20];
    
	mainMenuIconLabel.color = ccc3(255,255,255);
	mainMenuIconLabel.position = ccp(70,25);
	mainMenuIconLabel.tag = 1;
	[MainMenuItem addChild:mainMenuIconLabel];
    
    MainMenuItem.position = ccp(250, 175);
    
    /*
    CCMenuItem *QuitMenuItem = [CCMenuItemImage
                                itemFromNormalImage:@"blankbutton.gif" selectedImage:@"blankbutton.gif"
                                target:self selector:@selector(QuitButtonTapped:)];
    
    CCLabelTTF* quitIconLabel = [CCLabelTTF labelWithString:@"Quit" dimensions:CGSizeMake(100, 50) alignment:UITextAlignmentCenter lineBreakMode:UILineBreakModeCharacterWrap fontName:@"Courier" fontSize:20];
    
	quitIconLabel.color = ccc3(255,255,255);
	quitIconLabel.position = ccp(50,25);
	quitIconLabel.tag = 1;
	[QuitMenuItem addChild:quitIconLabel];
    
    QuitMenuItem.position = ccp(250, 80);
     */
    
    CCMenuItem *restartMenuItem = [CCMenuItemImage
                                itemFromNormalImage:@"menu_button.png" selectedImage:@"menu_button_highlighted.png"
                                target:self selector:@selector(NewGameButtonTapped:)];
    
	CCLabelTTF* restartIconLabel = [CCLabelTTF labelWithString:@"Restart" dimensions:CGSizeMake(140, 50) alignment:UITextAlignmentCenter lineBreakMode:UILineBreakModeCharacterWrap fontName:@"Courier" fontSize:20];
    
	restartIconLabel.color = ccc3(255,255,255);
	restartIconLabel.position = ccp(70,15);
	restartIconLabel.tag = 1;
	[restartMenuItem addChild:restartIconLabel];
    
    restartMenuItem.position = ccp(250, 100);
    
    _pauseScreenMenu = [CCMenu menuWithItems:/*QuitMenuItem,*/restartMenuItem,MainMenuItem, nil];
    _pauseScreenMenu.position = ccp(0,0);
    [self addChild:_pauseScreenMenu z:10];
    
}

// pause menus
- (void)PauseButtonTapped:(id)sender
{
    if(_pauseScreenUp == FALSE && _deathScreenUp == FALSE)
    {
        _pauseScreenUp=TRUE;
        //if you have music uncomment the line bellow
        //[[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
        [[CCDirector sharedDirector] pause];
        CGSize s = [[CCDirector sharedDirector] winSize];
        pauseLayer = [CCColorLayer layerWithColor: ccc4(150, 150, 150, 125) width: s.width height: s.height];
        pauseLayer.position = CGPointZero;
        [self addChild: pauseLayer z:8];
        
        _pauseScreen =[[CCSprite spriteWithFile:@"background-menu.png"] retain];
        _pauseScreen.position= ccp(250,150);
        [self addChild:_pauseScreen z:8];
        
        CCMenuItem *ResumeMenuItem = [CCMenuItemImage
                                       itemFromNormalImage:@"menu_button.png" selectedImage:@"menu_button_highlighted.png"
                                       target:self selector:@selector(ResumeButtonTapped:)];
        
        CCLabelTTF* resumeIconLabel = [CCLabelTTF labelWithString:@"Continue" dimensions:CGSizeMake(140, 50) alignment:UITextAlignmentCenter lineBreakMode:UILineBreakModeCharacterWrap fontName:@"Courier" fontSize:20];
        
        resumeIconLabel.color = ccc3(255,255,255);
        resumeIconLabel.position = ccp(70,15);
        resumeIconLabel.tag = 1;
        [ResumeMenuItem addChild:resumeIconLabel];
        
        ResumeMenuItem.position = ccp(250, 230);
        
        
        CCMenuItem *restartMenuItem = [CCMenuItemImage
                                       itemFromNormalImage:@"menu_button.png" selectedImage:@"menu_button_highlighted.png"
                                       target:self selector:@selector(NewGameButtonTapped:)];
        
        CCLabelTTF* restartIconLabel = [CCLabelTTF labelWithString:@"Restart" dimensions:CGSizeMake(140, 50) alignment:UITextAlignmentCenter lineBreakMode:UILineBreakModeCharacterWrap fontName:@"Courier" fontSize:20];
        
        restartIconLabel.color = ccc3(255,255,255);
        restartIconLabel.position = ccp(70,15);
        restartIconLabel.tag = 1;
        [restartMenuItem addChild:restartIconLabel];
        
        restartMenuItem.position = ccp(250, 150);
        
        CCMenuItem *QuitMenuItem = [CCMenuItemImage
                                    itemFromNormalImage:@"menu_button.png" selectedImage:@"menu_button_highlighted.png"
                                    target:self selector:@selector(MainMenuButtonTapped:)];
        
        CCLabelTTF* mainMenuIconLabel = [CCLabelTTF labelWithString:@"Main menu" dimensions:CGSizeMake(140, 50) alignment:UITextAlignmentCenter lineBreakMode:UILineBreakModeWordWrap fontName:@"Courier" fontSize:20];
        
        mainMenuIconLabel.color = ccc3(255,255,255);
        mainMenuIconLabel.position = ccp(70,15);
        mainMenuIconLabel.tag = 1;
        [QuitMenuItem addChild:mainMenuIconLabel];
        
        QuitMenuItem.position = ccp(250, 75); 
        
        _pauseScreenMenu = [CCMenu menuWithItems:ResumeMenuItem,QuitMenuItem,restartMenuItem, nil];
        _pauseScreenMenu.position = ccp(0,0);
        [self addChild:_pauseScreenMenu z:10];
    }
}

- (void)MainMenuButtonTapped:(id)sender
{
    [[CCDirector sharedDirector] resume];
    
    [[CCDirector sharedDirector] replaceScene:[MainMenuScene scene]];
    
}

- (void)NewGameButtonTapped:(id)sender{
   
    [[CCDirector sharedDirector] resume];
    
    [[CCDirector sharedDirector] replaceScene:[GameScene scene]];
    
}

- (void)ResumeButtonTapped:(id)sender{
    
    [self removeChild:_pauseScreen cleanup:YES];
    [self removeChild:_pauseScreenMenu cleanup:YES];
    [self removeChild:pauseLayer cleanup:YES];
    [[CCDirector sharedDirector] resume];
    _pauseScreenUp=FALSE;
}

- (void)QuitButtonTapped:(id)sender{
    
    [self removeChild:_pauseScreen cleanup:YES];
    [self removeChild:_pauseScreenMenu cleanup:YES];
    [self removeChild:pauseLayer cleanup:YES];
    [[CCDirector sharedDirector] resume];
    _pauseScreenUp=FALSE;
    [[UIApplication sharedApplication] terminateWithSuccess];
}

- (void)release {
    [super release];
}

- (id)retain {
    return [super retain];
}

@end
