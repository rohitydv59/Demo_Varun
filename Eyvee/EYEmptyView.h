//
//  EYEmptyView.h
//  Eyvee
//
//  Created by Rohit Yadav on 21/10/15.
//  Copyright © 2015 Neetika Mittal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EYEmptyView : UIView

@property (nonatomic, weak) IBOutlet UIButton * tapToRetry;

- (void)setMessageText :(NSString *)msgText withImage:(UIImage *)image andRetryBtnHidden:(BOOL)hidden;

@end
