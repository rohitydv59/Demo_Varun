//
//  ScrollButtonsTableViewCell.h
//  Eyvee
//
//  Created by Disha Jain on 17/08/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EYSelectSizeView.h"


typedef enum
{
    filterMode,
    productSizesMode
}sizeMode;

@interface ScrollButtonsTableViewCell : UITableViewCell

@property (strong,nonatomic) EYSelectSizeView *sizeView;

@property (assign,nonatomic)sizeMode modeReceived;

@property (strong,nonatomic)NSArray *sizesArray;
@property (strong,nonatomic)NSArray *sizesIdsArray;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andMode:(sizeMode)mode andArrayOfValues:(NSArray*)array andArrayOfValueIds:(NSArray *)valueIds;

+(CGFloat)requiredHeightForRowWithFont:(UIFont*)font andText:(NSString*)text;
@end
