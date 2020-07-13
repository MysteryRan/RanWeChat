//
//  RanContactCell.m
//  myWeChat
//
//  Created by zouran on 2019/6/20.
//  Copyright © 2019 ran. All rights reserved.
//

#import "RanContactCell.h"

@interface RanContactCell(){
    NSMenu *menu;
}

@property (weak) IBOutlet NSTextField *nameLab;
@property (weak) IBOutlet NSTextField *timeLab;
@property (weak) IBOutlet NSTextField *messageLab;
@property (weak) IBOutlet NSView *bottomLine;

@end

@implementation RanContactCell

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    self.bottomLine.wantsLayer = YES;
    self.bottomLine.layer.backgroundColor = [NSColor lightGrayColor].CGColor;
}

// 重写这个方法 在选中时 label的颜色就不会改变了 不然会出现颜色反转
- (void)setBackgroundStyle:(NSBackgroundStyle)backgroundStyle {
    [super setBackgroundStyle:backgroundStyle];
//    self.nameLab.textColor = (backgroundStyle == NSBackgroundStyleLight ? [NSColor textColor] : [NSColor textColor]);
//    self.timeLab.textColor = (backgroundStyle == NSBackgroundStyleLight ? [NSColor textColor] : [NSColor textColor]);
//    self.messageLab.textColor = (backgroundStyle == NSBackgroundStyleLight ? [NSColor textColor] : [NSColor textColor]);
}

- (void)setModal:(RanLastMessageModal *)modal {
    _modal = modal;
    self.nameLab.stringValue = modal.name;
    self.timeLab.stringValue = modal.time;
    self.messageLab.stringValue = modal.content;

}




//-(void)rightMouseDown:(NSEvent *)event {
//    [super rightMouseDown:event];
//     [NSMenu popUpContextMenu:menu withEvent:event forView:self];
//
//}

//-(void)handleItem:(NSMenuItem *)item{
//    NSLog(@"123");
////    item.state = item.state == NSControlStateValueOn ? NSControlStateValueOff : NSControlStateValueOn;
//    if ([self.delegate respondsToSelector:@selector(cooking)]) {
//        return [self.delegate cooking];
//    }
//}


@end
