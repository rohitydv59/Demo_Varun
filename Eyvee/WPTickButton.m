//
//  TickView.m
//  Credit Card Reader
//
//  Created by Monis Manzoor on 17/12/14.
//  Copyright (c) 2014 Monis Manzoor. All rights reserved.
//

#import "WPTickButton.h"
#import "EYUtility.h"
#import "EYConstant.h"

@interface WPTickButton() {
    float _textOffset;
}

- (void)updateImage;

@end

@implementation WPTickButton

+ (id)buttonWithType:(UIButtonType)buttonType
{
    WPTickButton *button = [super buttonWithType:buttonType];
    button.titleLabel.numberOfLines = 0;
    button.titleLabel.font = AN_REGULAR(12.0);
    [button setTitleColor:KSaveCardText forState:UIControlStateNormal];
    [button updateImage];
    return button;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _textOffset = 1.0;
        _on = NO;
    }
    return self;
}

- (void)updateImage
{
    if (_on) {
        [self setImage:[[UIImage imageNamed:@"unchecked_square"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
//        self.tintColor = kBlueColor;
    }
    else {
        [self setImage:[[UIImage imageNamed:@"checked_square"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ] forState:UIControlStateNormal];
//        self.tintColor = GRAY(0.6);
    }
}

- (void)setOn:(BOOL)on
{
    _on = on;
    [self updateImage];
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    UIImage *image = [self imageForState:UIControlStateNormal];
    if (!image) {
        return CGRectZero;
    }
    
    CGSize size = image.size;
    return (CGRect) {0.0, floor((contentRect.size.height - size.height)/2.0), size};
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    UIImage *image = [self imageForState:UIControlStateNormal];
    if (!image) {
        return contentRect;
    }
    
    CGSize size = image.size;
    float left = size.width + 14.0;
    float w = contentRect.size.width - left;
    
    CGRect tRect = contentRect;
    tRect.origin.x = left;
//    tRect.origin.y -= _textOffset;
//    tRect.size.height += _textOffset;
    tRect.size.width = w ;
    return tRect;
}

- (CGSize)requiredSizeForWidth:(CGFloat)width
{
    UIImage *image = [self imageForState:UIControlStateNormal];
    CGSize size = image.size;
    
    float w = width - size.width - 14.0; //padding between tick button and text in save card
    CGSize tSize = CGSizeZero;
    
    NSAttributedString *atrString = [self attributedTitleForState:UIControlStateNormal];
    if (atrString.length == 0) {
        NSString *title = [self titleForState:UIControlStateNormal];
        if (title.length > 0) {
            tSize =[EYUtility sizeForString:title font:self.titleLabel.font width:w];
        }
    }
    else {
        tSize = [EYUtility sizeForAttributedString:atrString width:w];
        
    }
    
    w = tSize.width + size.width + 14.0;
    float h = MAX(tSize.height, size.height);
    return (CGSize) {w, h};
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [self setAttributedTitle:nil forState:state];
    [super setTitle:title forState:state];
}

- (void)setAttributedTitleForTickButton:(NSString *)firstString secondString:(NSString *)secondString
{
    NSMutableAttributedString *mutAttributed = [[NSMutableAttributedString alloc]init];
    
    NSDictionary *topTitleDict = @{NSForegroundColorAttributeName :KSaveCardText, NSFontAttributeName :AN_REGULAR(12.0)};
    NSAttributedString *attributed;
    if (firstString.length > 0) {
        attributed = [[NSAttributedString alloc]initWithString:firstString attributes:topTitleDict];
        [mutAttributed appendAttributedString:attributed];
    }
    
    if (secondString.length > 0) {
        NSDictionary *bottomTitleDict = @{NSForegroundColorAttributeName : KSaveCardText, NSFontAttributeName : AN_REGULAR(12.0)};
        attributed = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"\n%@",secondString] attributes:bottomTitleDict];
        [mutAttributed appendAttributedString:attributed];
    }

    [self setTitle:nil forState:UIControlStateNormal];
    [self setAttributedTitle:mutAttributed forState:UIControlStateNormal];

}

@end
