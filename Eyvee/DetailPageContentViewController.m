//
//  DetailPageContentViewController.m
//  Eyvee
//
//  Created by Varun Kapoor on 02/09/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "DetailPageContentViewController.h"
#import "UIImageView+AFNetworking.h"

@interface DetailPageContentViewController ()
@end

@implementation DetailPageContentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.headerImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.headerImageView];

    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    [self.view addGestureRecognizer:singleTap];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    [self.headerImageView setFrame:self.view.bounds];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setImageURL:(NSString *)largeImageURL
{
    [self setImageURL:largeImageURL placeHolderImage:nil];
}

- (void)setImageURL:(NSString *)largeImageURL placeHolderImage:(UIImage *)image
{
//    [self.headerImageView setImageWithURL:[NSURL URLWithString:largeImageURL] placeholderImage:image];
    [self.headerImageView setImage:[UIImage imageNamed:largeImageURL]];

}

- (void)singleTap:(UIGestureRecognizer *)recog
{
    if ([_delegate respondsToSelector:@selector(didSingleTapInDetailPageContentViewController:)])
    {
        [_delegate didSingleTapInDetailPageContentViewController:self];
    }
}

@end
