//
//  EYCustomAccessoryViewCell.h
//  Eyvee
//
//  Created by Disha Jain on 16/09/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EYConstant.h"
#import "EYShippingAddressMtlModel.h"

typedef enum
{
    imageView,
    switchView
}accessoryType;

@protocol EYCustomAccessoryViewCellDelegate <NSObject>
@optional

- (void)editAddressAtIndex:(NSInteger )index;
- (void)removeAddressAtIndex:(NSInteger )index;
- (void)selectAddressAtIndex:(NSInteger )index;

@end

@interface EYCustomAccessoryViewCell : UITableViewCell

@property (nonatomic, assign) accessoryType accessoryViewType;
@property (nonatomic, weak) id<EYCustomAccessoryViewCellDelegate> delegate;
//@property (nonatomic, assign) EYCustomAccessoryViewCellType cellTypeForImg;
@property (strong,nonatomic) UISwitch *switchView;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier rowText:(NSString*)text andAccessoryViewType:(accessoryType)type andMode:(EYCustomAccessoryViewCellType)mode;

+(CGFloat)requiredHeightForCellWithText:(NSString*)text andFont:(UIFont*)font andCellWidth:(CGFloat)width;

- (void)populateCellWithText:(NSString *)rowText andFont:(UIFont*)font andTextColor:(UIColor*)color;

-(void)populateCellWithAttributedText:(NSAttributedString *)rowText;

+(CGFloat)requiredHeightForCellWithAttributedText:(NSAttributedString *)text andCellWidth:(CGFloat)width andMode:(EYCustomAccessoryViewCellType)mode;
-(void)setImageAsPerCellType:(EYCustomAccessoryViewCellType)type;
@end
