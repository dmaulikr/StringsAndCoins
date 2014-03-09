//
//  SCCellView.m
//  StringsAndCoins
//
//  Created by David S Reich on 8/02/2014.
//  Copyright (c) 2014 David S Reich. All rights reserved.
//

#import "SCGCellView.h"
#import "SCGLevel.h"
#import "constants.h"

//#define SHOWTRIANGLES

@implementation SCGCellView
#if defined(SHOWROWANDCOL)
{
    UILabel *rcLabel;
}
#endif

- (instancetype)initWithLevel:(SCGLevel *)l andRow:(int)r andCol:(int)c andTopHalf:(BOOL)t
{
	if (l.levelType == BoxesType)
    {
#if defined(SHOWTRIANGLES)
        if (l.levelShape == TriangleShape)
        {
            if ((t && (c % 2 != 0)) || (!t && (c % 2 == 0)))
                self = [super initWithImage: [UIImage imageNamed:@"triangleDown-md.png"]];
            else
                self = [super initWithImage: [UIImage imageNamed:@"triangleUp-md.png"]];
        }
        else
            self = [super init];	//no image for boxes
        //self = [super initWithImage: l.dotImage];	//testing
#else
        self = [super init];	//no image for boxes
//        self = [super initWithImage: [UIImage imageNamed:@"hexagon-md.png"]];
        //self = [super initWithImage: l.dotImage];	//testing
#endif
    }
	else
		self = [super initWithImage: l.cellImage];
	
    if (self != nil)
    {
        //initialization
        self.complete = NO;
        self.playerNumber = -1;
		self.row = r;
		self.col = c;
		self.level = l;
		self.topHalf = t;

        if (l.levelShape == TriangleShape)
        {
            if ((t && (c % 2 != 0)) || (!t && (c % 2 == 0)))
                self.isUpTriangle = NO;
            else
                self.isUpTriangle = YES;
        }

#if 1
        self.frame = CGRectMake(0, 0, l.cellWidth, l.cellHeight);
#else
        float scale;
        
		if (l.levelType == CoinsType)
		{
            scale = (l.cellWidth / self.image.size.width) / 2;
            
			//resize
			self.frame = CGRectMake(0, 0, l.cellWidth, l.cellHeight);
//			self.frame = CGRectMake(0, 0, self.image.size.width*scale, self.image.size.height*scale);
		}
        else
        {
			//resize
            scale = 1.5;
            if (l.levelShape == SquareShape)
                scale = 1;
            else if (l.levelShape == TriangleShape)
#if defined(SHOWTRIANGLES)
                scale = 1;
#else
                scale = .5;
#endif
            else
            {
                //hexagons
                scale = (l.cellWidth / self.image.size.width) / 2;
                scale = 1;
            }
            self.frame = CGRectMake(0, 0, l.cellWidth * scale, l.cellHeight * scale);
        }
#endif

#if defined(SHOWROWANDCOL)
        rcLabel = [[UILabel alloc] initWithFrame:self.bounds];
        rcLabel.textAlignment = NSTextAlignmentCenter;
        rcLabel.textColor = [UIColor whiteColor];
        rcLabel.backgroundColor = [UIColor clearColor];
        rcLabel.text = [NSString stringWithFormat:@"%d %d", r, c];
        rcLabel.font = [UIFont fontWithName:@"Verdana-Bold" size:78.0*scale/16];
        [self addSubview: rcLabel];
#endif
        
        [self updateImage];
    }
	
    return self;
}

- (void) setComplete:(BOOL)c withPlayer:(int)p andColor:(UIColor *)color
{
    self.complete = c;
    self.playerNumber = p;
    self.completeColor = color;
    [self updateImage];
}

