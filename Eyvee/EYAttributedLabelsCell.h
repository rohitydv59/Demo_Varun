//
//  EYAttributedLabelsCell.h
//  Eyvee
//
//  Created by Disha Jain on 30/09/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EYAttributedLabelsCell : UITableViewCell
@property (strong,nonatomic) UILabel *leftLabel;
@property (strong,nonatomic) UILabel *rightLabel;

-(void)setLeftLabelAttributedText:(NSAttributedString*)str;
-(void)setRightLabelAttributedText:(NSAttributedString*)str;
+(CGFloat)requiredHeightForCellWithAttributedText:(NSAttributedString *)lefttext rightLabelText:(NSAttributedString*)rightText andCellWidth:(CGFloat)width;
@end
