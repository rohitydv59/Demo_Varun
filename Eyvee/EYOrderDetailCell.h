//
//  EYOrderDetailCell.h
//  Eyvee
//
//  Created by Disha Jain on 24/08/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    EYOrderDetailLabel,
    EYBagSummaryLabel,
    EYReviewOrderLabel
}EYLabelCellMode;

@interface EYOrderDetailCell : UITableViewCell

@property (strong,nonatomic) UILabel *leftLabel;
@property (strong,nonatomic) UILabel *rightLabel;
@property (assign,nonatomic) EYLabelCellMode cellMode;

-(void)updateCellDataWithLeftLabel:(NSString*)leftLabelText andRightLabel:(NSString*)rightLabelText andMode:(EYLabelCellMode)mode;
+(CGFloat)getHeightForCellWithLeftLabel:(NSString*)leftText leftLabelFont:(UIFont*)leftfont rightLabelText:(NSString*)rightText rightLabelFont:(UIFont*)rightFont;
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withMode:(EYLabelCellMode)mode;
@end
