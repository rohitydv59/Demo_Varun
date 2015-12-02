//
//  EYButtonWithRightImage.m
//  Eyvee
//
//  Created by Disha Jain on 22/09/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "EYButtonWithRightImage.h"
#import "EYUtility.h"
#import "EYConstant.h"
@implementation EYButtonWithRightImage


+ (id)buttonWithType:(UIButtonType)buttonType
{
    EYButtonWithRightImage *button = [super buttonWithType:buttonType];
    return button;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGRect frame = (CGRect){self.frame.size.width - 20 - 8.0,8.0,20.0,20.0};
    return frame;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGSize fr = [super titleRectForContentRect:contentRect].size;
        CGRect rect = (CGRect){kProductDescriptionPadding,(contentRect.size.height - fr.height)/2,fr};
    return rect;
}

//For placing the title and image in the center

//- (CGRect)imageRectForContentRect:(CGRect)contentRect
//{
//    CGRect textFrame = self.titleLabel.frame;
//    
//    CGRect imgRect = (CGRect) {CGRectGetMaxX(textFrame) , (contentRect.size.height - 24)/2, 24,24};
//
//    return imgRect;
//}
//
//- (CGRect)titleRectForContentRect:(CGRect)contentRect
//{
//    CGSize tSize = [super titleRectForContentRect:contentRect].size;
//    CGSize imgSize = [self imageForState:self.state].size;
//
//    CGRect rect = (CGRect) {(contentRect.size.width- tSize.width - imgSize.width)/2, (contentRect.size.height - tSize.height)/2, tSize};
//    return rect;
//}


-(void)setIsClicked:(BOOL)isClicked
{
    _isClicked = isClicked;
    if (_isClicked)
    {
        UIImage *imgNormal = [UIImage imageNamed:@"fav_added"];
        imgNormal = [imgNormal imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [self setImage:imgNormal forState:UIControlStateNormal];
        [UIView performWithoutAnimation:^{
            [self setTitle:@"WISHLIST" forState:UIControlStateNormal];
            [self layoutIfNeeded];
        }];
    
    }
    else
    {
        UIImage *imgNormal = [UIImage imageNamed:@"fav_add"];
        imgNormal = [imgNormal imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [self setImage:imgNormal forState:UIControlStateNormal];
        [UIView performWithoutAnimation:^{
            [self setTitle:@"WISHLIST" forState:UIControlStateNormal];
            [self layoutIfNeeded];
        }];
    }
}

@end
