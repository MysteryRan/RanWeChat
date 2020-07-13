//
//  RanTestHeaderCell.m
//  RanWeChat
//
//  Created by zouran on 2020/7/13.
//  Copyright © 2020 ran. All rights reserved.
//

#import "RanLastTalkHeaderCell.h"

@implementation RanLastTalkHeaderCell

-(NSFont *)font {
    return [NSFont fontWithName:@"Arial" size:22];
}

-(NSColor *)textColor {
    return [NSColor blackColor];
}

- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
    NSTableHeaderView *tableHeaderView = (NSTableHeaderView *)controlView;
    NSRect headerFrame = tableHeaderView.frame;
    [NSGraphicsContext saveGraphicsState];
    NSBezierPath *backgroundPath = [NSBezierPath bezierPathWithRect:headerFrame];
    NSGradient *backgroundGradient = [[NSGradient alloc] initWithColorsAndLocations:
                                      [NSColor whiteColor], 0.0,
                                      [NSColor whiteColor], 1.0,
                                      nil];
    [backgroundGradient drawInBezierPath:backgroundPath angle:90.0];
    [NSGraphicsContext restoreGraphicsState];
    
    // Draw text
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineBreakMode:NSLineBreakByWordWrapping];
    [style setAlignment:[self alignment]];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [self font], NSFontAttributeName,
                                style, NSParagraphStyleAttributeName, [self textColor], NSForegroundColorAttributeName, nil];
    NSRect stringRect = NSMakeRect(headerFrame.origin.x + 16,
                                   headerFrame.origin.y + 16,
                                   headerFrame.size.width - 12,
                                   headerFrame.size.height);
    
    [[self stringValue] drawInRect:stringRect withAttributes:attributes];
}

@end
