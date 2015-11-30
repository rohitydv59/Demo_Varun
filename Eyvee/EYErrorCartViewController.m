//
//  EYErrorCartViewController.m
//  Eyvee
//
//  Created by Disha Jain on 21/09/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "EYErrorCartViewController.h"
#import "EYUtility.h"
#import "EYConstant.h"

@interface EYErrorCartViewController ()
{
    UILabel *errorText;
}


@end

@implementation EYErrorCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor grayColor];
    
    errorText = [[UILabel alloc]initWithFrame:CGRectZero];
    errorText.font = AN_REGULAR(16);
    errorText.text = @"Please login to view the cart";
    errorText.numberOfLines = 0;
    errorText.textColor = [UIColor redColor];
    
    [self.view addSubview:errorText];
    
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    CGSize size = self.view.bounds.size;
    CGSize sizeOfText = [EYUtility sizeForString:errorText.text font:AN_REGULAR(16.0) width:size.width - 2*kcellPadding];
    
    errorText.frame = (CGRect){(size.width - sizeOfText.width)/2,(size.height - sizeOfText.height)/2,sizeOfText};
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
