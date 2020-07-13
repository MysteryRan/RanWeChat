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
    message.mediaType = [self mediaTypeCheck:[dic[@"messagetype"] integerValue]];
    message.messageType = [self messageTypeCheck:[dic[@"messagetype"] integerValue]];
    CGFloat width1 = [message.content boundingRectWithSize:CGSizeMake(MAXFLOAT, 72) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[NSFont systemFontOfSize:14]} context:nil].size.width;
    if (width1 > 280) {
        width1 = 280;
    }
    CGFloat height = [message.content boundingRectWithSize:CGSizeMake(280, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[NSFont systemFontOfSize:14]} context:nil].size.height;
    NSLog(@" 宽 %lf======= 高  %lf",width1, height);
    message.contentHeight = height + 20;
    message.contentWidth = width1;
    
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
