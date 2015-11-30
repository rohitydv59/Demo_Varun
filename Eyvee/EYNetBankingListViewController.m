//
//  EYNetBankingListViewController.m
//  Eyvee
//
//  Created by Disha Jain on 12/10/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "EYNetBankingListViewController.h"
#import "EYUtility.h"
#import "EYConstant.h"
#import "EYPayUResponseMtlModel.h"
#import "TableViewCellWithSeparator.h"
#import "EYPaymentWebController.h"

@interface EYNetBankingListViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation EYNetBankingListViewController
static NSString *cellIdentifier = @"netBankingListCell";

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    self =  [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    }
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"All Banks Available";
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone ;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:_tableView];
    _tableView.tableFooterView = [[UIView alloc]init];
    
    [self.tableView registerClass:[TableViewCellWithSeparator class] forCellReuseIdentifier:cellIdentifier];

}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    CGRect rect = self.view.bounds;
    self.tableView.frame = rect;
}

#pragma mark table view data source and delegates

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _allBanks.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableViewCellWithSeparator *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    [cell setIsFilterMode:NO];
    EYPayUResponseDetailsMtlModel *mdl = self.allBanks[indexPath.row];
    [cell updateTextOfLabel:mdl.title];
    [cell updateCellFont:AN_REGULAR(14.0)];
    [cell updateCellFontColor:kRowLeftLabelColor];
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EYPayUResponseDetailsMtlModel *model = self.allBanks[indexPath.row];
    [self openNetbankingController:model];
    return;
 
}

- (void)openNetbankingController:(EYPayUResponseDetailsMtlModel *)detailModel
{
    NSURLRequest *request = [self.dataReceived getRequestForNetbanking:detailModel];
    EYPaymentWebController *webCont = [[EYPaymentWebController alloc] initWithNibName:nil bundle:nil];
    [webCont setRequest:request];
    [self.navigationController pushViewController:webCont animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
