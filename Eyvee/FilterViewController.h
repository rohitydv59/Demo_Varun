//
//  FilterViewController.h
//  EyveeFilterView
//
//  Created by Varun Kapoor on 11/08/15.
//  Copyright (c) 2015 Varun Kapoor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EYConstant.h"
#import "EYSelectSizeView.h"
#import "ColourTableViewCell.h"
#import "EYGetAllProductsMTLModel.h"
#import "RangeSlider.h"

@class EYFilterDataModel;

@interface FilterViewController : UITableViewController <UITabBarControllerDelegate, EYSelectSizeViewDelegate,ColourTableViewCellDelegate, RangeSliderDelegate>
-(void) resettingPreferencesFilter;
@property (nonatomic ,strong) EYFilterDataModel *appliedFilterModel;
@property(nonatomic, strong) EYFilterDataModel *localFiterModel;
@property (nonatomic ,strong) EYGetAllProductsMTLModel * allProductsWithFilterModel;

@end
