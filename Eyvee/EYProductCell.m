//
//  EYProductCell.m
//  Eyvee
//
//  Created by Neetika Mittal on 13/08/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "EYProductCell.h"
#import "EYConstant.h"
#import "EYUtility.h"

@interface EYProductCell ()

@property (nonatomic, strong) UILabel *productLbl;
@property (nonatomic, strong) UIImageView *lineImgView;
@property (nonatomic, strong) UILabel *productPrice;
@end

@implementation EYProductCell

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
    
    self.productImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.productImgView.clipsToBounds = YES;
    self.productImgView.backgroundColor = [UIColor whiteColor];
    self.productImgView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:_productImgView];
    
    self.productName = [[UILabel alloc]initWithFrame:CGRectZero];
    self.productName.numberOfLines = 1.0;
    [self.contentView addSubview:self.productName];
    self.productName.font = AN_REGULAR(14.0);
    self.productName.textColor = kBlackTextColor;
    self.productName.textAlignment = NSTextAlignmentCenter;
    self.productName.lineBreakMode = NSLineBreakByTruncatingMiddle;

    self.productPrice = [[UILabel alloc]initWithFrame:CGRectZero];
    self.productPrice.numberOfLines = 0;
    [self.contentView addSubview:self.productPrice];
   
    self.favBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.favBtn.tintColor = [UIColor clearColor];
    [self.favBtn addTarget:self action:@selector(wishListBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *imgNormal = [UIImage imageNamed:@"fav_add"];
    imgNormal = [imgNormal imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *imgSelected =[UIImage imageNamed:@"fav_added"];
    imgSelected = [imgSelected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [self.favBtn setImage:imgNormal forState:UIControlStateNormal];
    [self.favBtn setImage:imgSelected forState:UIControlStateSelected];
    [self.contentView addSubview:_favBtn];
    
    self.lineImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.lineImgView.backgroundColor = kMainSeparatorColor;
    [self.contentView addSubview:_lineImgView];
}

- (void)wishListBtnClicked
{
    if (_delegate && [_delegate respondsToSelector:@selector(wishListButtonTappedWithProduct:withCell:)]) {
        [_delegate wishListButtonTappedWithProduct:_product withCell:self];
    }
}

-(void)setProductPrices:(NSString*)price retailPrice:(NSString*)retailPrice
{
    self.productPrice.attributedText = [EYProductCell attrProductPrice:price retailPrice:retailPrice];
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect rect = self.contentView.bounds;
    
    if (_cellPositionR) {
        self.productImgView.frame = (CGRect){kGutterSpace,0,rect.size.width-kGutterSpace,rect.size.height - 70.0};
    }
    else
    {
        self.productImgView.frame = (CGRect){0,0,rect.size.width-kGutterSpace,rect.size.height - 70.0};
    }
    CGSize sizeOfName = self.productName.intrinsicContentSize;
    self.productName.frame = (CGRect){self.productImgView.frame.origin.x+kGutterSpace,12.0+CGRectGetMaxY(self.productImgView.frame),self.productImgView.frame.size.width-2*kGutterSpace,sizeOfName.height};
    CGSize sizeOPrice =[EYUtility sizeForAttributedString:self.productPrice.attributedText width:self.productImgView.frame.size.width-2*kGutterSpace];
    self.productPrice.frame = (CGRect){self.productImgView.frame.origin.x+kGutterSpace,CGRectGetMaxY(self.productName.frame)+4.0,self.productImgView.frame.size.width-2*kGutterSpace,sizeOPrice.height};

    self.favBtn.frame = (CGRect) {CGRectGetMaxX(self.productImgView.frame)-kfavButtonHeight, 0,kfavButtonHeight,kfavButtonHeight};
}

+ (CGFloat)heightForWidth:(CGFloat)width
{
    CGFloat imageWidthInCell = width-kGutterSpace;
    
    CGFloat imageHeight = (3*imageWidthInCell)/2;
    
    CGFloat h = 0.0;
    h+=imageHeight + 70.0;

    return ceilf(h);
}

+ (NSAttributedString *)attrProductPrice:(NSString *)price retailPrice:(NSString *)retailPrice
{
    NSMutableAttributedString *mutableAttr = [[NSMutableAttributedString alloc] init];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    style.alignment = NSTextAlignmentCenter;
    
//    NSMutableParagraphStyle *style1 = [[NSMutableParagraphStyle alloc]init];
//    style1.alignment = NSTextAlignmentCenter;
    NSAttributedString *attr;
    
    attr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",retailPrice] attributes:@{
                                                                         NSFontAttributeName : AN_MEDIUM(16.0),
                                                                         NSForegroundColorAttributeName : kBlackTextColor,
                                                                         NSParagraphStyleAttributeName: style
                                                                         }];
    [mutableAttr appendAttributedString:attr];
    
    
//    if (retailPrice.length > 0) {
//        attr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"\nRetail %@",retailPrice] attributes:@{
//                                                                                                                              NSFontAttributeName : AN_REGULAR(14.0),
//                                                                                                                              NSForegroundColorAttributeName : kAppLightGrayColor,
//                                                                                                                              NSParagraphStyleAttributeName : style1
//                                                                                                                              }];
//        [mutableAttr appendAttributedString:attr];
//    }
    return mutableAttr;
}

- (void)setProductImage:(NSString *)imageStr
{
    self.productImgView.image = [UIImage imageNamed:imageStr];
    return;

//    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:imageStr]];
//    UIImage *img = [[UIImageView sharedImageCache] cachedImageForRequest:request];
//    if (img)
//    {
//        [self cancelImageRequest];
//        self.productImgView.image = [UIImage imageNamed: imageStr];
//        return;
//    }
//
//    __weak __typeof(self)weakSelf = self;
//    
//    [self.productImgView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
//     {
//         [weakSelf processImage:image];
//     } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error)
//     {
//         [weakSelf processImage:nil];
//     }];
}

- (void)processImage:(UIImage*)image
{
    if (image == nil) {
        return;
    }
    
    [UIView transitionWithView:self.productImgView
                      duration:0.2f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        self.productImgView.image = image;
                    } completion:nil];
}

- (void)cancelImageRequest
{
    [self.productImgView cancelImageRequestOperation];
}

@end
