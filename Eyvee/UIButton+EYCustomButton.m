//
//  UIButton+EYCustomButton.m
//  Eyvee
//
//  Created by Disha Jain on 15/09/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "UIButton+EYCustomButton.h"
#import "EYConstant.h"
#import "EYUtility.h"

@implementation UIButton (EYCustomButton)


- (void)centerButtonAndImageWithRightImageSpacing:(CGFloat)spacing withImageName:(NSString*)imageName withTitleName:(NSString*)titleName
{
    [self setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [self setTitle:titleName forState:UIControlStateNormal];
    [self setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [self setImageEdgeInsets:UIEdgeInsetsMake(0,0,0,-self.bounds.size.width - 8.0 - 20.0)];


  

//    self.titleEdgeInsets = UIEdgeInsetsMake(0., -20., 0.0,self.imageView.frame.size.width);
//     self.imageEdgeInsets = UIEdgeInsetsMake(0, -self.titleLabel.frame.size.width , 0.0,-self.titleLabel.frame.size.width);
}

@end
