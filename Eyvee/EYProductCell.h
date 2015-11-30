//
//  EYProductCell.h
//  Eyvee
//
//  Created by Neetika Mittal on 13/08/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+AFNetworking.h"
@class EYProductCell;
@class EYProductsInfo;
@protocol EYWishListActionDelegate <NSObject>

- (void)wishListButtonTappedWithProduct:(EYProductsInfo *)product withCell:(EYProductCell *)cell;
@end

@interface EYProductCell : UICollectionViewCell
@property (nonatomic,strong) EYProductsInfo * product;
@property (nonatomic, weak) id<EYWishListActionDelegate> delegate;


@property (nonatomic, strong) UILabel *productName;
@property (nonatomic, strong) UIImageView *productImgView;
@property (nonatomic, strong) UIButton *favBtn;

@property (nonatomic,assign)BOOL cellPositionR;

- (void)setProductImage:(NSString *)imageStr;
+ (CGFloat)heightForWidth:(CGFloat)width;
- (void)setProductPrices:(NSString*)price retailPrice:(NSString*)retailPrice;

@end
