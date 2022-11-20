//
//  ScreenRecoder.m
//  ScreenCaptureRender
//
//  Created by jt on 2022/11/19.
//

#import <Foundation/Foundation.h>
#import "ScreenRecorder.h"
#import <ScreenCaptureKit/ScreenCaptureKit.h>

@import ScreenCaptureKit;

@implementation ScreenRecorder

- (id)initWithCaptureListener:(ScreenCaptureWindowController*)listener {
  self = [super init];
  if (self) {
    self.listener = listener;
  }
  return self;
}

- (void)start {
  [SCShareableContent getShareableContentExcludingDesktopWindows:NO
                                             onScreenWindowsOnly:YES
                                               completionHandler:^(SCShareableContent *shareableContent, NSError *error) {
    if (error) {
      NSLog(@"getShareableContentExcludingDesktopWindows error: %@", error);
    } else {
      // prepare display
      NSArray<SCDisplay *> *displays = [shareableContent displays];
      for (SCDisplay *display in displays) {
        NSLog(@"display id: %d", display.displayID);
      }
      SCDisplay *display = displays[0];
      
      // prepare filter
      NSArray *emptyArray = [[NSArray alloc] init];
      SCContentFilter *filter = [[SCContentFilter alloc] initWithDisplay:display excludingWindows:emptyArray];
      
      NSAssert(filter, @"filter should not be null");
      
      // prepare scstream config
      SCStreamConfiguration *conf = [[SCStreamConfiguration alloc] init];
      [conf setWidth:1920];
      [conf setHeight:1080];
      [conf setScalesToFit:YES];
      [conf setDestinationRect:display.frame];
      [conf setShowsCursor:YES];
      [conf setQueueDepth:8];
      [conf setColorSpaceName:kCGColorSpaceDisplayP3];
      [conf setPixelFormat:'BGRA'];
      
      // prepare stream
      self.scstream = [[SCStream alloc] initWithFilter:filter configuration:conf delegate:nil];
      
      // set output
      NSError *err;
      [self.scstream addStreamOutput:self type:SCStreamOutputTypeScreen sampleHandlerQueue:nil error: &err];
      
      // start stream
      [self.scstream startCaptureWithCompletionHandler:^(NSError *_Nullable error) {
        if (error) {
          NSLog(@"err: %@", error);
        }
      }];
    }
  }];
}

- (void)stop {
  
}

- (void)stream:(SCStream *)stream didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer ofType:(SCStreamOutputType)type {
  CVImageBufferRef imgBufferRef = CMSampleBufferGetImageBuffer(sampleBuffer);
  // NSLog(@"===buffer===\n%@===image buffer===\n%@", sampleBuffer, imgBufferRef);
  if (imgBufferRef) {
    CVPixelBufferLockBaseAddress(imgBufferRef,0);
    
    uint8_t *baseAddress = (uint8_t *)CVPixelBufferGetBaseAddress(imgBufferRef);
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imgBufferRef);
    
    size_t width = CVPixelBufferGetWidth(imgBufferRef);
    size_t height = CVPixelBufferGetHeight(imgBufferRef);

    CVPixelBufferUnlockBaseAddress(imgBufferRef,0);
    
    [self.listener onBitmapDataChangedWithData:baseAddress
                                     colorType:0
                                    dataLength:(int)(width * height * 4)
                                         width:(int)(width)
                                        height:(int)(height)];
    // NSLog(@"bytesPerRow: %ld, width: %ld, height: %ld", bytesPerRow, width, height);
  }
}


@end

