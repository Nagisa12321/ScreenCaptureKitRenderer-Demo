//
//  ScreenCaptureWindowController.m
//  ScreenCaptureRender
//
//  Created by jt on 2022/11/19.
//

#import <Foundation/Foundation.h>
#import "ScreenCaptureWindowController.h"
#import "ScreenRecorder.h"
#import <Metal/Metal.h>
#import "MetalViewRenderer.h"

@import MetalKit;

@interface ScreenCaptureWindowController ()

@property ScreenRecorder* recorder;

@property MTKView* mtkView;

@property MetalViewRenderer* renderer;

@end

@implementation ScreenCaptureWindowController

- (void)windowDidLoad {
  // [super windowDidLoad];
  NSAssert(self.window, @"The window should not be nil");
  NSLog(@"window did loaded");
  
  // window config
  [self.window setBackgroundColor:[NSColor colorWithCalibratedWhite:1.0 alpha:0.0f]];
  [self.window setOpaque:NO];
  [self.window setCollectionBehavior:NSWindowCollectionBehaviorCanJoinAllSpaces];
  [self.window setHasShadow:NO];
  [self.window orderFront:self];
  [self.window makeKeyWindow];
  [self.window.contentView setNeedsUpdateConstraints:YES];
  [self.window setIgnoresMouseEvents:NO];
//  [self.window setTitleVisibility:NSWindowTitleHidden];
//  [self.window setTitlebarAppearsTransparent:YES];
//  [self.window setStyleMask:NSBorderlessWindowMask];

  // mtk view
  self.mtkView = (MTKView *)self.window.contentView;
  [self.mtkView setClearColor:MTLClearColorMake(.0, .0, .0, 0.0)];
  // [self.mtkView.layer setOpaque:NO];
  self.mtkView.device = MTLCreateSystemDefaultDevice();
  NSAssert(self.mtkView.device, @"Metal is not supported on this device");
  
  // renderer
  self.renderer = [[MetalViewRenderer alloc] initWithMetalKitView:self.mtkView];
  [self.renderer  mtkView:self.mtkView drawableSizeWillChange:self.mtkView.drawableSize];
  NSAssert(self.renderer, @"Renderer failed initialization");
  self.mtkView.delegate = self.renderer;
  
  // recorder
  self.recorder = [[ScreenRecorder alloc] initWithCaptureListener:self];
  [self.recorder start];
}

- (void)windowWillClose:(NSNotification *)notification {
}


- (void)onBitmapDataChangedWithData:(void *)data
                          colorType:(int)color_type
                         dataLength:(int)data_length
                              width:(int)width
                             height:(int)height {
  [self.renderer loadTextureWithData:data width:width height:height];
  [self.mtkView draw];
  // [_renderer drawInMTKView:_view];
}

@end
