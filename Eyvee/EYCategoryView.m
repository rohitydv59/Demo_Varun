//
//  EYCategoryView.m
//  Eyvee
//
//  Created by Neetika Mittal on 11/08/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "EYCategoryView.h"
#import "EYConstant.h"
#import "EYUtility.h"
#import "UIImageView+AFNetworking.h"

@interface EYCategoryView ()

@property (nonatomic, strong) UILabel *label;
@property (nonatomic)NSInteger headerTextfontValue;
@property (nonatomic)NSInteger middleTextfontValue;
@property (nonatomic)NSInteger bottomTextfontValue;

@property (nonatomic, strong) UIImageView *imgView;

@end

@implementation EYCategoryView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    self.clipsToBounds = YES;
    
    self.imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.imgView.contentMode = UIViewContentModeScaleAspectFill;
    self.imgView.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:_imgView];
    
    self.label = [[UILabel alloc] initWithFrame:CGRectZero];
    self.label.numberOfLines = 0;
    [self addSubview:_label];
    
    self.cartBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.cartBtn.tintColor = [UIColor whiteColor];
    [self.cartBtn setImage:[UIImage imageNamed:@"cart"] forState:UIControlStateNormal];
    self.cartBtn.hidden = YES;
    [self addSubview:_cartBtn];
    
    self.backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.backBtn.tintColor = [UIColor whiteColor];
    [self.backBtn setImage:[UIImage imageNamed:@"back_img"] forState:UIControlStateNormal];
    self.backBtn.hidden = YES;
    [self addSubview:_backBtn];
}

- (void)setLabelText:(NSString *)mainText headerText:(NSString *)headerText middleText:(NSString*)midText bottomText:(NSString*)btomText WithVCMode:(EYVCType)mode
{
    self.label.attributedText = [EYCategoryView getAttrStr:mainText headerText:headerText headerFont:_headerTextfontValue middleText:midText middleFont:_middleTextfontValue bottomText:btomText bottomFont:_bottomTextfontValue WithVCMode:mode];
    [self setNeedsLayout];
    
}

- (void)setHeaderType:(HeaderViewType)headerType
{
    _headerType = headerType;
    if (headerType == HeaderViewTypeNoButtons) {
        self.cartBtn.hidden = YES;
        self.backBtn.hidden = YES;
    }
    else if (headerType == HeaderViewTypeBackButton) {
        self.cartBtn.hidden = YES;
        self.backBtn.hidden = NO;
    }
    else if (headerType == HeaderViewTypeCartButton) {
        self.cartBtn.hidden = NO;
        self.backBtn.hidden = YES;
    }
    else if (headerType == HeaderViewTypeAllButtons) {
        self.cartBtn.hidden = NO;
        self.backBtn.hidden = NO;
    }
}

-(void)setHeaderTextFont:(NSInteger)headerFont middleTextFont:(NSInteger)middleTextFont bottomTextFont:(NSInteger)bottomTextFont
{
    
    if (headerFont == 0)
    {
        _headerTextfontValue = 12.0;
    }
    else
        _headerTextfontValue = headerFont;
    if (middleTextFont == 0)
    {
        _middleTextfontValue = 12.0;
    }
    else
        _middleTextfontValue = middleTextFont;
    if (bottomTextFont == 0 )
    {
        _bottomTextfontValue = 12.0 ;
    }
    else
        _bottomTextfontValue = bottomTextFont;
    
}

