//
//  EYAddToBagHeaderView.m
//  Eyvee
//
//  Created by Disha Jain on 13/08/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "EYAddToBagHeaderView.h"
#import "EYConstant.h"
#import "EYUtility.h"
#import "UIImageView+AFNetworking.h"

@interface EYAddToBagHeaderView()

@property (strong, nonatomic) UIImageView *productImage;
@property (strong, nonatomic) UILabel *productName;
@property (nonatomic, strong) NSString * thumbnailImage;
@property (nonatomic, strong) UIView * separatorLine;
@property (strong, nonatomic) UILabel *productBrand;
@property (strong, nonatomic) UILabel *productPrice;
@property (strong, nonatomic) EYProductsInfo *productToAdd;
@end


@implementation EYAddToBagHeaderView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.productImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.productImage.contentMode = UIViewContentModeScaleAspectFill;
        [self.productImage setClipsToBounds:YES];
        [self.productImage setBackgroundColor:kLightGrayBgColor];
        
        [self addSubview:self.productImage];
        
        self.productName = [[UILabel alloc] initWithFrame:CGRectZero];
        self.productName.numberOfLines = 0;
        self.productName.font = AN_REGULAR(14.0);
        self.productName.textColor = kRowLeftLabelColor;
        self.productName.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.productName];
        
        self.productBrand = [[UILabel alloc] initWithFrame:CGRectZero];
        self.productBrand.numberOfLines = 1;
        self.productBrand.font = AN_MEDIUM(14.0);
        self.productBrand.textColor = kBlackTextColor;
        self.productBrand.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.productBrand];
        
        self.productPrice = [[UILabel alloc] initWithFrame:CGRectZero];
        self.productPrice.numberOfLines = 1;
        self.productPrice.textAlignment = NSTextAlignmentRight;
        self.productPrice.font = AN_MEDIUM(16.0);
        self.productPrice.textColor = kBlackTextColor;
        [self addSubview:self.productPrice];
        
        _separatorLine = [[UIView alloc]initWithFrame:CGRectZero];
        _separatorLine.backgroundColor = kSeparatorColor;
        [self addSubview:_separatorLine];
        
        
    }
    return self;

}

-(void)layoutSubviews
{
    [super layoutSubviews];
    CGSize size = self.bounds.size;
    
    //Item Image
    CGSize sizeOfImageView = (CGSize){cellProductImageW,cellProductImageH};
    _productImage.frame = (CGRect){kProductDescriptionPadding,topPaddingInCell,sizeOfImageView};
    
    //Separator
    CGFloat thickness = 1.0 ;
    _separatorLine.frame = CGRectMake(0, size.height - thickness, size.width, thickness);
    
    CGFloat availableWForProductName = size.width - (kProductDescriptionPadding*3+sizeOfImageView.width);

    //ProductBrand
    CGSize sizeOfBrandName = _productBrand.intrinsicContentSize;
    _productBrand.frame = (CGRect){CGRectGetMaxX(self.productImage.frame)+kProductDescriptionPadding,topPaddingInCell,availableWForProductName,sizeOfBrandName.height};
    
    //Product Name
    CGSize sizeOfProductName = [EYUtility sizeForString:_productName.text font:_productName.font width:availableWForProductName];
    _productName.frame = (CGRect){_productBrand.frame.origin.x,CGRectGetMaxY(_productBrand.frame)+ spaceBetweenLines,availableWForProductName,sizeOfProductName.height};
    
     //Price Label
    CGSize sizeOfPriceLabel = _productPrice.intrinsicContentSize;
    _productPrice.frame = (CGRect){_productBrand.frame.origin.x,CGRectGetMaxY(_productName.frame)+ spaceBetweenLines,sizeOfPriceLabel};
    
}

-(void)setHeaderDetails:(EYProductsInfo *)productModelReceived withReceivedRentalPeriod:(NSInteger)rental
{
    self.productToAdd = productModelReceived;
    
    for (EYProductResizeImages * productResizeImage in productModelReceived.productResizeImages)
    {
        if ([productResizeImage.imageTag isEqual:@"front"] )
        {
            if ([productResizeImage.imageSize isEqual:@"large"])
            {
                _thumbnailImage = productResizeImage.image;
            }
        }
    }
    
    self.productName.text = productModelReceived.productName;
    self.productBrand.text = productModelReceived.brandName;
    self.productPrice.font = AN_MEDIUM(16.0);
//    if (rental == 4 || rental == 0)
//    {
//        self.productPrice.text = [[EYUtility shared] getCurrencyFormatFromNumber:[productModelReceived.fourDayRentalPrice floatValue]];
//    }
//    else
//    {
//        self.productPrice.text = [[EYUtility shared] getCurrencyFormatFromNumber:[productModelReceived.eightDayRentalPrice floatValue]];
//
//    }
    self.productPrice.text = [[EYUtility shared] getCurrencyFormatFromNumber:[productModelReceived.originalPrice floatValue]];


    NSURL *url = [NSURL URLWithString:_thumbnailImage];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    UIImage *img = [[UIImageView sharedImageCache] cachedImageForRequest:request];
    if (img)
    {
        [self.productImage cancelImageRequestOperation];
        self.productImage.image = img;
        self.productImage.contentMode = UIViewContentModeScaleAspectFill;
        [self setNeedsLayout];
        return;
    }
    
    __weak __typeof(self)weakSelf = self;
    
    [self.productImage setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        [weakSelf processImage:image];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        [weakSelf processImage:nil];
    }];
    
    [self setNeedsLayout];
}


