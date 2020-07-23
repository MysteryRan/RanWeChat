//
//  RanChatImageView.m
//  RanWeChat
//
//  Created by zouran on 2020/7/17.
//  Copyright © 2020 ran. All rights reserved.
//

#import "RanChatImageView.h"

@interface RanChatImageView()<NSPasteboardItemDataProvider, NSDraggingSource>

@end

@implementation RanChatImageView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    /*
     ltopApoint == 上面的点
     ABNodepoint ==  凸出来的点
     bpoint == 下面的点
     https://blog.csdn.net/fengsh998/article/details/18661177
     */
    
    NSBezierPath *bezier = [NSBezierPath bezierPath];
    bezier = [self makeBubble:bezier withBubbleRect:NSMakeRect(5, 0, self.bounds.size.width - 5, self.bounds.size.height) corner:4 atPostion:1];

//    [[NSColor greenColor]set];
//    [bezier fill];

    [[NSColor whiteColor]set];
    [bezier stroke];
    // Drawing code here.
    NSGraphicsContext *context = [NSGraphicsContext currentContext];

        // Rectangle Drawing
    [context saveGraphicsState];
    [bezier addClip];
    [_contentImage drawInRect:self.bounds];
    [context restoreGraphicsState];
}

/*
    支持微调气泡
 atPostion:是指小尖角位置，左上 = 1，左下 = 2，右上 = 3，右下 = 4
 */
