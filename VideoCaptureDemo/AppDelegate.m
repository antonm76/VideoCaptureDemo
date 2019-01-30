//
//  AppDelegate.m
//  VideoCaptureDemo
//
//  Created by Adriaan Stellingwerff on 31/03/2015.
//  Copyright (c) 2015 Infoding. All rights reserved.
//

#import "AppDelegate.h"
#import "IDCaptureSessionPipelineViewController.h"

//============================================================================
@interface AppDelegate ()

@property (nonatomic, weak) IDCaptureSessionPipelineViewController* pipelineViewController;

@end

//============================================================================
@implementation AppDelegate

//----------------------------------------------------------------------------
- (BOOL) application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{
    self.pipelineViewController = (IDCaptureSessionPipelineViewController*)self.window.rootViewController;

    [self.pipelineViewController setup];
    [self.pipelineViewController startRunning];

    return YES;
}

//----------------------------------------------------------------------------
- (void) applicationWillResignActive:(UIApplication*)application
{
    [self.pipelineViewController stopRunning];
}

//----------------------------------------------------------------------------
- (void) applicationDidEnterBackground:(UIApplication*)application
{
}

//----------------------------------------------------------------------------
- (void) applicationWillEnterForeground:(UIApplication*)application
{
}

//----------------------------------------------------------------------------
- (void) applicationDidBecomeActive:(UIApplication*)application
{
    [self.pipelineViewController startRunning];
}

//----------------------------------------------------------------------------
- (void) applicationWillTerminate:(UIApplication*)application
{
}

@end
