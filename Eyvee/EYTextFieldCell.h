//
//  EYTextFieldCell.h
//  Eyvee
//
//  Created by Disha Jain on 14/09/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EYAddressTextField.h"

typedef enum
{
    shippingVC = 0,
    addToCartVC = 1,
    addPromoCode = 2
    
}textFieldMode;

@interface EYTextFieldCell : UITableViewCell
@property (nonatomic, strong) EYAddressTextField *textfield;
@property (nonatomic, strong) NSString *cellName;
@property (nonatomic, assign) textFieldMode mode;
@property (nonatomic, strong) UIButton *rightButton;

+ (CGFloat)requiredHeightForCell:(NSString *)titletext width:(float)width;
- (void)setLabelText:(NSString*)textValue andPlaceholderText:(NSString*)placeholder;
- (void)updateTextFieldMode:(textFieldMode)mode;
- (void)configUserDetailsCellForIndexPath:(NSIndexPath *)indexPath;
- (void)setTextInTextfield:(NSString *)text ForIndexPath :(NSIndexPath *)indexpath;


@end
