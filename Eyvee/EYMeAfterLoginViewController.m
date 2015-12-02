//
//  EYMeAfterLoginViewController.m
//  Eyvee
//
//  Created by Disha Jain on 21/08/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "EYMeAfterLoginViewController.h"
#import "EYMyOrdersViewController.h"
#import "EYConstant.h"
#import "EYUtility.h"
#import "EYMeTableViewCell.h"
#import "EYCartModel.h"
#import "EYSyncCartMtlModel.h"
#import "EYBadgedBarButtonItem.h"
#import "EYCartModel.h"
#import "EYSyncCartMtlModel.h"

@interface EYMeAfterLoginViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView * tbView;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UILabel *footerLabel;

//Arrays For Rows
@property (nonatomic,strong)NSArray *valuesInMeSection;
@property (nonatomic,strong)NSArray *valuesInAboutSection;
@property (nonatomic,strong)NSArray *imagesInMeSection;
@property (nonatomic,strong)NSArray *imagesInAboutSection;
@property (nonatomic, strong) EYBadgedBarButtonItem *rightButton;

@end

@implementation EYMeAfterLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"My Account";
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes= @{NSForegroundColorAttributeName : kBlackTextColor,
                                                                   NSFontAttributeName : AN_MEDIUM(16.0)};
    
    UIImage *image =[ UIImage imageNamed:@"shopping_bag"];
    _rightButton = [[EYBadgedBarButtonItem alloc] initWithImage:image target:self action:@selector(actionCart:)];
    self.navigationItem.rightBarButtonItem = self.rightButton;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor blackColor];
    
    //Table View
    _tbView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tbView.delegate = self;
    _tbView.dataSource = self;
    _tbView.backgroundColor = kSectionBgColor;
    _tbView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 1)];

    [self.view addSubview:_tbView];
    
    //footer view
    _footerView = [[UIView alloc]initWithFrame:CGRectZero];
    _footerView.backgroundColor = kSectionBgColor;
    _footerLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    _footerLabel.attributedText = [self getAttributedTextForFooterLabel];
    [self.footerView addSubview:_footerLabel];

    //Static Arrays
    _valuesInMeSection = [[NSArray alloc]initWithObjects:@"ORDER HISTORY",@"SAVED ADDRESSES",@"SETTINGS",@"LOGOUT",nil];
    _valuesInAboutSection = [[NSArray alloc]initWithObjects:@"HOW IT WORKS", @"CONTACT US",@"SEND FEEDBACK",nil];
    _imagesInMeSection = @[@"recent_orders",@"saved_address",@"settings",@"logout"];
    _imagesInAboutSection = @[@"how_it_works",@"contact_us",@"send_feedback"];
    
    [self.tbView registerClass:[EYMeTableViewCell class] forCellReuseIdentifier:@"myCell"];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:kTabbarShowNotification object:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
 
    CGSize size = self.view.bounds.size;
    _tbView.frame = CGRectMake(0, 0, size.width, size.height - kTabBarHeight);
   
    NSAttributedString *attr = [self getAttributedTextForFooterLabel];
    CGSize sizeOfFooterLabel = [EYUtility sizeForAttributedString:attr width:size.width-2*kProductDescriptionPadding];
    _footerView.frame = (CGRect){0,0,size.width,12.0+sizeOfFooterLabel.height+kProductDescriptionPadding};
    _tbView.tableFooterView = _footerView;
    
    _footerLabel.frame = (CGRect){kProductDescriptionPadding,12.0,sizeOfFooterLabel};
    _footerLabel.numberOfLines = 0;
   
}

#pragma mark Table View Data source and Delegates

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return _valuesInMeSection.count ;
    }
    else
    {
        return _valuesInAboutSection.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) //Me Section
    {
        EYMeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell" forIndexPath:indexPath];
        cell.rowLabel.text = _valuesInMeSection[indexPath.row];
        cell.leftImage.image = [[UIImage imageNamed:_imagesInMeSection[indexPath.row]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        return cell;
    }
    
    else //About Us Section
    {
        EYMeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell" forIndexPath:indexPath];
        cell.rowLabel.text = _valuesInAboutSection[indexPath.row];
        cell.leftImage.image = [[UIImage imageNamed:_imagesInAboutSection[indexPath.row]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        return cell;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0.0)];
    view.backgroundColor = kSectionBgColor;
    
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,0, 0)];
    lbl.font = AN_BOLD(12.0);
    lbl.textColor = kBlackTextColor;
    [view addSubview:lbl];
    
    if (section == 0)
    {
        view.frame = CGRectMake(0, 0, self.view.frame.size.width, 52.0);
        
        NSString *email = [[NSUserDefaults standardUserDefaults]objectForKey:kUserEmailKey];
        if (email) {
            lbl.text = email;
        }
        else
            lbl.text = @"xyz@email.com";
        CGSize lblSize = lbl.intrinsicContentSize;
        lbl.frame = (CGRect){kProductDescriptionPadding, (view.frame.size.height - lblSize.height - 12.0), lblSize};
        
    }
    else
    {
        view.frame = CGRectMake(0, 0, self.view.frame.size.width, 43.0);
        lbl.text = @"About";
        lbl.frame = (CGRect){kProductDescriptionPadding,0,self.view.frame.size.width-kProductDescriptionPadding,43.0};
        
    }
   
    return view;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 52.0;
    }
    else
    {
        return 43.0 ;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            EYMyOrdersViewController *orderVC = [[EYMyOrdersViewController alloc]initWithNibName:nil bundle:nil];
            [self.navigationController pushViewController:orderVC animated:YES];
            
        }
    }
    
   
}

-(void)actionCart:(id)sender
{
    
}

-(NSAttributedString*)getAttributedTextForFooterLabel
{
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] init];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentLeft;
    
    NSDictionary *dict1 = @{NSFontAttributeName : AN_MEDIUM(11.0),
                            NSForegroundColorAttributeName : kAppLightGrayColor,
                            NSParagraphStyleAttributeName : style
                            };
    NSDictionary *dict2 = @{NSFontAttributeName : AN_MEDIUM(11.0),
                            NSForegroundColorAttributeName : kBlackTextColor,
                            NSParagraphStyleAttributeName : style
                            };
    
    
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"Copyright 2015 Demo." attributes:dict1];
    [attr appendAttributedString:str];
    str = [[NSAttributedString alloc] initWithString:@"Terms " attributes:dict2];
    [attr appendAttributedString:str];
    str = [[NSAttributedString alloc] initWithString:@"& " attributes:dict1];
    [attr appendAttributedString:str];
    str = [[NSAttributedString alloc] initWithString:@"Privacy Policy" attributes:dict2];
    [attr appendAttributedString:str];
    
    
    return attr;
    
}


@end
