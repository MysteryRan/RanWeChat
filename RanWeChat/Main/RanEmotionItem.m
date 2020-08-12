//
//  RanEmotionItem.m
//  RanWeChat
//
//  Created by zouran on 2020/7/22.
//  Copyright © 2020 ran. All rights reserved.
//

#import "RanEmotionItem.h"

@interface RanEmotionItem ()

@end

@implementation RanEmotionItem

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
//    self.view.wantsLayer = YES;
//    self.view.layer.backgroundColor = [NSColor redColor].CGColor;
}

- (void)drawRect:(NSRect)dirtyRect {
//    [super drawRect:dirtyRect];
    NSLog(@"===>");
//    NSColor*    bgColor         = [[self.view window] backgroundColor];
    NSColor*    bgColor         = [NSColor redColor];
//    NSColor*    highlightColor  = [NSColor selectedControlColor];
    NSColor*    highlightColor  = [NSColor greenColor];

    NSRect  frame  = self.view.bounds;
    NSCollectionViewItemHighlightState  hlState     = [self highlightState];
    BOOL                                selected    = [self isSelected];
    if ((hlState == NSCollectionViewItemHighlightForSelection) || (selected))
    {
        [highlightColor setFill];
    }
    else
    {
        [bgColor setFill];
    }
    [NSBezierPath fillRect:frame];
}

@end
