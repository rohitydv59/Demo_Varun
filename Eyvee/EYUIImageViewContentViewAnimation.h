//
//  EYUIImageViewContentViewAnimation.h
//
//  Created by Varun Kapoor on 21.08.15.
//  Copyright (c) 2015 Varun Kapoor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EYUIImageViewContentViewAnimation : UIImageView

-(UIImage*)imageMH;
-(void)animateToViewMode:(UIViewContentMode)contenMode
                forFrame:(CGRect)frame
            withDuration:(float)duration
              afterDelay:(float)delay
                finished:(void (^)(BOOL finished))finishedBlock;
- (id)initWithFrame:(CGRect)frame withImageViewFrame:(CGRect) imageViewFrame;

@end