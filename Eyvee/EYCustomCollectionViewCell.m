//
//  EYCustomCollectionViewCell.m
//  Eyvee
//
//  Created by Varun Kapoor on 14/10/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "EYCustomCollectionViewCell.h"
#import "EYCustomButton.h"
#import "EYConstant.h"

@implementation EYCustomCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setUp];
    }
    return self;
}

-(void) setUp
{
    _colorBtn = [EYCustomButton buttonWithType:UIButtonTypeSystem];
    [self.contentView addSubview:_colorBtn];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [_colorBtn setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _colorBtn.hidesBotSep = YES;
    _colorBtn.hidesSideSep = YES;
}

-(void) updatingColor:(NSString *)colorValue
{
    NSUInteger red, green, blue;
    sscanf([colorValue UTF8String], "#%2lX%2lX%2lX", &red, &green, &blue);
    UIColor *color = [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1];
    [self.colorBtn setBackgroundColor:color];
    self.colorBtn.layer.borderColor = color.CGColor;
}

-(void)setIsCircled:(bool)isCircled
{
    _isCircled = isCircled;
    if(isCircled)
    {
        UIImage *imgNormal = [UIImage imageNamed:@"selected_large"];
        imgNormal = [imgNormal imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [self.colorBtn setImage:imgNormal forState:UIControlStateNormal];
    }
    else
    {
        [self.colorBtn setImage:nil forState:UIControlStateNormal];
        
    }
}

@end


