//
//  RanDragTableView.m
//  RanWeChat
//
//  Created by zouran on 2020/7/14.
//  Copyright © 2020 ran. All rights reserved.
//

#import "RanDragTableView.h"

@interface RanDragTableView()

@property(nonatomic, assign)BOOL isDragIn;

@property(nonatomic)NSPoint beginPoint;

@end

@implementation RanDragTableView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    [self registerForDraggedTypes:[NSArray arrayWithObject:NSFilenamesPboardType]];    
    // Drawing code here.
    if (self.isDragIn) {
        if ([self.dragDelegate respondsToSelector:@selector(dragMoveIn)]) {
            [self.dragDelegate dragMoveIn];
        }
    }
}

- (NSDragOperation)draggingEntered:(id)sender {
    _isDragIn=YES;
    NSPasteboard *pastedboard = [sender draggingPasteboard];
    if ([[pastedboard types] containsObject:NSFilenamesPboardType]) {
        return NSDragOperationCopy;
    }
    
    return NSDragOperationNone;
}

- (void)draggingExited:(nullable id <NSDraggingInfo>)sender {
    _isDragIn=NO;
    [self setNeedsDisplay:YES];
    NSRect  selfRect = [self convertRect:self.frame toView:nil];
    
    if (NSEvent.mouseLocation.x < selfRect.origin.x || NSEvent.mouseLocation.x > (selfRect.origin.x + selfRect.size.width) || NSEvent.mouseLocation.y > (selfRect.origin.y + selfRect.size.height)) {
        if ([self.dragDelegate respondsToSelector:@selector(dragMoveOut)]) {
            [self.dragDelegate dragMoveOut];
        }
    } else {
        
    }
}


- (BOOL)prepareForDragOperation:(id)sender {
    NSPasteboard *pastedBoard = [sender draggingPasteboard];
    NSArray *typeList = [pastedBoard propertyListForType:NSFilenamesPboardType];
    
    NSLog(@"ppppp %@",typeList);
    _isDragIn=NO;
    [self setNeedsDisplay:YES];
    return YES;
}

- (void)draggingEnded:(id<NSDraggingInfo>)sender {
    NSRect  selfRect = [self convertRect:self.frame toView:nil];
    if (NSEvent.mouseLocation.x > selfRect.origin.x && NSEvent.mouseLocation.x < (selfRect.origin.x + selfRect.size.width) && NSEvent.mouseLocation.y < (selfRect.origin.y + selfRect.size.height) && NSEvent.mouseLocation.y > selfRect.origin.y) {
        NSArray* filePaths = [[sender draggingPasteboard] propertyListForType:NSFilenamesPboardType];
        if ([self.dragDelegate respondsToSelector:@selector(dragDown:)]) {
            [self.dragDelegate dragDown:filePaths];
        }
    }
}

- (void)drawContextMenuHighlightForRow:(NSInteger)row {

}

- (void)mouseDown:(NSEvent *)event {
//    NSLog(@"--->");
//    NSLog(@"%@", NSStringFromPoint([NSEvent mouseLocation]));
    self.beginPoint = [NSEvent mouseLocation];
}


- (void)mouseUp:(NSEvent *)event {
    NSLog(@"up uop uop up");
    NSLog(@"%@", NSStringFromPoint([NSEvent mouseLocation]));
    // 开始画线
}

- (void)mouseMoved:(NSEvent *)event {
    
}



@end
