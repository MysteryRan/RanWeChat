//
//  RanHeaderWindowController.m
//  RanWeChat
//
//  Created by zouran on 2020/7/27.
//  Copyright © 2020 ran. All rights reserved.
//

#import "RanHeaderWindowController.h"

@interface RanHeaderWindowController ()

@end

@implementation RanHeaderWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    
}

- (void)loadWindow {
    [super windowDidLoad];
}

- (void)showWindow:(id)sender {
    [super showWindow:sender];
    [self.window setFrameOrigin:NSPointFromCGPoint(CGPointMake(self.parentRect.origin.x + 54, self.parentRect.origin.y + 500))];
}

@end
