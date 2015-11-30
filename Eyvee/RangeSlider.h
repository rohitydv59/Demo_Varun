//
//  RangeSlider.h
//  EyveeFilterView
//
//  Created by Varun Kapoor on 12/08/15.
//  Copyright (c) 2015 Varun Kapoor. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RangeSliderDelegate <NSObject>
@required
-(void) gettingValuesForSlider:(float)minValue withMaxValue:(float)maxValue;

@end
@interface RangeSlider : UIControl

@property(nonatomic, weak) id <RangeSliderDelegate > delegate;
@property(nonatomic) float selectedMinimumValue;
@property(nonatomic) float selectedMaximumValue;
-(void) updateTrackHighlight;
-(void) settingMinAndMaxThumb:(float) minValue withMaxValue:(float)maxValue withSelectedMinValue:(float)selectedMinValue withSelectedMaxValue:(float)selectedMaxValue;
@end
