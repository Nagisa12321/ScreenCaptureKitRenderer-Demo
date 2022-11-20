//
//  AppDelegate.m
//  ScreenCaptureRender
//
//  Created by jt on 2022/11/19.
//

#import "AppDelegate.h"
#import "ScreenCaptureWindowController.h"

@interface AppDelegate ()

@property (strong) IBOutlet NSWindow *window;

@property (strong) ScreenCaptureWindowController *screenCaptureWC;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
  // Insert code here to initialize your application
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(windowWillClose:)
                                               name:NSWindowWillCloseNotification
                                             object:self.window];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
  // Insert code here to tear down your application
}


- (BOOL)applicationSupportsSecureRestorableState:(NSApplication *)app {
  return YES;
}

- (IBAction)startScreenCaptureDidClicked:(id)sender {
  NSLog(@"screen capture start");
  
  if (!self.screenCaptureWC) {
    self.screenCaptureWC = [[ScreenCaptureWindowController alloc] initWithWindowNibName:@"ScreenCaptureWindowController"];
    [self.screenCaptureWC showWindow:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(screenCaptureWindowWillClose:)
                                                 name:NSWindowWillCloseNotification
                                               object:self.screenCaptureWC.window];
  }
}

- (void)screenCaptureWindowWillClose:(NSNotification *)notification {
  self.screenCaptureWC = nil;
}

- (void)windowWillClose:(NSNotification *)notification {
  [NSApp stop:nil];
}

@end
