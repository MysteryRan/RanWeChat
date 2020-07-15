//
//  RanLastMessageModal.m
//  RanWeChat
//
//  Created by zouran on 2020/7/10.
//  Copyright © 2020 ran. All rights reserved.
//

#import "RanLastMessageModal.h"
#import <AppKit/AppKit.h>

@implementation RanLastMessageModal

+ (RanLastMessageModal *)initWithPlist:(NSDictionary *)dic {
    RanLastMessageModal *message = [RanLastMessageModal new];
    message.name = dic[@"name"];
    message.content = dic[@"content"];
    message.time = dic[@"time"];
    message.imageWidth = dic[@"imageWidth"];
    message.imageHeight = dic[@"imageHeight"];
    message.mediaType = [self mediaTypeCheck:[dic[@"mediatype"] integerValue]];
    message.messageType = [self messageTypeCheck:[dic[@"messagetype"] integerValue]];
    CGFloat width = 0;
    CGFloat height = 0;
    if (message.mediaType == MediaTypeText) {
        width = [message.content boundingRectWithSize:CGSizeMake(MAXFLOAT, 72) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[NSFont systemFontOfSize:14]} context:nil].size.width;
        if (width > 280) {
            width = 280;
        }
        height = [message.content boundingRectWithSize:CGSizeMake(280, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[NSFont systemFontOfSize:14]} context:nil].size.height;
    } else if (message.mediaType == MediaTypePhoto) {
        width =  [dic[@"imageWidth"] floatValue];
        height = [dic[@"imageHeight"] floatValue];
        if (width > 280) {
            height = height / (width / 280);
            width = 280;
        }
    }
    message.contentHeight = height + 20;
    message.contentWidth = width;
    
    return message;
}

+ (MediaType)mediaTypeCheck:(NSInteger)str {
    if (str == 0) {
        return MediaTypeText;
    } else if (str == 1) {
        return MediaTypePhoto;
    }
    return MediaTypeSystem;
}

+ (MessageType)messageTypeCheck:(NSInteger)str {
    if (str == 1) {
        return MessageTypeReceive;
    }
    return MessageTypeSend;
}

@end
