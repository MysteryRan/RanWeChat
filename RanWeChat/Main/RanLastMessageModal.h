//
//  RanLastMessageModal.h
//  RanWeChat
//
//  Created by zouran on 2020/7/10.
//  Copyright © 2020 ran. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, MessageType) {
    MessageTypeSend,
    MessageTypeReceive,
};

typedef NS_ENUM(NSUInteger, MediaType) {
    MediaTypeText = 0,
    MediaTypePhoto,
    MediaTypeSystem,
};

@interface RanLastMessageModal : NSObject

@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *time;
@property (nonatomic, copy)NSString *content;
@property (nonatomic, copy)NSString *imageWidth;
@property (nonatomic, copy)NSString *imageHeight;

@property (nonatomic, assign)MediaType mediaType;
@property (nonatomic, assign)MessageType messageType;


@property (nonatomic, assign)CGFloat contentHeight;
@property (nonatomic, assign)CGFloat contentWidth;

+ (RanLastMessageModal *)initWithPlist:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
