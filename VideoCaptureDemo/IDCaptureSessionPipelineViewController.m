//
//  IDCaptureSessionPipelineViewController.m
//  VideoCaptureDemo
//
//  Created by Adriaan Stellingwerff on 9/04/2015.
//  Copyright (c) 2015 Infoding. All rights reserved.
//

#import "IDCaptureSessionPipelineViewController.h"
#import "IDCaptureSessionAssetWriterCoordinator.h"
#import "VideoCaptureDemo-Swift.h"

//TODO: add backgrounding stuff

//============================================================================
@interface IDCaptureSessionPipelineViewController ()<IDCaptureSessionCoordinatorDelegate>

@property (nonatomic, strong) IDCaptureSessionCoordinator* captureSessionCoordinator;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* recordButton;

@property (nonatomic, assign) BOOL recording;

@end

//============================================================================
@implementation IDCaptureSessionPipelineViewController

//----------------------------------------------------------------------------
- (void) setup
{
    [self checkPermissions];

    self.captureSessionCoordinator = [IDCaptureSessionAssetWriterCoordinator new];
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
- (void) coordinatorDidBeginRecording:(IDCaptureSessionCoordinator*)coordinator
{
    self.recordButton.enabled = YES;
}

//----------------------------------------------------------------------------
- (void) coordinator:(IDCaptureSessionCoordinator*)coordinator didFinishRecordingToOutputFileURL:(NSURL*)outputFileURL error:(NSError*)error
{
    [UIApplication sharedApplication].idleTimerDisabled = NO;

    self.recordButton.title = @"Record";
    self.recording = NO;

    //Do something useful with the video file available at the outputFileURL
    [Assets copyFileToPhotoLibraryFrom:outputFileURL];
}

@end
