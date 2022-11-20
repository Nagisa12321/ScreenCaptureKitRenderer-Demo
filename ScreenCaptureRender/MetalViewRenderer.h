//
//  MetalViewRenderer.h
//  TestWhiteBoardSDK
//
//  Created by jt on 2022/11/12.
//  Copyright © 2022 tencent. All rights reserved.
//

#ifndef MetalViewRenderer_h
#define MetalViewRenderer_h

#import <Cocoa/Cocoa.h>
#import <Metal/Metal.h>

@import MetalKit;

// The platform independent renderer class
@interface MetalViewRenderer : NSObject<MTKViewDelegate>

- (nonnull instancetype)initWithMetalKitView:(nonnull MTKView *)mtkView;

- (void)loadTextureWithData:(nonnull void *)data
                      width:(int)w
                     height:(int)h;


@end



#endif /* MetalViewRenderer_h */
