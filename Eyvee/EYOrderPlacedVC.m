//
//  EYOrderPlacedVC.m
//  Eyvee
//
//  Created by Rohit Yadav on 15/10/15.
//  Copyright © 2015 Neetika Mittal. All rights reserved.
//

#import "EYOrderPlacedVC.h"
#import "EYTabContainer.h"

@interface EYOrderPlacedVC ()

@property (nonatomic, strong) IBOutlet UILabel *messageLbl;

@end

@implementation EYOrderPlacedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.message) {
        [self.messageLbl setText:self.message];
    }
    self.title = @"Order Completed";
    
    [self.navigationItem.leftBarButtonItem setTarget:self];
//    
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"arrow_left"] style:UIBarButtonItemStylePlain target:self action: @selector(backbtnClicked:)];
    self.navigationItem.leftBarButtonItem = back;
    
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doneClicked:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
    //EYTabContainer *tabContainerVC = [[EYTabContainer alloc]initWithNibName:nil bundle:nil];
    //[self.navigationController setViewControllers:@[tabContainerVC] animated:YES];
    
}

- (IBAction)backbtnClicked:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
