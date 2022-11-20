//
//  ScreenCaptureWindowController.h
//  ScreenCaptureRender
//
//  Created by jt on 2022/11/19.
//

#ifndef ScreenCaptureWindowController_h
#define ScreenCaptureWindowController_h

#import <Cocoa/Cocoa.h>

@interface ScreenCaptureWindowController : NSWindowController

- (void)onBitmapDataChangedWithData:(void *)data
                          colorType:(int)color_type
                         dataLength:(int)data_length
                              width:(int)width
                             height:(int)height;
  

@end


#endif /* ScreenCaptureWindowController_h */
