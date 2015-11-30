//
//  EYBagSummaryCell.h
//  Eyvee
//
//  Created by Disha Jain on 16/09/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EYProductInCartInfo.h"
@class EYSyncCartProductDetails;

@protocol EditBagItemDelegate <NSObject>

- (void)editBagItemWitProductDetails:(EYSyncCartProductDetails *)product;
- (void)removeBagItemWitProductDetails:(EYSyncCartProductDetails *)product;

@end

@interface EYBagSummaryCell : UITableViewCell

//@property (strong,nonatomic)EYProductInCartInfo *cartProduct;
@property (strong,nonatomic)EYSyncCartProductDetails *currentProduct;
@property (nonatomic,weak) id<EditBagItemDelegate> delegate;
+(CGFloat)requiredHeightForRowWithCartObject:(EYSyncCartProductDetails*)cartProduct andTotalWidth:(CGFloat)width;
@end
