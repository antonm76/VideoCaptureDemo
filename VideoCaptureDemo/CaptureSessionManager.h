//
//  CaptureSessionManager.h
//  VideoCaptureDemo
//
//  Created by Adriaan Stellingwerff on 1/04/2015.
//  Copyright (c) 2015 Infoding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

//============================================================================
@protocol CaptureSessionManagerDelegate;

//============================================================================
@interface CaptureSessionManager : NSObject

@property (nonatomic, strong) AVCaptureSession* captureSession;
@property (nonatomic, strong) dispatch_queue_t delegateCallbackQueue;
@property (nonatomic, weak) id<CaptureSessionManagerDelegate> delegate;

- (void) setDelegate:(id<CaptureSessionManagerDelegate>)delegate callbackQueue:(dispatch_queue_t)delegateCallbackQueue;

- (BOOL) addInput:(AVCaptureDeviceInput*)input toCaptureSession:(AVCaptureSession*)captureSession;
- (BOOL) addOutput:(AVCaptureOutput*)output toCaptureSession:(AVCaptureSession*)captureSession;

- (void) startRunning;
- (void) stopRunning;

- (void) startRecording;
- (void) stopRecording;

- (AVCaptureVideoPreviewLayer*) previewLayer;

@end

//============================================================================
@protocol CaptureSessionManagerDelegate<NSObject>

@required

- (void) coordinatorDidBeginRecording:(CaptureSessionManager*)coordinator;
- (void) coordinator:(CaptureSessionManager*)coordinator didFinishRecordingToOutputFileURL:(NSURL*)outputFileURL error:(NSError*)error;

@end
