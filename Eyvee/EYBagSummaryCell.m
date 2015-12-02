//
//  EYBagSummaryCell.m
//  Eyvee
//
//  Created by Disha Jain on 16/09/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "EYBagSummaryCell.h"
#import "EYConstant.h"
#import "EYUtility.h"
#import "EYSyncCartMtlModel.h"
#import "UIImageView+AFNetworking.h"

@interface EYBagSummaryCell()
@property (strong, nonatomic) UIImageView *itemImage;
@property (strong, nonatomic) UILabel *productBrand;
@property (strong, nonatomic) UILabel *productName;
@property (strong, nonatomic) UILabel *productPrice;
@property (strong, nonatomic) UILabel *productSize;
@property (strong, nonatomic) UIButton *buttonEdit;
@property (strong, nonatomic) UIButton *buttonRemove;
@property (strong, nonatomic) UIView *buttonSeparator;
@property (strong, nonatomic) UIView *separatorLine;


@end

@implementation EYBagSummaryCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
       
        [self setUp];
    }
    return self;
    
}
-(void)setUp
{
    self.itemImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.itemImage.contentMode = UIViewContentModeScaleAspectFill;
    [self.itemImage setClipsToBounds:YES];
    [self.itemImage setBackgroundColor:kLightGrayBgColor];

    [self.contentView addSubview:self.itemImage];
    
    self.productName = [[UILabel alloc] initWithFrame:CGRectZero];
    self.productName.numberOfLines = 0;
    self.productName.textColor = kRowLeftLabelColor;
    self.productName.font = AN_REGULAR(14.0);
    self.productName.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.productName];
    
    self.productBrand = [[UILabel alloc] initWithFrame:CGRectZero];
    self.productBrand.numberOfLines = 1;
    self.productBrand.font = AN_MEDIUM(14.0);
    self.productBrand.textColor = kBlackTextColor;
    self.productBrand.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.productBrand];
    
    self.productSize = [[UILabel alloc] initWithFrame:CGRectZero];
    self.productSize.numberOfLines = 1;
    self.productSize.font = AN_MEDIUM(13.0);
    self.productSize.textAlignment = NSTextAlignmentLeft;
    self.productSize.textColor = kBlackTextColor;
    [self.contentView addSubview:self.productSize];
    
    self.productPrice = [[UILabel alloc] initWithFrame:CGRectZero];
    self.productPrice.numberOfLines = 1;
    self.productPrice.textAlignment = NSTextAlignmentLeft;
    self.productPrice.font = AN_MEDIUM(13.0);
    self.productPrice.textColor = kBlackTextColor;
    [self.contentView addSubview:self.productPrice];
    
    self.buttonEdit = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.buttonEdit setTitle:@"EDIT" forState:UIControlStateNormal];
    self.buttonEdit.titleLabel.font = AN_BOLD(11.0);
    [self.buttonEdit setTitleColor:kBlackTextColor forState:UIControlStateNormal];
    self.buttonEdit.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.buttonEdit addTarget:self action:@selector(editProduct) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.buttonEdit];
    
    self.buttonRemove = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.buttonRemove setTitle:@"REMOVE" forState:UIControlStateNormal];
    [self.buttonRemove setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.buttonRemove.titleLabel.font = AN_BOLD(11.0);

    [self.buttonRemove setTitleColor:kBlackTextColor forState:UIControlStateNormal];
    self.buttonRemove.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.buttonRemove addTarget:self action:@selector(removeProduct) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.buttonRemove];
    
    _separatorLine = [[UIView alloc]initWithFrame:CGRectZero];
    _separatorLine.backgroundColor = kSeparatorColor;
    [self addSubview:_separatorLine];
    
    _buttonSeparator = [[UIView alloc]initWithFrame:CGRectZero];
    _buttonSeparator.backgroundColor = kBlackTextColor;
    [self addSubview:_buttonSeparator];
    
}


