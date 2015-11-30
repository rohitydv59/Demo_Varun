//
//  FavoriteTableViewCell.h
//  Eyvee
//
//  Created by Varun Kapoor on 20/09/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavoriteTableViewCell : UITableViewCell

-(void)updateCellWithTopText:(NSString*)topText withMiddleText:(NSString *)middleText withBottomText:(NSString *)bottomText;
@end
