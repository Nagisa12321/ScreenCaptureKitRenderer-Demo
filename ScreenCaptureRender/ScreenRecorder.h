//
//  ScreenRecoder.h
//  ScreenCaptureRender
//
//  Created by jt on 2022/11/19.
//

#ifndef ScreenRecorder_h
#define ScreenRecorder_h

#import <SystemConfiguration/SystemConfiguration.h>
#import "ScreenCaptureWindowController.h"

@import ScreenCaptureKit;

@interface ScreenRecorder : NSObject<SCStreamOutput>

- (id)initWithCaptureListener:(ScreenCaptureWindowController*)listener;

- (void)start;

- (void)stop;

- (void)stream:(SCStream *)stream didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer ofType:(SCStreamOutputType)type;

@property SCStream *scstream;

@property ScreenCaptureWindowController* listener;

@end

#endif /* ScreenRecoder_h */