- (NSBezierPath *)makeBubble:(NSBezierPath *) bezierPath
              withBubbleRect:(NSRect)rect
                      corner:(CGFloat)corner
                   atPostion:(NSInteger)pos
{
    //基本偏角40度,正好是引出小三角的位置
    CGFloat baseAngle = 90;
    
    CGFloat cornetOffWidth  = 10;
//    CGFloat cornetOffHeight = 5;
    
    //注angle只设定三个值0, 10，40
    /*
        0: 说明现在小三角相对于矩开来说，已看不出来了，这里直接用直角
        10:说明此时的小三解效果效好
        40:说明此时的矩开和小三角太小，需要调到40度有有效果。
        这三个值会自动的根据外部 corner 参数进行调整
     */
    CGFloat angle = 10;
    
    BOOL midCorner = NO;
    
    //矩形的宽和高
    CGFloat rw = CGRectGetWidth(rect);
    CGFloat rh = CGRectGetHeight(rect);
    
    //最小长度
    CGFloat minDiameter = rw > rh ? rh : rw;

    CGFloat radius = 0;//半径
    if (corner > 0)
    {
        radius = corner > minDiameter / 2 ? minDiameter / 2 : corner;
    }
    //最小长度与圆角比
    CGFloat rate = radius / minDiameter;

    //在下角坐标，
    NSPoint leftBottom      = NSMakePoint(CGRectGetMinX(rect), CGRectGetMinY(rect));
    NSPoint leftBottomX     = NSMakePoint(leftBottom.x + radius, leftBottom.y);
    NSPoint leftBottomY     = NSMakePoint(leftBottom.x, leftBottom.y + radius);
    
    NSPoint rightBottom     = NSMakePoint(CGRectGetMaxX(rect), CGRectGetMinY(rect));
    NSPoint rightBottomX    = NSMakePoint(rightBottom.x - radius, rightBottom.y);
    NSPoint rightBottomY    = NSMakePoint(rightBottom.x, rightBottom.y + radius);
    
    NSPoint rightTop = NSMakePoint(CGRectGetMaxX(rect), CGRectGetMaxY(rect));
    NSPoint rightTopX = NSMakePoint(rightTop.x - radius, rightTop.y);
    NSPoint rightTopY = NSMakePoint(rightTop.x, rightTop.y - radius);
    
    
    NSPoint leftTop = NSMakePoint(CGRectGetMinX(rect), CGRectGetMaxY(rect));
    NSPoint leftTopX = NSMakePoint(leftTop.x + radius, leftTop.y);
    NSPoint leftTopY = NSMakePoint(leftTop.x, leftTop.y - radius);


    //最小高度在30以下的，只需要在左或右画三角即可
    if (minDiameter < 30 )
    {
        if (rate > 0.33 && rate <= 0.5)
        {
            angle = 40;
        }
        else //在中间画直角
        {
            angle = 0;
            midCorner = YES;
        }
    }
    else if (minDiameter >= 30 && minDiameter <= 50)
    {
        if (rate > 0.2 && rate < 0.4)
        {
            angle = 40;
        }
        else if (rate >= 0.4 && rate <= 0.5)
        {
            angle = 10; //直角
        }
        else
        {
            angle = 0;
        }
    }
    else // 50 以上的
    {
        if (corner >=10 && corner <= 15)
        {
            angle = 40;
        }
        else if (corner < 10)
        {
            angle = 0; //直角
        }
    }

    //Ａ，Ｂ点引线出来产生尖角的结点(即绘制的起始点)
    NSPoint ABNodepoint = NSMakePoint(0, 0);
    NSPoint Apoint = NSMakePoint(0, 0);
    NSPoint Bpoint = NSMakePoint(0, 0);
    
    //上半部分
    CGFloat autoOffUpHeight = 0;
    //下半部份
    CGFloat autoOffDownHeight = 0;
    
    switch (pos) {
        default: //左上
        {
            if ((angle == 10) || (angle == 40))
            {
                ABNodepoint = NSMakePoint(leftTop.x - cornetOffWidth, leftTop.y);
            }
            else {
                if (rh <=30)
                {
                    autoOffDownHeight = (rh- 2*radius - 10) / 2;
                    autoOffUpHeight = autoOffDownHeight;
                    Apoint = NSMakePoint(leftTopY.x,leftTopY.y - autoOffDownHeight);
                    Bpoint = NSMakePoint(leftBottomY.x,leftBottomY.y + autoOffUpHeight);
                }
                else
                {
                    autoOffUpHeight = (rh- 2*radius) / 30;//30 :1 的比例进行(按1：29比例平分高度)
                    autoOffUpHeight = autoOffUpHeight > 10 ? 10 : autoOffUpHeight;
                    autoOffDownHeight = (rh- 2*radius) - autoOffUpHeight;
                    
                    Apoint = NSMakePoint(leftTopY.x,leftTopY.y - autoOffUpHeight );
                    Bpoint = NSMakePoint(leftBottomY.x,leftBottomY.y + autoOffDownHeight - 10);
                }
                
                ABNodepoint = NSMakePoint(0, (Apoint.y + Bpoint.y) / 2);
            }
        }
            break;
    }

    NSPoint rightTopCenter =NSMakePoint(CGRectGetMaxX(rect) - radius,CGRectGetMaxY(rect) - radius);
    NSPoint leftTopCenter =NSMakePoint(CGRectGetMinX(rect) + radius,CGRectGetMaxY(rect) - radius);
    NSPoint leftBottomCenter =NSMakePoint(CGRectGetMinX(rect) + radius,CGRectGetMinY(rect) + radius);
    NSPoint rightBottomCenter =NSMakePoint(CGRectGetMaxX(rect) - radius,CGRectGetMinY(rect) + radius);
    
    //A点引出点的位置
    CGFloat Ax = radius * cos((90 - baseAngle - angle)*M_PI/180);
    CGFloat Ay = radius * sin((90 - baseAngle - angle)*M_PI/180);
    
    //B点引出点的位置
    CGFloat Bx = radius * cos(baseAngle*M_PI/180);
    CGFloat By = radius * sin(baseAngle*M_PI/180);
    
    //左上角缺口位置A,B点坐标
    NSPoint lTopApoint = NSMakePoint(leftTopX.x - By,leftTopY.y + Bx);
    
//    NSPoint lTopBpoint = NSMakePoint(leftTopX.x - Ax,leftTopY.y + Ay);//(闭环结点)

    
    //按顺时针顺序进行绘制
    switch (pos) {
        default:
        {
            //绘制启始点
            [bezierPath moveToPoint:ABNodepoint];
            if (angle != 0)
            {
                //绘到缺角B坐标点
                [bezierPath lineToPoint:lTopApoint];
                //绘制右下角缺角B点下半部的圆解部分
                [bezierPath appendBezierPathWithArcWithCenter:leftTopCenter radius:radius
                                                   startAngle:(90+baseAngle)
                                                     endAngle:90
                                                    clockwise:YES];
            }
            else
            {
                [bezierPath lineToPoint:Apoint];
                //左上半圆
                [self drawLeftTopPart:leftTopCenter withRadius:radius addToBezierPath:bezierPath];
            }
            
            //右上半圆
            [self drawRightTopPart:rightTopCenter withRadius:radius addToBezierPath:bezierPath];
            //右下半圆
            [self drawRightBottomPart:rightBottomCenter withRadius:radius addToBezierPath:bezierPath];
            //左下半圆
            [self drawLeftBottomPart:leftBottomCenter withRadius:radius addToBezierPath:bezierPath];
            
            if (angle != 0)
            {
                [bezierPath appendBezierPathWithArcWithCenter:leftTopCenter radius:radius
                                                   startAngle:180
                                                     endAngle:(90+baseAngle+angle)
                                                    clockwise:YES];
            }
            else
            {
                [bezierPath lineToPoint:Bpoint];
            }
        }
            break;
    }
    
    [bezierPath closePath];

    return bezierPath;
}

//根据绘制点进行组合
//左下半圆
- (void)drawLeftBottomPart:(NSPoint) cornerCenter withRadius:(CGFloat)radius addToBezierPath:(NSBezierPath *) bezierPath
{
    
    [bezierPath appendBezierPathWithArcWithCenter:cornerCenter radius:radius
                                       startAngle:-90
                                         endAngle:-180
                                        clockwise:YES];
}