+ (NSAttributedString *)getAttrStr:(NSString *)mainText headerText:(NSString *)headerText headerFont:(NSInteger)headerF middleText:(NSString*)midText middleFont:(NSInteger)middleF bottomText:(NSString*)bottomText bottomFont:(NSInteger)bottomF WithVCMode:(EYVCType)mode
{
    NSMutableAttributedString *mutAttr = [[NSMutableAttributedString alloc] init];
    NSAttributedString *attr;
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentCenter;
    style.paragraphSpacingBefore = 0.0;
    
    NSMutableParagraphStyle *style1 = [[NSMutableParagraphStyle alloc] init];
    style1.alignment = NSTextAlignmentCenter;
    
    
    if (mainText.length > 0)
    {
        if (mode == bannerVC)
        {
            attr = [[NSAttributedString alloc] initWithString:mainText attributes:@{
                                                                                    NSFontAttributeName: AN_MEDIUM(26.0),
                                                                                    NSForegroundColorAttributeName : [UIColor whiteColor ],
                                                                                    NSParagraphStyleAttributeName : style1
                                                                                    }];
        }
        
        [mutAttr appendAttributedString:attr];
    }
    
    if (headerText.length > 0)
    {
        NSDictionary *dictForHeaderText;
        if (mode == sliderVC || mainText.length == 0)
        {
            dictForHeaderText = @{
                                  NSFontAttributeName: AN_MEDIUM(headerF),
                                  NSForegroundColorAttributeName : [UIColor whiteColor],
                                  NSParagraphStyleAttributeName : style1
                                  };
            attr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",headerText] attributes:dictForHeaderText];
            [mutAttr appendAttributedString:attr];
            
        }
        else
        {
            
            dictForHeaderText = @{
                                  NSFontAttributeName : AN_REGULAR(headerF),
                                  NSForegroundColorAttributeName : [UIColor whiteColor],
                                  NSParagraphStyleAttributeName : style
                                  };
            attr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%@",headerText] attributes:dictForHeaderText];
            [mutAttr appendAttributedString:attr];
            
        }
    }
    if (midText.length > 0)
    {
        NSDictionary *dictForMiddleText = @{
                                            NSFontAttributeName : AN_REGULAR(middleF),
                                            NSForegroundColorAttributeName : [UIColor whiteColor],
                                            NSParagraphStyleAttributeName : style
                                            };
        attr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%@",midText] attributes:dictForMiddleText];
        [mutAttr appendAttributedString:attr];
    }
    if (bottomText.length > 0)
    {
        NSDictionary *dictForBottomText = @{
                                            NSFontAttributeName : AN_REGULAR(bottomF),
                                            NSForegroundColorAttributeName : [UIColor whiteColor],
                                            NSParagraphStyleAttributeName : style
                                            };
        attr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%@",bottomText] attributes:dictForBottomText];
        [mutAttr appendAttributedString:attr];
    }
    
    return mutAttr;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect rect = self.bounds;
    self.imgView.frame = rect;
    
    CGFloat w = rect.size.width - 2 * kLabelEdgePadding;
    CGSize labelSize = [EYUtility sizeForAttributedString:self.label.attributedText width:w];
    
    CGFloat diff = floorf((rect.size.height - labelSize.height)/2.0);
    
    if (diff < 0)
        self.label.frame = (CGRect) {floorf((rect.size.width - labelSize.width)/2.0), 0, labelSize.width , rect.size.height};
    else
        self.label.frame = (CGRect) {floorf((rect.size.width - labelSize.width)/2.0), floorf((rect.size.height - labelSize. height)/2.0), labelSize};
    
    CGRect btnRect = (CGRect) {rect.size.width - kHeaderButtonHeight, 0.0, kHeaderButtonHeight, kHeaderButtonHeight};
    
    self.cartBtn.frame = btnRect;
    
    btnRect.origin.x = 0.0;
    self.backBtn.frame = btnRect;
}

- (void)resetImage
{
    [self cancelImageRequest];
    self.imgView.image = nil;
}

- (void)setImgViewImageWithUrl:(NSURLRequest *)urlRequest
{
    UIImage *img = [[UIImageView sharedImageCache] cachedImageForRequest:urlRequest];
    if (img)
    {
        [self cancelImageRequest];
        self.imgView.image = img;
    }
    else if (urlRequest)
    {
        [self cancelImageRequest];
        self.imgView.image = nil;
        
        __weak __typeof(self)weakSelf = self;
        
        [self.imgView setImageWithURLRequest:urlRequest placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            [weakSelf processImage:image];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            [weakSelf processImage:nil];
        }];
    }
}

- (void)processImage:(UIImage*)image
{
    if (image == nil) {
        return;
    }
    [UIView transitionWithView:self.imgView
                      duration:0.2f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        self.imgView.image = image;
                    } completion:nil];
    
}

- (void)cancelImageRequest
{
    [self.imgView cancelImageRequestOperation];
}

@end
