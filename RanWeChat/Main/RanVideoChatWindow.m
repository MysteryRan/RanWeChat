//
//  RanVideoChatWindow.m
//  RanWeChat
//
//  Created by zouran on 2020/7/9.
//  Copyright © 2020 ran. All rights reserved.
//

#import "RanVideoChatWindow.h"
#import "RanVideChatController.h"

@interface RanVideoChatWindow ()<NSWindowDelegate>

@end

@implementation RanVideoChatWindow

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    
}

- (void)close {
    RanVideChatController *controller = (RanVideChatController *)self.contentViewController;
    [controller.capture stopCapture];
}

- (void)windowWillClose:(NSNotification *)notification {
    
}


@end