//左上半圆
- (void)drawLeftTopPart:(NSPoint) cornerCenter withRadius:(CGFloat)radius addToBezierPath:(NSBezierPath *) bezierPath
{
    
    [bezierPath appendBezierPathWithArcWithCenter:cornerCenter radius:radius
                                       startAngle:180 //or -180
                                         endAngle:90  // or - 270
                                        clockwise:YES];
}

//右上半圆
- (void)drawRightTopPart:(NSPoint) cornerCenter withRadius:(CGFloat)radius addToBezierPath:(NSBezierPath *) bezierPath
{
    [bezierPath appendBezierPathWithArcWithCenter:cornerCenter radius:radius
                                       startAngle:90
                                         endAngle:0
                                        clockwise:YES];
}

//右下半圆
- (void)drawRightBottomPart:(NSPoint) cornerCenter withRadius:(CGFloat)radius addToBezierPath:(NSBezierPath *) bezierPath
{
    [bezierPath appendBezierPathWithArcWithCenter:cornerCenter radius:radius
                                       startAngle:0
                                         endAngle:270
                                        clockwise:YES];
}


// 拖拽功能
//是否必须是活动窗口才能拖拽，YES非活动窗口也能拖拽，NO必须是活动窗口才能拖拽
- (BOOL)acceptsFirstMouse:(NSEvent *)event
{
     return YES;
}

// 用户鼠标点击 NSView/NSWindow 触发 mouseDown: 事件, 调用 beginDraggingSessionWithItems 方法
// 开始建立一个拖放的session, 开始启动拖放过程。
- (void)mouseDown:(NSEvent*)event
{
    /* 使用 NSPasteboardItem 定义拖放携带的基本数据信息 */
    NSPasteboardItem *pbItem = [[NSPasteboardItem alloc] init];
    
    /* 设置代理，定义哪些类型拖拽的时候会执行 NSPasteboardItemDataProvider 的代理方法 */
    [pbItem setDataProvider:self forTypes:@[NSFilenamesPboardType, NSPasteboardTypeString]];

    /* 用 NSDraggingItem 包装 NSPasteboardItem */
    NSDraggingItem *dragItem = [[NSDraggingItem alloc] initWithPasteboardWriter:pbItem];
    NSImage *image;
    /* 拖放可视化定义, 定义拖放过程中的跟随鼠标移动的图像 */
    if (self.contentImage != nil) {
        image = [self viewCapture];
    } else {
        image = [NSImage imageNamed:@"message_bubble_right"];
    }
    [dragItem setDraggingFrame:NSMakeRect(0, 0, image.size.width, image.size.height) contents:image];
    /* 建立一个拖放的 session */
    NSDraggingSession *draggingSession = [self beginDraggingSessionWithItems:@[dragItem] event:event source:self];
    
    /* 拖拽失败后是否返回动画，YES有动画，NO无动画 */
    draggingSession.animatesToStartingPositionsOnCancelOrFail = YES;
//    draggingSession.draggingFormation = NSDraggingFormationNone;
}

#pragma mark - NSDraggingSource
//设置接收拖拽的目的地的图标样式
- (NSDragOperation)draggingSession:(NSDraggingSession *)session sourceOperationMaskForDraggingContext:(NSDraggingContext)context
{
    switch (context)
    {
        case NSDraggingContextOutsideApplication://app外
            return NSDragOperationCopy;
        case NSDraggingContextWithinApplication://app内
            return NSDragOperationNone;
        default://其余情况
            return NSDragOperationNone;
            break;
    }
}

//屏幕截图
- (NSImage *)viewCapture
{
//    NSImage *viewImage = [[NSImage alloc] initWithData:[self dataWithPDFInsideRect:self.bounds]];
//    [self lockFocus];
//    NSBitmapImageRep *screenRep = [[NSBitmapImageRep alloc] initWithFocusedViewRect:self.bounds];
//    [self unlockFocus];
//    [viewImage addRepresentation:screenRep];
//    return viewImage;
    
    //上面屏蔽掉的不知道为啥不行
    NSBitmapImageRep *imageRep = [self bitmapImageRepForCachingDisplayInRect: self.bounds];
    [self cacheDisplayInRect: self.bounds toBitmapImageRep: imageRep];
    NSImage *viewImage = [[NSImage alloc] initWithCGImage: [imageRep CGImage] size: self.bounds.size];
    return viewImage;
}

#pragma mark -- NSPasteboardItemDataProvider

- (void)pasteboard:(nullable NSPasteboard *)pasteboard item:(NSPasteboardItem *)item provideDataForType:(NSString *)type
{
    if ([type compare:NSPasteboardTypeString] == NSOrderedSame)
    {
        [pasteboard setString:@"hello world！" forType:NSPasteboardTypeString];
    }
    else if ([type compare:NSFilenamesPboardType] == NSOrderedSame)
    {
        [pasteboard setData:[NSData dataWithContentsOfFile:@"/Users/yuedongkui/Desktop/aaa.gif"] forType:NSFilenamesPboardType];
//        [pasteboard setPropertyList:@[] forType:NSFilenamesPboardType];//多文件时
    }
}


@end
