//
//  AssetWriterManager.h
//  VideoCaptureDemo
//
//  Created by Adriaan Stellingwerff on 9/04/2015.
//  Copyright (c) 2015 Infoding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMedia/CoreMedia.h>
#import <AVFoundation/AVFoundation.h>

//============================================================================
@protocol AssetWriterManagerDelegate;

//============================================================================
@interface AssetWriterManager : NSObject

- (instancetype) initWithURL:(NSURL*)URL;
- (void) addVideoTrackWithSourceFormatDescription:(CMFormatDescriptionRef)formatDescription settings:(NSDictionary*)videoSettings;
- (void) addAudioTrackWithSourceFormatDescription:(CMFormatDescriptionRef)formatDescription settings:(NSDictionary*)audioSettings;
- (void) setDelegate:(id<AssetWriterManagerDelegate>)delegate callbackQueue:(dispatch_queue_t)delegateCallbackQueue;

- (void) prepareToRecord;
- (void) appendVideoSampleBuffer:(CMSampleBufferRef)sampleBuffer;
- (void) appendAudioSampleBuffer:(CMSampleBufferRef)sampleBuffer;
- (void) finishRecording;

@end

//============================================================================
@protocol AssetWriterManagerDelegate <NSObject>

- (void) writerCoordinatorDidFinishPreparing:(AssetWriterManager*)coordinator;
- (void) writerCoordinator:(AssetWriterManager*)coordinator didFailWithError:(NSError*)error;
- (void) writerCoordinatorDidFinishRecording:(AssetWriterManager*)coordinator;

@end
