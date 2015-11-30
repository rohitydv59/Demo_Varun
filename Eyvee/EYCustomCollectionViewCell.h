//
//  EYCustomCollectionViewCell.h
//  Eyvee
//
//  Created by Varun Kapoor on 14/10/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EYCustomButton;

@interface EYCustomCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) EYCustomButton *colorBtn;
@property (nonatomic)bool isCircled;

-(void)updatingColor:(NSString *) colorValue;
@end
