//
//  CheckBoxTableViewCell.m
//  EyveeFilterView
//
//  Created by Varun Kapoor on 11/08/15.
//  Copyright (c) 2015 Varun Kapoor. All rights reserved.
//

#import "CheckBoxTableViewCell.h"

@interface CheckBoxTableViewCell ()

@end

@implementation CheckBoxTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    self.isCellSelected = NO;

    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
