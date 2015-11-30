//
//  EDImageScrollView.h
//  EazyDiner
//
//  Created by Naman Singhal on 10/07/15.
//  Copyright (c) 2015 Pulkit Arora. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EDImageScrollView : UIScrollView

@property (nonatomic, strong) NSString *largeImageStr;

- (void)setImageURL:(NSString *)imageURL;
- (void)scrollViewDoubleTapped:(UITapGestureRecognizer *)recognizer;

@end
