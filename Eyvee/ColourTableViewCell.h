//
//  ColourTableViewCell.h
//  EyveeFilterView
//
//  Created by Varun Kapoor on 12/08/15.
//  Copyright (c) 2015 Varun Kapoor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EYGetAllProductsMTLModel.h"
@class ColourTableViewCell;

@protocol ColourTableViewCellDelegate
@optional
-(void) colorButtonClicked:(BOOL) isButtonClicked andSelectedIndex:(NSInteger)selectedIndex;
@end

@interface ColourTableViewCell : UITableViewCell
@property (weak,nonatomic)id <ColourTableViewCellDelegate> delegate;
@property (strong,nonatomic)EYProductFilters * colorFilterModel;
@property (nonatomic, strong) NSMutableArray * cellArray;

@end