-(void)setCurrentProduct:(EYSyncCartProductDetails *)cartProduct
{
    _currentProduct = cartProduct;
    _productBrand.text = cartProduct.brandName;
    _productName.text = cartProduct.productName;
    _productPrice.text = [NSString stringWithFormat:@"%@",[[EYUtility shared]getCurrencyFormatFromNumber:[cartProduct.rentalPrice floatValue]]] ;
    
    for (EYProductResizeImages * productResizeImage in cartProduct.productResizeImages)
    {
        if ([productResizeImage.imageSize isEqual:@"thumbnail"] && [productResizeImage.imageTag isEqual:@"front"])
        {
            [_itemImage setImageWithURL:[NSURL URLWithString:productResizeImage.image] placeholderImage:nil];
        }
    }
    if (cartProduct.size == nil || [cartProduct.size isEqualToString:@"free size"])
    {
        _productSize.text = [NSString stringWithFormat:@"Free Size"];
    }
    else
    {
        _productSize.text = [NSString stringWithFormat:@"Size %@",cartProduct.size];
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    CGSize size = self.bounds.size;
    
    //Item Image
    CGSize sizeOfImageView = (CGSize){64,96};

    _itemImage.frame = (CGRect){kProductDescriptionPadding,16.0,sizeOfImageView};
    
    //Separator
    CGFloat thickness = 1.0 ;
    
    _separatorLine.frame = CGRectMake(0, size.height - thickness, size.width, thickness);
    
    //Price Label
    CGSize sizeOfPriceLabel = _productPrice.intrinsicContentSize;
    
     CGFloat availableWForProductName = size.width - (kProductDescriptionPadding*3 + sizeOfPriceLabel.width + 8.0 + sizeOfImageView.width);
    
    _productPrice.frame = (CGRect){size.width - kProductDescriptionPadding - sizeOfPriceLabel.width,16.0,sizeOfPriceLabel};
    
    //ProductBrand
    
    CGSize sizeOfBrandName = _productBrand.intrinsicContentSize;
    _productBrand.frame = (CGRect){CGRectGetMaxX(self.itemImage.frame)+kProductDescriptionPadding,16.0,availableWForProductName,sizeOfBrandName.height};
    
    //Product Name
    
    CGSize sizeOfProductName = [EYUtility sizeForString:_productName.text font:AN_REGULAR(14.0) width:availableWForProductName];
    
    _productName.frame = (CGRect){_productBrand.frame.origin.x,CGRectGetMaxY(_productBrand.frame)+ 6.0,availableWForProductName,sizeOfProductName.height};
    
    //Button Edit
    CGSize sizeOfButtonText = [EYUtility sizeForString:_buttonEdit.titleLabel.text font:_buttonEdit.titleLabel.font];
    
    _buttonEdit.frame = (CGRect){_productBrand.frame.origin.x,size.height - 4.0 - 44.0,sizeOfButtonText.width,44.0};
    
    CGPoint pointInView = [_buttonEdit convertPoint:_buttonEdit.titleLabel.frame.origin toView:self.contentView];
    
    //Button Separator
    _buttonSeparator.frame = (CGRect){CGRectGetMaxX(_buttonEdit.frame) + 12.0,pointInView.y+2.0,thickness,8.0};
    
    //Button Remove
    sizeOfButtonText = [EYUtility sizeForString:_buttonRemove.titleLabel.text font:_buttonRemove.titleLabel.font];
    _buttonRemove.frame = (CGRect){CGRectGetMaxX(_buttonSeparator.frame)+12,size.height - 4.0-44.0,sizeOfButtonText.width,44.0};
    
    
    //Product Size
    
    CGSize sizeOfProductSize = _productSize.intrinsicContentSize;
    _productSize.frame = (CGRect){_productBrand.frame.origin.x,CGRectGetMaxY(_productName.frame)+6.0,sizeOfProductSize};
    
}

+(CGFloat)requiredHeightForRowWithCartObject:(EYSyncCartProductDetails*)cartProduct andTotalWidth:(CGFloat)width
{
    //compute dynamic height
    CGFloat h = 0.0;
    
    CGSize sizeOfImageView = (CGSize){64,96};
    
    CGSize sizeOfBrandName = [EYUtility sizeForString:cartProduct.brandName font:AN_MEDIUM(14.0)];
    
    CGSize sizeOfPriceLabel = [EYUtility sizeForString:[NSString stringWithFormat:@"%@",[[EYUtility shared]getCurrencyFormatFromNumber:[cartProduct.rentalPrice floatValue]]] font:AN_MEDIUM(16.0)];
    
    CGFloat availableWForProductName = width - (kProductDescriptionPadding*3 + sizeOfPriceLabel.width + 8.0 + sizeOfImageView.width);
    CGSize sizeOfProductName = [EYUtility sizeForString:cartProduct.productName font:AN_REGULAR(14.0) width:availableWForProductName];
    
    NSString *dummySize;
    if (cartProduct.size == nil || [cartProduct.size isEqualToString:@"free size"]) {
        dummySize = @"";
    }
    else
    {
        dummySize = [NSString stringWithFormat:@"Free Size"];
    }
    
    CGSize sizeOfProductSize = [EYUtility sizeForString:dummySize font:AN_MEDIUM(13.0)];
    
    CGFloat sum = sizeOfBrandName.height + sizeOfProductName.height +sizeOfProductSize.height + 6.0*2   ;
    h+=sum + 4 + 44.0 + 16.0 + 1;
    return h;
    
}


#pragma mark Button Actions

- (void)editProduct
{
    if (_delegate && [_delegate respondsToSelector:@selector(editBagItemWitProductDetails:)])
    {
        [_delegate editBagItemWitProductDetails:_currentProduct];
    }
}

- (void)removeProduct
{
    if (_delegate && [_delegate respondsToSelector:@selector(removeBagItemWitProductDetails:)])
    {
        [_delegate removeBagItemWitProductDetails:_currentProduct];
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
