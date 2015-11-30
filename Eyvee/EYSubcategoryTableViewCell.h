//
//  EYSubcategoryTableViewCell.h
//  Eyvee
//
//  Created by Disha Jain on 03/09/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EYSlidersMtlModel.h"

@protocol EYSubcategoryTableViewCellDelegate <NSObject>

- (void)leftBtnTapped:(id)sender withId:(NSArray*)subCatId andSliderModel:(EYSlidersMtlModel*)sliderModel andSubCategoryName:(NSString*)subCategoryName andFilePath:(NSString*)dataFile;
- (void)rightBtnTapped:(id)sender withId:(NSArray*)subCatId andSliderModel:(EYSlidersMtlModel*)sliderModel andSubCategoryName:(NSString*)subCategoryName andFilePath:(NSString*)dataFile;

@end

@interface EYSubcategoryTableViewCell : UITableViewCell
@property (strong,nonatomic) EYSlidersMtlModel *sliderModelReceived;

@property (nonatomic, weak) id <EYSubcategoryTableViewCellDelegate> delegate;
-(void)setLeftItem:(NSString *)leftItem setRightItem:(NSString*)rightItem;

@end
