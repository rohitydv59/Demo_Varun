//
//  PriceTableViewCell.h
//  EyveeFilterView
//
//  Created by Varun Kapoor on 12/08/15.
//  Copyright (c) 2015 Varun Kapoor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RangeSlider.h"

@interface PriceTableViewCell : UITableViewCell
@property(nonatomic, weak) IBOutlet RangeSlider * rangeSlider;
@property(nonatomic, weak) IBOutlet UILabel * fromPriceLabel;
@property(nonatomic, weak) IBOutlet UILabel * toPriceLabel;
-(void) updateCell;
@end
