//
//  EYEmptyView.m
//  Eyvee
//
//  Created by Rohit Yadav on 21/10/15.
//  Copyright © 2015 Neetika Mittal. All rights reserved.
//

#import "EYEmptyView.h"

@interface EYEmptyView()

@property (nonatomic, weak) IBOutlet UILabel * msgLabel;
@property (nonatomic, weak) IBOutlet UIImageView *msgImgView;

@end

@implementation EYEmptyView

- (void)setMessageText :(NSString *)msgText withImage:(UIImage *)image andRetryBtnHidden:(BOOL)hidden
{
    if (msgText) {
        [self.msgLabel setText:msgText];
    }
    if (image) {
        [self.msgImgView setImage:image];
    }
    self.tapToRetry.hidden = hidden; 
}
@end
