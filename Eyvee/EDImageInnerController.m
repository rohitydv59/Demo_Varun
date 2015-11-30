//
//  EDImageInnerController.m
//  EazyDiner
//
//  Created by Shubham Mandal on 03/06/15.
//  Copyright (c) 2015 Pulkit Arora. All rights reserved.
//

#import "EDImageInnerController.h"
#import "EDImageScrollView.h"

@interface EDImageInnerController () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) EDImageScrollView * scrollView;

@end

@implementation EDImageInnerController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
    _scrollView = [[EDImageScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_scrollView];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    [self.view addGestureRecognizer:singleTap];

//  Double tap adds delay to single tap. Enable only if required.
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self.scrollView action:@selector(scrollViewDoubleTapped:)];
    doubleTap.numberOfTapsRequired = 2;
    [singleTap requireGestureRecognizerToFail:doubleTap];
    [self.scrollView addGestureRecognizer:doubleTap];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.scrollView setImageURL:_imageStr];
    [_scrollView setLargeImageStr:self.largeImageStr];
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    _scrollView.frame = self.view.bounds;
}

- (void)singleTap:(UIGestureRecognizer *)recog
{
    if ([_delegate respondsToSelector:@selector(didSingleTapInViewController:)]) {
        [_delegate didSingleTapInViewController:self];
    }
}

@end
