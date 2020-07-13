//
//  RanLoginViewController.m
//  RanWeChat
//
//  Created by zouran on 2020/7/9.
//  Copyright © 2020 ran. All rights reserved.
//

#import "AppDelegate.h"
#import "RanLoginViewController.h"
#import "RanMainWindowController.h"

@interface RanLoginViewController ()

@end

@implementation RanLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    self.view.wantsLayer = YES;
    self.view.layer.backgroundColor = [NSColor whiteColor].CGColor;
}


- (IBAction)loginClick:(NSButton *)sender {
    NSStoryboard *storyboard = [NSStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    RanMainWindowController *imWindowController = [storyboard instantiateControllerWithIdentifier:@"ran"];
    
    [imWindowController.window setAnimationBehavior:NSWindowAnimationBehaviorDocumentWindow];
    [imWindowController.window makeFirstResponder:nil];
    AppDelegate *appDelegate = (AppDelegate *)[NSApplication sharedApplication].delegate;
    appDelegate.mainWindowController = imWindowController;
    [imWindowController.window makeKeyAndOrderFront:nil];
    [self.view.window orderOut:self];
    
}

@end
