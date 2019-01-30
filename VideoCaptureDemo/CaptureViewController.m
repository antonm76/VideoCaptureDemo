//
//  CaptureViewController.m
//  VideoCaptureDemo
//
//  Created by Adriaan Stellingwerff on 9/04/2015.
//  Copyright (c) 2015 Infoding. All rights reserved.
//

#import "CaptureViewController.h"
#import "CaptureSessionAssetWriterManager.h"
#import "VideoCaptureDemo-Swift.h"

//TODO: add backgrounding stuff

//============================================================================
@interface CaptureViewController ()<CaptureSessionManagerDelegate>

@property (nonatomic, strong) CaptureSessionManager* captureSessionCoordinator;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* recordButton;

@property (nonatomic, assign) BOOL recording;

@end

//============================================================================
@implementation CaptureViewController

//----------------------------------------------------------------------------
- (void) setup
{
    [self checkPermissions];

    self.captureSessionCoordinator = [CaptureSessionAssetWriterManager new];
    [self.captureSessionCoordinator setDelegate:self callbackQueue:dispatch_get_main_queue()];

    [self configureInterface];
}

//----------------------------------------------------------------------------
- (void) startRunning
{
    [self.captureSessionCoordinator startRunning];
}

//----------------------------------------------------------------------------
- (void) stopRunning
{
    [self.captureSessionCoordinator stopRunning];
}

//----------------------------------------------------------------------------
- (IBAction) toggleRecording:(id)sender
{
    if (self.recording)
    {
        [self.captureSessionCoordinator stopRecording];
    }
    else
    {
        // Disable the idle timer while recording
        [UIApplication sharedApplication].idleTimerDisabled = YES;

        self.recordButton.enabled = NO; // re-enabled once recording has finished starting
        self.recordButton.title = @"Stop";

        [self.captureSessionCoordinator startRecording];

        self.recording = YES;
    }
}

#pragma mark - Private methods

//----------------------------------------------------------------------------
- (void) configureInterface
{
    AVCaptureVideoPreviewLayer* previewLayer = [self.captureSessionCoordinator previewLayer];
    previewLayer.frame = self.view.bounds;
    [self.view.layer insertSublayer:previewLayer atIndex:0];
}

//----------------------------------------------------------------------------
- (void) checkPermissions
{
    PermissionsManager* permissionsManager = [PermissionsManager new];

    [permissionsManager checkCameraPermissionWithCompletion:^(BOOL granted)
    {
        if (!granted)
        {
            NSLog(@"we don't have permission to use the camera");
        }
    }];

    [permissionsManager checkMicrophonePermissionWithCompletion:^(BOOL granted)
    {
        if (!granted)
        {
            NSLog(@"we don't have permission to use the microphone");
        }
    }];

    [permissionsManager checkPhotoLibraryPermissionWithCompletion:^(BOOL granted)
    {
        if (!granted)
        {
            NSLog(@"we don't have permission to use the photo library");
        }
    }];
}

#pragma mark - IDCaptureSessionCoordinatorDelegate methods

//----------------------------------------------------------------------------
- (void) coordinatorDidBeginRecording:(CaptureSessionManager*)coordinator
{
    self.recordButton.enabled = YES;
}

//----------------------------------------------------------------------------
- (void) coordinator:(CaptureSessionManager*)coordinator didFinishRecordingToOutputFileURL:(NSURL*)outputFileURL error:(NSError*)error
{
    [UIApplication sharedApplication].idleTimerDisabled = NO;

    self.recordButton.title = @"Record";
    self.recording = NO;

    //Do something useful with the video file available at the outputFileURL
    [Assets copyFileToPhotoLibraryFrom:outputFileURL];
}

@end
