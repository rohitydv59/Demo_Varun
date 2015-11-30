//
//  EYBottomButton.m
//  Eyvee
//
//  Created by Disha Jain on 15/09/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "EYBottomButton.h"
#import "EYConstant.h"
#import "EYUtility.h"

@interface EYBottomButton ()
@property (strong,nonatomic)UILabel *label;
@property (strong,nonatomic) UIImageView *rightImage;

@property (strong,nonatomic)NSString *imageString;
@property (strong,nonatomic)UIFont *font;
@end

@implementation EYBottomButton


-(instancetype)initWithFrame:(CGRect)frame image:(NSString*)imageString ButtonText:(NSString*)buttonLabel andFont:(UIFont*)font
{
   self = [super initWithFrame:frame];
    if (self)
    {
        _buttonString = buttonLabel;
        _imageString = imageString;
        _font = font;
        [self setUp];
    }
    return self;
    
}

-(void)setUp
{
    self.backgroundColor = kAppGreenColor;
    self.label = [[UILabel alloc]initWithFrame:CGRectZero];
    self.label.textColor = [UIColor whiteColor];
    self.label.text = _buttonString;
    self.label.font = _font;
    [self addSubview:self.label];
    
    self.rightImage = [[UIImageView alloc]initWithFrame:CGRectZero];
    UIImage *image = [UIImage imageNamed:_imageString];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.rightImage.tintColor = [UIColor whiteColor];
    self.rightImage.image = image;
    self.rightImage.contentMode = UIViewContentModeCenter ;
    [self addSubview:self.rightImage];
    
    
    
}
-(void)setButtonString:(NSString *)buttonString
{
    _buttonString = buttonString;
    self.label.text = _buttonString;
    [self setNeedsLayout];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize size = self.bounds.size;
    
    CGSize textSize = [EYUtility sizeForString:_buttonString font:_font];
    _label.frame = (CGRect){(size.width - textSize.width)/2,floorf((size.height - textSize.height)/2),textSize};
    _rightImage.frame = (CGRect){size.width - 24-12,12,24,24};
}

-(void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    
    [UIView animateWithDuration:highlighted ? 0.1 : 0.2
                          delay:0.0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.rightImage.alpha = highlighted ? 0.3 : 1.0;
                         self.label.alpha = highlighted ? 0.3 : 1.0;
                     }
                     completion:nil];

}
@end
