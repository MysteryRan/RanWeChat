//
//  RanTextView.m
//  RanWeChat
//
//  Created by zouran on 2020/7/13.
//  Copyright © 2020 ran. All rights reserved.
//

#import "RanTextView.h"

@interface RanTextView () <NSTextStorageDelegate>

@end

@implementation RanTextView

- (instancetype)initWithCoder:(NSCoder *)coder {
    self= [super initWithCoder:coder];
    
    if (self) {
        self.textStorage.delegate = self;
        
    }
    return self;
}




- (NSArray *)readablePasteboardTypes {
    return @[NSPasteboardTypeString, NSPasteboardTypeURL, NSPasteboardTypePNG,NSPasteboardTypeTIFF];
}


- (BOOL)readSelectionFromPasteboard:(NSPasteboard *)pboard type:(NSString *)type {
    
    NSArray *types = [pboard types];
    
    for (NSString *ev_type in types) {
        
        if ([ev_type isEqualToString:NSPasteboardTypePNG]) {
            
            NSData *imageData = [pboard dataForType:NSPasteboardTypePNG];
            NSImage *img = [[NSImage alloc]initWithData:imageData];
            if (img) {
                if ([self pasteImageToTextView:img]) {
                    return true;
                } else {
                    return false;
                }
            } else {
                return [super readSelectionFromPasteboard:pboard type:NSPasteboardTypeString];
            }
            
        } else if ([ev_type isEqualToString:NSPasteboardTypeTIFF]) {
            
            NSData *imageData = [pboard dataForType:NSPasteboardTypeTIFF];
            NSImage *img = [[NSImage alloc]initWithData:imageData];
            if (img) {
                if ([self pasteImageToTextView:img]) {
                    return true;
                } else {
                    return false;
                }
                
            } else {
                return [super readSelectionFromPasteboard:pboard type:NSPasteboardTypeString];
            }
            
        } else if ([ev_type isEqualToString:(NSString *) kUTTypeFileURL]) {
            
            NSURL *url = [NSURL URLFromPasteboard:pboard];
            NSString *filePath = url.relativePath;
            NSImage *image = [[NSImage alloc]initWithContentsOfFile:filePath];
            if (image) {
                if ([self pasteImageToTextView:image]) {
                    return true;
                } else {
                    return false;
                }
            } else {
                return [super readSelectionFromPasteboard:pboard type:NSPasteboardTypeString];
            }
            
        } else if ([ev_type isEqualToString:NSPasteboardTypeString]) {
            return [super readSelectionFromPasteboard:pboard type:NSPasteboardTypeString];
        }
    }
    return false;
}

- (BOOL)pasteImageToTextView:(NSImage *)image  {
    
    NSRange editeRange = self.rangeForUserCharacterAttributeChange;
    NSUInteger textLength = editeRange.location;
    
    // 图片处理 （测试）
//    NSSize imageNewSize = [self getSizeForDragImage:image];

    NSTextAttachmentCell *attachmentCell = [[NSTextAttachmentCell alloc] initImageCell:image];

    [attachmentCell setAlignment:NSTextAlignmentJustified];//NSTextAlignmentNatural];
    [attachmentCell setLineBreakMode:NSLineBreakByCharWrapping];
    
    
    NSTextAttachment *attachment = [NSTextAttachment new];
    [attachment setAttachmentCell: attachmentCell ];
    
    NSMutableAttributedString *attributedString = (NSMutableAttributedString*)[NSMutableAttributedString attributedStringWithAttachment:attachment];
    [attributedString addAttribute:NSFontAttributeName value:[NSFont systemFontOfSize:15] range:NSMakeRange(0, attributedString.length)];
    [[self textStorage] insertAttributedString:attributedString atIndex:textLength];
    [self setSelectedRange:NSMakeRange(textLength, 1)];
    [self.layoutManager ensureLayoutForTextContainer:self.textContainer];
    
    return true;
}
@end
