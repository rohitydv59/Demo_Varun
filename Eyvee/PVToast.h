//
//  MAToastView.h
//  MyAirtel
//
//  Created by Naman Singhal on 21/04/15.
//  Copyright (c) 2015 Nishit Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PVToast : NSObject

+ (PVToast *)shared;
- (void)showToastMessage:(NSString *)message;

@end
