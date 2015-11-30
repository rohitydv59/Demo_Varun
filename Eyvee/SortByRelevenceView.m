//
//  SortByRelevenceView.m
//  Eyvee
//
//  Created by Disha Jain on 18/08/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "SortByRelevenceView.h"
#import "SortByTableViewCell.h"
#import "EYConstant.h"


@interface SortByRelevenceView ()<UITableViewDataSource,UITableViewDelegate>
@property(strong,nonatomic)UITableView *tbView;
@property(strong,nonatomic)NSArray *arrayOfSortingParam;
@end

@implementation SortByRelevenceView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setUp];
        [self.tbView registerClass:[SortByTableViewCell class] forCellReuseIdentifier:@"sortCell"];
    }
    
    return self;
}

-(void)setUp
{
    self.tbView = [[UITableView alloc]initWithFrame:CGRectZero];
    self.tbView.scrollEnabled = NO;
    self.tbView.bounces = NO;
    self.tbView.dataSource = self;
    self.tbView.delegate = self;
    [self addSubview:self.tbView];
    [self.tbView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    self.tbView.backgroundColor = [UIColor whiteColor];
    self.layer.masksToBounds = NO;
    self.layer.shadowOffset = CGSizeMake(0, 1);
    self.layer.shadowRadius = 2;
    self.layer.shadowOpacity = 0.08;
    _arrayOfSortingParam = [[NSArray alloc]initWithObjects:@"Relevance",@"Price Low To High",@"Price High To Low" ,nil];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.tbView.frame = self.bounds;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrayOfSortingParam.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        SortByTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sortCell" forIndexPath:indexPath];
        cell.sortByLabel.text =_arrayOfSortingParam[indexPath.row];
        if (!_indexPathSelected)
        _indexPathSelected = [NSIndexPath indexPathForRow:0 inSection:0];
        if ([_indexPathSelected isEqual:indexPath])
        {
            cell.sortByLabel.textColor = sortButtonGreenColor;
        }
        else
        {
            cell.sortByLabel.textColor = kBlackTextColor;
        }
        return cell;
   
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate tableRowSelectedWithIndex:indexPath.row andValue:_arrayOfSortingParam[indexPath.row]];
}






@end