//-(void)updateHeaderPriceAsPerRentSelected:(NSInteger)rentalPeriod
//{
//    if (rentalPeriod == 4 || rentalPeriod == 0)
//    {
//        self.productPrice.text = [[EYUtility shared] getCurrencyFormatFromNumber:[self.productToAdd.fourDayRentalPrice floatValue]];
//    }
//    else
//    {
//        self.productPrice.text = [[EYUtility shared] getCurrencyFormatFromNumber:[self.productToAdd.eightDayRentalPrice floatValue]];
//    }
//    [self setNeedsLayout];
//}
-(void)processImage:(UIImage*)image
{
    [self.productImage setImage:image];
}

+(CGFloat)requiredHeightforViewWithWidth:(CGFloat)width andProduct:(EYAllOrdersMtlModel*)productInfo
{
    CGFloat h = 0.0;
    CGSize sizeOfImageView = (CGSize){cellProductImageW,cellProductImageH};
    CGFloat availableWForProductName = width - (kProductDescriptionPadding*3+sizeOfImageView.width);

        EYAllOrdersMtlModel *prodctInfo = (EYAllOrdersMtlModel*)(productInfo);
        CGSize sizeOfName = [EYUtility sizeForString:prodctInfo.productName font:AN_REGULAR(14.0) width:availableWForProductName];
        CGSize sizeOfBrand = [EYUtility sizeForString:prodctInfo.brandName font:AN_MEDIUM(14.0) width:availableWForProductName];
      
        NSString *sizeStr;
        if (!([prodctInfo.size isEqualToString:@"Free Size"]|| [prodctInfo.size isEqualToString:@"free size"]))
        {
            sizeStr = [NSString stringWithFormat:@"Size %@",prodctInfo.size];
        }
        else
        {
           sizeStr = @"Size Free";
        }
    
    CGSize sizeOfSizeStr = [EYUtility sizeForString:sizeStr font:AN_MEDIUM(13.0) width:availableWForProductName];
  
    CGFloat heightOfAllText = sizeOfName.height + sizeOfBrand.height + sizeOfSizeStr.height + spaceBetweenLines*2;
    
    h+=MAX(heightOfAllText, sizeOfImageView.height);
    
    h+=topPaddingInCell + kProductDescriptionPadding + 1.0;
    return h;
}

-(void)updateOrderDetailSummaryView:(EYAllOrdersMtlModel *)orderInfo
{
    self.productName.text = orderInfo.productName;
    self.productBrand.text = orderInfo.brandName;
    self.productPrice.font = AN_MEDIUM(13.0);
    
    NSURL *url = [NSURL URLWithString:orderInfo.productThumbnailImage];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    UIImage *img = [[UIImageView sharedImageCache] cachedImageForRequest:request];
    if (img)
    {
        [self.productImage cancelImageRequestOperation];
        self.productImage.image = img;
        self.productImage.contentMode = UIViewContentModeScaleAspectFill;
        [self setNeedsLayout];
    }
    else
    {
        __weak __typeof(self)weakSelf = self;
        
        [self.productImage setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            [weakSelf processImage:image];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            [weakSelf processImage:nil];
        }];

    }
    
    
    if (!([orderInfo.size isEqualToString:@"Free Size"] || [orderInfo.size isEqualToString:@"free size"]))
    {
        self.productPrice.text = [NSString stringWithFormat:@"Size %@",orderInfo.size];
    }
    else
    {
        self.productPrice.text = @"Size Free";
    }
    
    [self setNeedsLayout];

}

-(CGFloat)getHeight:(CGFloat)width
{
    CGFloat h = 0.0;
    
    CGSize sizeOfImageView = (CGSize){cellProductImageW,cellProductImageH};
    
    CGFloat availableWForProductName = width - (kProductDescriptionPadding*3+sizeOfImageView.width);
    //Product Name
    CGSize sizeOfText1 = [EYUtility sizeForString:_productName.text font:_productName.font width:availableWForProductName];
    CGSize sizeOfText2 = _productBrand.intrinsicContentSize;
    CGSize sizeOfText3 = _productPrice.intrinsicContentSize;
    
    CGFloat heightOfAllText = sizeOfText1.height + sizeOfText3.height + sizeOfText2.height + spaceBetweenLines*2;
    
    h+=MAX(heightOfAllText, sizeOfImageView.height);
    
    h+=topPaddingInCell + kProductDescriptionPadding + 1.0;
    
    return h;
}

@end
