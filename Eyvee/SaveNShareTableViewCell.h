//
//  SaveNShareTableViewCell.h
//  eyVee
//
//  Created by Disha Jain on 12/08/15.
//  Copyright (c) 2015 Disha Jain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EYButtonWithRightImage.h"

@interface SaveNShareTableViewCell : UITableViewCell

@property(strong,nonatomic)EYButtonWithRightImage *buttonSave;
@property(strong,nonatomic)EYButtonWithRightImage *buttonShare;
+(CGFloat)requiredHeightForRow;

@end