- (void) updateImage
{
    if (self.level.levelType == CoinsType)
    {
        if (self.complete)
        {
            [self setImage:nil];
#if defined(SHOWROWANDCOL)
            rcLabel.hidden = NO;
#endif
        }
        else
        {
            [self setImage:self.level.cellImage];
#if defined(SHOWROWANDCOL)
            rcLabel.hidden = YES;
#endif
        }
    }
    else
    {
        if (self.complete)
        {
//            [self setImage:self.level.dotImage];
#if defined(SHOWROWANDCOL)
            rcLabel.hidden = NO;
#endif
        }
        else
        {
//            [self setImage:nil];
//            [self setImage:self.level.dotImage];
#if defined(SHOWROWANDCOL)
            rcLabel.hidden = YES;
//            rcLabel.hidden = NO;
#endif
        }
    }

    if (self.level.levelShape == SquareShape)
    {
        if (self.complete)
        {
            self.backgroundColor = self.completeColor;
        }
        else
        {
            self.backgroundColor = [UIColor clearColor];
        }
    }
    else if (self.level.levelShape == TriangleShape)
    {
        CGPoint firstPt;
        CGPoint secondPt;
        CGPoint thirdPt;

        if (self.isUpTriangle)
        {
            firstPt = CGPointMake(0, self.level.cellHeight);
            secondPt = CGPointMake(self.level.cellWidth, self.level.cellHeight);
            thirdPt = CGPointMake(self.level.cellWidth / 2, 0);
        }
        else
        {
            firstPt = CGPointMake(0, 0);
            secondPt = CGPointMake(self.level.cellWidth, 0);
            thirdPt = CGPointMake(self.level.cellWidth / 2, self.level.cellHeight);
        }

        //get the image context with options(recommended funct to use)
        //get the size of the imageView
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.level.cellWidth, self.level.cellHeight), NO, 0.0);
        
        //use the the image that is going to be drawn on as the receiver
        UIImage *img = self.image;
        
        [img drawInRect:CGRectMake(0.0, 0.0, self.level.cellWidth, self.level.cellHeight)];

        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(ctx, 0.5);
        
        UIGraphicsPushContext(ctx);
        
        //uses path ref
        CGMutablePathRef path = CGPathCreateMutable();
        //draw the triangle
        CGPathMoveToPoint(path, NULL, firstPt.x, firstPt.y);
        CGPathAddLineToPoint(path, NULL, secondPt.x, secondPt.y);
        CGPathAddLineToPoint(path, NULL, thirdPt.x, thirdPt.y);
        CGPathAddLineToPoint(path, NULL, firstPt.x, firstPt.y);
        //close the path
        CGPathCloseSubpath(path);
        //add the path to the context
        CGContextAddPath(ctx, path);
        if (self.complete)
            CGContextSetFillColorWithColor(ctx, self.completeColor.CGColor);
        else
            CGContextSetFillColorWithColor(ctx, [UIColor clearColor].CGColor);
        CGContextSetStrokeColorWithColor(ctx, [UIColor clearColor].CGColor);
        CGContextFillPath(ctx);
        CGContextAddPath(ctx, path);
        CGContextStrokePath(ctx);
        CGPathRelease(path);
        
        UIGraphicsPopContext();
        
        //get the new image with the triangle
        UIImage *img2 = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

        [self setImage:img2];
    }
    else //if (0)
    {
        //hexagons
        CGPoint pts[6];
        
        pts[0] = CGPointMake(self.level.cellWidth / 2, 0);
        pts[1] = CGPointMake(self.level.cellWidth, self.level.cellHeight / 4);
        pts[2] = CGPointMake(self.level.cellWidth, (3 * self.level.cellHeight) / 4);
        pts[3] = CGPointMake(self.level.cellWidth / 2, self.level.cellHeight);
        pts[4] = CGPointMake(0, (3 * self.level.cellHeight) / 4);
        pts[5] = CGPointMake(0, self.level.cellHeight / 4);

        //get the image context with options(recommended funct to use)
        //get the size of the imageView
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.level.cellWidth, self.level.cellHeight), NO, 0.0);
        
        //use the the image that is going to be drawn on as the receiver
        UIImage *img = self.image;
        
        [img drawInRect:CGRectMake(0.0, 0.0, self.level.cellWidth, self.level.cellHeight)];
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, 0.5);
        
        UIGraphicsPushContext(context);
        
        //uses path ref
        CGMutablePathRef path = CGPathCreateMutable();
        //draw the hexagon
        CGPathMoveToPoint(path, NULL, pts[0].x, pts[0].y);
        for (int i = 1; i < 6; i++)
            CGPathAddLineToPoint(path, NULL, pts[i].x, pts[i].y);
        CGPathAddLineToPoint(path, NULL, pts[0].x, pts[0].y);
        //close the path
        CGPathCloseSubpath(path);
        //add the path to the context
        CGContextAddPath(context, path);
        if (self.complete)
            CGContextSetFillColorWithColor(context, self.completeColor.CGColor);
        else
            CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
        CGContextSetStrokeColorWithColor(context, [UIColor clearColor].CGColor);
#if 1   //testing
//        CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
#endif
        CGContextFillPath(context);
        CGContextAddPath(context, path);
        CGContextStrokePath(context);
        CGPathRelease(path);
        
        UIGraphicsPopContext();
        
        //get the new image with the triangle
        UIImage *img2 = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        [self setImage:img2];
//        self.backgroundColor = [UIColor greenColor];
    }
}

- (void)checkStatus
{
}

@end