//
//  RanChatRightImageView.m
//  RanWeChat
//
//  Created by zouran on 2020/7/17.
//  Copyright © 2020 ran. All rights reserved.
//

#import "RanChatRightImageView.h"

@implementation RanChatRightImageView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    NSBezierPath *bezier = [NSBezierPath bezierPath];
    bezier = [self makeBubble:bezier withBubbleRect:NSMakeRect(0, 0, self.bounds.size.width, self.bounds.size.height) corner:4 atPostion:3];

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
    CGFloat baseAngle = 40;
    
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


    //最小高度在30以下的，只需要在左或右画三解即可
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
        case 2: //左下
        {
            if ((angle == 10) || (angle == 40)) {
                ABNodepoint = NSMakePoint(leftBottom.x - cornetOffWidth, leftBottom.y);
            }
            else
            {
                if (rh <= 30)
                {
                    autoOffDownHeight = (rh- 2*radius - 10) / 2;
                    autoOffUpHeight = autoOffDownHeight;
                    Apoint = NSMakePoint(leftTopY.x,leftTopY.y - autoOffUpHeight);
                    Bpoint = NSMakePoint(leftBottomY.x,leftBottomY.y + autoOffDownHeight);
                }
                else
                {
                    autoOffDownHeight = (rh- 2*radius) / 30;//30 :1 的比例进行(按1：29比例平分高度)
                    autoOffDownHeight = autoOffDownHeight > 10 ? 10 : autoOffDownHeight;
                    autoOffUpHeight = (rh- 2*radius) - autoOffDownHeight;
                    
                    Apoint = NSMakePoint(leftTopY.x,leftTopY.y - autoOffUpHeight + 10);
                    Bpoint = NSMakePoint(leftBottomY.x,leftBottomY.y + autoOffDownHeight);
                }
                
                ABNodepoint = NSMakePoint(leftBottom.x - cornetOffWidth, (Apoint.y + Bpoint.y) / 2);
            }
        }
            break;
        case 3: //右上
        {
            if ((angle == 10) || (angle == 40)) {
                ABNodepoint = NSMakePoint(rightTop.x + cornetOffWidth, rightTop.y);
            }
            else
            {
                if (rh <=30)
                {
                    autoOffDownHeight = (rh- 2*radius - 10) / 2;
                    autoOffUpHeight = autoOffDownHeight;
                    Apoint = NSMakePoint(rightTopY.x,rightTopY.y - autoOffDownHeight);
                    Bpoint = NSMakePoint(rightBottomY.x,rightBottomY.y + autoOffUpHeight);
                }
                else
                {
                    autoOffUpHeight = (rh- 2*radius) / 30;//30 :1 的比例进行(按1：29比例平分高度)
                    autoOffUpHeight = autoOffUpHeight > 10 ? 10 : autoOffUpHeight;
                    autoOffDownHeight = (rh- 2*radius) - autoOffUpHeight;
                    
                    Apoint = NSMakePoint(rightTopY.x,rightTopY.y - autoOffUpHeight );
                    Bpoint = NSMakePoint(rightBottomY.x,rightBottomY.y + autoOffDownHeight - 10);
                }
                
                ABNodepoint = NSMakePoint(rightTopY.x + cornetOffWidth, (Apoint.y + Bpoint.y) / 2);
            }
        }
            break;
        case 4: //右下
        {
            if ((angle == 10) || (angle == 40)) {
                ABNodepoint = NSMakePoint(rightBottom.x + cornetOffWidth, rightBottom.y);
            }
            else //在直线上绘角
            {
                if (rh <= 30)
                {
                    autoOffDownHeight = (rh- 2*radius - 10) / 2;
                    autoOffUpHeight = autoOffDownHeight;
                    Apoint = NSMakePoint(rightTopY.x,rightTopY.y - autoOffUpHeight);
                    Bpoint = NSMakePoint(rightBottomY.x,rightBottomY.y + autoOffDownHeight);
                }
                else
                {
                    autoOffDownHeight = (rh- 2*radius) / 30;//30 :1 的比例进行(按1：29比例平分高度)
                    autoOffDownHeight = autoOffDownHeight > 10 ? 10 : autoOffDownHeight;
                    autoOffUpHeight = (rh- 2*radius) - autoOffDownHeight;
                    
                    Apoint = NSMakePoint(rightTopY.x,rightTopY.y - autoOffUpHeight + 10);
                    Bpoint = NSMakePoint(rightBottomY.x,rightBottomY.y + autoOffDownHeight);
                }
                
                ABNodepoint = NSMakePoint(rightBottomY.x + cornetOffWidth, (Apoint.y + Bpoint.y) / 2);
            }

        }
            break;
            
        default: //左上
        {
            if ((angle == 10) || (angle == 40))
            {
                ABNodepoint = NSMakePoint(leftTop.x - cornetOffWidth, leftTop.y);
            }
            else
            {
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
                
                ABNodepoint = NSMakePoint(leftTop.x - cornetOffWidth, (Apoint.y + Bpoint.y) / 2);
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
    
    //右下角缺口位置的A,B点坐标
//    NSPoint rBottomApoint = NSMakePoint(rightBottomX.x + Ax,rightBottomY.y - Ay);//(闭环结点)
    NSPoint rBottomBpoint = NSMakePoint(rightBottomX.x + By,rightBottomY.y - Bx);
    
    //右上角缺口位置A,B点坐标
//    NSPoint rTopApoint = NSMakePoint(rightTopX.x + By,rightTopY.y + Bx);//(闭环结点)
    NSPoint rTopBpoint = NSMakePoint(rightTopX.x + Ax,rightTopY.y + Ay);
    
    //左下角缺口位置A,B点坐标
    NSPoint lBottomApoint = NSMakePoint(leftBottomX.x - Ax,leftBottomY.y - Ay);
//    NSPoint lBottomBpoint = NSMakePoint(leftBottomX.x - By,leftBottomY.y - By);//(闭环结点)
    
    //左上角缺口位置A,B点坐标
    NSPoint lTopApoint = NSMakePoint(leftTopX.x - By,leftTopY.y + Bx);
//    NSPoint lTopBpoint = NSMakePoint(leftTopX.x - Ax,leftTopY.y + Ay);//(闭环结点)

    
    //按顺时针顺序进行绘制
    switch (pos) {
        case 2:
        {
            //绘制启始点
            [bezierPath moveToPoint:ABNodepoint];
            
            if (angle != 0)
            {
                [bezierPath lineToPoint:lBottomApoint];
                
                [bezierPath appendBezierPathWithArcWithCenter:leftBottomCenter radius:radius
                                                   startAngle:-(90 + baseAngle + angle)
                                                     endAngle:180
                                                    clockwise:YES];
            }
            else
            {
                [bezierPath lineToPoint:Apoint];
            }
            //左上半圆
            [self drawLeftTopPart:leftTopCenter withRadius:radius addToBezierPath:bezierPath];
            //右上半圆
            [self drawRightTopPart:rightTopCenter withRadius:radius addToBezierPath:bezierPath];
            //右下半圆
            [self drawRightBottomPart:rightBottomCenter withRadius:radius addToBezierPath:bezierPath];
            
            if (angle != 0)
            {
                [bezierPath appendBezierPathWithArcWithCenter:leftBottomCenter radius:radius
                                                   startAngle:-90
                                                     endAngle:-(90 + baseAngle)
                                                    clockwise:YES];
            }
            else
            {
                //左下半圆
                [self drawLeftBottomPart:leftBottomCenter withRadius:radius addToBezierPath:bezierPath];
                [bezierPath lineToPoint:Bpoint];
            }
        }
            break;
        case 3:
        {
            //绘制启始点
            [bezierPath moveToPoint:ABNodepoint];
            
            if (angle != 0)
            {
                [bezierPath lineToPoint:rTopBpoint];
                //绘制右上角缺角B点上半部的圆解部分
                [bezierPath appendBezierPathWithArcWithCenter:rightTopCenter radius:radius
                                                   startAngle:(90 - baseAngle - angle)
                                                     endAngle:0
                                                    clockwise:YES];
            }
            else
            {
                [bezierPath lineToPoint:Bpoint];
            }
            //右下半圆
            [self drawRightBottomPart:rightBottomCenter withRadius:radius addToBezierPath:bezierPath];
            //左下半圆
            [self drawLeftBottomPart:leftBottomCenter withRadius:radius addToBezierPath:bezierPath];
            //左上半圆
            [self drawLeftTopPart:leftTopCenter withRadius:radius addToBezierPath:bezierPath];
            
            if (angle != 0)
            {
                [bezierPath appendBezierPathWithArcWithCenter:rightTopCenter radius:radius
                                                   startAngle:90
                                                     endAngle:(90-baseAngle)
                                                    clockwise:YES];
            }
            else
            {
                //右上半圆
                [self drawRightTopPart:rightTopCenter withRadius:radius addToBezierPath:bezierPath];
                [bezierPath lineToPoint:Apoint];
            }
        }
            break;
        case 4:
        {
            //绘制启始点
            [bezierPath moveToPoint:ABNodepoint];
            
            if (angle != 0)
            {
                //绘到缺角B坐标点
                [bezierPath lineToPoint:rBottomBpoint];
                //绘制右下角缺角B点下半部的圆解部分
                [bezierPath appendBezierPathWithArcWithCenter:rightBottomCenter radius:radius
                                                   startAngle:-(90-baseAngle)//-50
                                                     endAngle:-90
                                                    clockwise:YES];
            }
            else
            {
                [bezierPath lineToPoint:Bpoint];
                [self drawRightBottomPart:rightBottomCenter withRadius:radius addToBezierPath:bezierPath];
            }
            
            //左下半圆
            [self drawLeftBottomPart:leftBottomCenter withRadius:radius addToBezierPath:bezierPath];
            //左上半圆
            [self drawLeftTopPart:leftTopCenter withRadius:radius addToBezierPath:bezierPath];
            //右上半圆
            [self drawRightTopPart:rightTopCenter withRadius:radius addToBezierPath:bezierPath];
            
            if (angle != 0)
            {
                //绘制右下角缺角A点上半部的圆解部分
                [bezierPath appendBezierPathWithArcWithCenter:rightBottomCenter radius:radius
                                                   startAngle:0
                                                     endAngle:- (90 - baseAngle - angle)//40
                                                    clockwise:YES];
            }
            else
            {
                [bezierPath lineToPoint:Apoint];
            }
        }
            break;
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

@end
