//
//  RanPlayVideoController.m
//  RanWeChat
//
//  Created by zouran on 2020/7/30.
//  Copyright © 2020 ran. All rights reserved.
//

#import "RanPlayVideoController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

@interface RanPlayVideoController ()

@property (weak) IBOutlet AVPlayerView *playerView;

@end

@implementation RanPlayVideoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    self.playerView.player = [AVPlayer playerWithURL:[[NSBundle mainBundle] URLForResource:@"hubblecast" withExtension:@"m4v"]];
    self.playerView.showsSharingServiceButton = YES;
}

@end
