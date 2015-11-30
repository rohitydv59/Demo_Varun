//
//  EYBottomButton.h
//  Eyvee
//
//  Created by Disha Jain on 15/09/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EYBottomButton : UIControl

@property (strong,nonatomic)NSString *buttonString;

-(instancetype)initWithFrame:(CGRect)frame image:(NSString*)imageString ButtonText:(NSString*)buttonLabel andFont:(UIFont*)font;
@end
