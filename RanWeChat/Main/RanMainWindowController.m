//
//  RanMainWindowController.m
//  RanWeChat
//
//  Created by zouran on 2020/7/9.
//  Copyright © 2020 ran. All rights reserved.
//

#import "RanMainWindowController.h"

@interface RanMainWindowController ()

@property (nonatomic, strong)NSArray *buttons;

@end

@implementation RanMainWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    self.window.title = @"Eiisys IM";
    self.window.titlebarAppearsTransparent = YES;
    self.window.titleVisibility = NSWindowTitleHidden;
    
    // drag area
    self.window.movableByWindowBackground = YES;
    
    [self updateTitleBarOfWindow:self.window fullScreen:NO];
    [self.buttons arrayByAddingObject:[self.window standardWindowButton:NSWindowCloseButton]];
    [self.buttons arrayByAddingObject:[self.window standardWindowButton:NSWindowMiniaturizeButton]];
    [self.buttons arrayByAddingObject:[self.window standardWindowButton:NSWindowZoomButton]];
    
    
}

- (void)standardWindowButtonHidden:(BOOL)hidden {
    [[self.window standardWindowButton:NSWindowCloseButton] setHidden:hidden];
    [[self.window standardWindowButton:NSWindowMiniaturizeButton] setHidden:hidden];
    [[self.window standardWindowButton:NSWindowZoomButton] setHidden:hidden];
}

- (void)updateTitleBarOfWindow:(NSWindow *)window fullScreen:(BOOL)fullScreen {
    //    CGFloat kFullScreenButtonYOrigin = 3.0;
    CGRect windowFrame = window.frame;
    NSView *titlebarContainerView = [window standardWindowButton:NSWindowCloseButton].superview.superview;
    titlebarContainerView.wantsLayer = YES;
    titlebarContainerView.needsDisplay = YES;
    CGRect titlebarContainerFrame = titlebarContainerView.frame;
    
//    NSView *buttomBgView = [[NSView alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
//    buttomBgView.wantsLayer = YES;
//    buttomBgView.layer.backgroundColor = [[NSColor redColor] CGColor];
//    buttomBgView.needsDisplay = YES;
//    [titlebarContainerView addSubview:buttomBgView];
    
    titlebarContainerFrame.origin.y = windowFrame.size.height - 30.0;
    titlebarContainerFrame.size.height = 30.0;
    titlebarContainerView.frame = titlebarContainerFrame;
    
    CGFloat buttonX = 3;
    
    NSButton *closeButton = [window standardWindowButton:NSWindowCloseButton];
    NSButton *minimizeButton = [window standardWindowButton:NSWindowMiniaturizeButton];
    NSButton *zoomButton = [window standardWindowButton:NSWindowZoomButton];
    
    for (NSButton *buttonView in @[closeButton,minimizeButton,zoomButton]) {
        CGRect btnFrame = buttonView.frame;
        
        CGFloat f = round(30 - btnFrame.size.height) / 2.0;
        btnFrame.origin.y = f;
        btnFrame.origin.x = buttonX;
        buttonX = btnFrame.size.width + 5 + buttonX;
        buttonView.frame = CGRectMake(btnFrame.origin.x, btnFrame.origin.y, btnFrame.size.width, btnFrame.size.height);
    }
}

- (void)windowDidEnterFullScreen:(NSNotification *)notification {
    [self updateTitleBarOfWindow:self.window fullScreen:true];
}

- (void)windowDidExitFullScreen:(NSNotification *)notification {
    [self updateTitleBarOfWindow:self.window fullScreen:NO];
    for (NSButton *btn in self.buttons) {
        btn.hidden = NO;
    }
}

- (void)windowDidResize:(NSNotification *)notification {
    [self updateTitleBarOfWindow:self.window fullScreen:NO];
}

@end
