//
//  CheckBoxTableViewCell.h
//  EyveeFilterView
//
//  Created by Varun Kapoor on 11/08/15.
//  Copyright (c) 2015 Varun Kapoor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckBoxTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel * label;
@property (nonatomic ,weak) IBOutlet UIButton *checkBoxButton;

@property (nonatomic, assign) BOOL isCellSelected;

@end
