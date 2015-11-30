//
//  EYBadgeButton.h
//  Eyvee
//
//  Created by Rohit Yadav on 16/10/15.
//  Copyright © 2015 Neetika Mittal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EYBadgeButton : UIButton

- (void)setBadgeText:(NSString *)badgeText;
- (CGSize)requiredSize;

@end
