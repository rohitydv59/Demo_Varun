//
//  DesignersViewController.m
//  Eyvee
//
//  Created by Varun Kapoor on 13/08/15.
//  Copyright (c) 2015 Neetika Mittal. All rights reserved.
//

#import "DesignersViewController.h"
#import "CheckBoxTableViewCell.h"
#import "EYAllAPICallsManager.h"
#import "EYAllBrandsMtlModel.h"
#import "EYUtility.h"
#import "EYError.h"
#import "EYGetAllProductsMTLModel.h"

@interface DesignersViewController ()
// array of selected cells
@property(nonatomic, strong) NSMutableArray *selectedTopCellArray;
@property(nonatomic, strong) NSMutableArray *selectedAllDesignerCellArray;

//@property (nonatomic, strong) NSArray *indexTitleArray;
@property(nonatomic, weak) IBOutlet UITableView * tbView;

@end

@implementation DesignersViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.indexTitleArray = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z"];
//    self.allDesignerDataArray = [[NSMutableArray alloc] init];
    self.selectedTopCellArray = [[NSMutableArray alloc] init];
    self.selectedAllDesignerCellArray = [[NSMutableArray alloc] init];

//    self.localFiterModel = [[EYFilterDataModel alloc] init];
//    [self.localFiterModel initialisingFilterModel];
    
//    self.localFiterModel.allDesigners = [NSMutableArray arrayWithArray:self.appliedFilterModel.allDesigners];
//    self.localFiterModel.topDesigners = [NSMutableArray arrayWithArray:self.appliedFilterModel.topDesigners];
//    self.localFiterModel.allDesignerIdArray = [NSMutableArray arrayWithArray:self.appliedFilterModel.allDesignerIdArray];
//    self.localFiterModel.topDesignerIdArray = [NSMutableArray arrayWithArray:self.appliedFilterModel.topDesignerIdArray];
    
    
    for (EYProductFilters * productFilter in self.filterProductModelArray)
    {
        if ([productFilter.name isEqualToString:@"fourdayrentalprice"] )
        {
            self.localFiterModel = [[EYFilterDataModel alloc] initWithFourDayRentalFilter:productFilter];
            self.localFiterModel.allDesigners = [NSMutableArray arrayWithArray:self.appliedFilterModel.allDesigners];
            self.localFiterModel.topDesigners = [NSMutableArray arrayWithArray:self.appliedFilterModel.topDesigners];
            self.localFiterModel.allDesignerIdArray = [NSMutableArray arrayWithArray:self.appliedFilterModel.allDesignerIdArray];
            self.localFiterModel.topDesignerIdArray = [NSMutableArray arrayWithArray:self.appliedFilterModel.topDesignerIdArray];

        }
    }
    
    // fetching Data
    [[EYAllAPICallsManager sharedManager] getAllBrandsRequestWithParameters:nil withRequestPath:kGetAllBrandsRequestPath shouldCache:YES withCompletionBlock:^(id responseObject, EYError *error)
    {
        NSArray *responseArray = (NSArray *)responseObject;
        self.allDesignerModelArray = [[NSArray alloc] initWithArray:responseArray copyItems:YES];
        [self.tbView reloadData];
    }];

}

- (NSString *)getStringForSection:(NSInteger)row
{
    NSString *rowName = @"";
    switch (row)
    {
        case 0:
        {
            if (self.topDesignerModelArray.count > 0)
            {
                rowName = kTopDesignerString;
            }
            else if (self.allDesignerModelArray.count > 0)
            {
                rowName = kAllDesignerString;
            }
            else
            {
                rowName = @"Section 1";
            }
            break;
        }
            
        case 1:
        {
            if (self.allDesignerModelArray.count > 0)
            {
                rowName = kAllDesignerString;
            }
            else
            {
                rowName = @"Section 2";
            }
            break;
            
        }
            
        default:
            break;
    }
    return rowName;
}

- (void)backTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CheckBoxTableViewCellIdentifier";
    CheckBoxTableViewCell *cell = (CheckBoxTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSString * sectionName = [self getStringForSection:indexPath.section];

    if(!cell)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CheckBoxTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    if ([sectionName isEqualToString:kTopDesignerString])
    {
        cell.tag = kTopTag + indexPath.row;
        
//        EYAllBrandsMtlModel * brandMtlModel = (EYAllBrandsMtlModel *) [self.topDesignerDataArray objectAtIndex:indexPath.row];
        EYProductFilters *filter = [self.topDesignerModelArray objectAtIndex:0];
        [cell.label setText:[filter.values objectAtIndex:indexPath.row]];
        
        for (NSDictionary * dict in self.localFiterModel.topDesigners)
        {
            if (dict)
            {
                NSNumber * selectedCellIndex = [dict objectForKey:@"selectedIndex"];
                if (![self.selectedTopCellArray containsObject:selectedCellIndex])
                {
                    [self.selectedTopCellArray addObject:selectedCellIndex];
                }
            }
        }
        
        if([self.self.selectedTopCellArray containsObject:[NSNumber numberWithInteger:indexPath.row]])
        {
            [cell.checkBoxButton setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateNormal];
            [cell.checkBoxButton setSelected:YES];
        }
        else
        {
            [cell.checkBoxButton setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
            [cell.checkBoxButton setSelected:NO];
        }
    }
    else
    {
        EYAllBrandsMtlModel * brandMtlModel = (EYAllBrandsMtlModel *) [self.allDesignerModelArray objectAtIndex:indexPath.row];
        cell.tag = kAllDesignerTag + indexPath.row;
        [cell.label setText:brandMtlModel.brandName];
        
        for (NSDictionary * dict in self.localFiterModel.allDesigners)
        {
            if (dict)
            {
                NSNumber * selectedCellIndex = [dict objectForKey:@"selectedIndex"];
                if (![self.selectedAllDesignerCellArray containsObject:selectedCellIndex])
                {
                    [self.selectedAllDesignerCellArray addObject:selectedCellIndex];
                }
            }
        }
        
        if([self.selectedAllDesignerCellArray containsObject:[NSNumber numberWithInteger:indexPath.row]])
        {
            [cell.checkBoxButton setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateNormal];
            [cell.checkBoxButton setSelected:YES];
        }
        else
        {
            [cell.checkBoxButton setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
            [cell.checkBoxButton setSelected:NO];
        }
    }
    
    return cell;
}

-(NSDictionary *) creatingFilterValueDictWithValueName:(NSString *) valueName withValueId:(NSNumber *)valueId withSelectedCellIndex:(NSNumber *) indexPath
{
    NSDictionary * filterDict = @{@"valueName": valueName,
                                  @"valueId": valueId,
                                  @"selectedIndex" :indexPath};
    return filterDict;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * sectionName = [self getStringForSection:indexPath.section];

    CheckBoxTableViewCell *cell = (CheckBoxTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];

    cell.checkBoxButton.selected = !cell.checkBoxButton.selected;
    cell.isCellSelected = cell.checkBoxButton.selected;
    if ([sectionName isEqualToString:kTopDesignerString])
    {
        EYProductFilters *filter = [self.topDesignerModelArray objectAtIndex:0];

        NSDictionary * topdesignerDict = [self creatingFilterValueDictWithValueName:[filter.values objectAtIndex:indexPath.row] withValueId:[filter.valueIds objectAtIndex:indexPath.row] withSelectedCellIndex:[NSNumber numberWithInteger:indexPath.row] ];
        NSNumber *topDesignerId = [filter.valueIds objectAtIndex:indexPath.row];

        if (cell.isCellSelected)
        {
            if(![self.selectedTopCellArray containsObject:[NSNumber numberWithInteger:indexPath.row]])
            {
                [self.selectedTopCellArray addObject:[NSNumber numberWithInteger:indexPath.row]];
            }
            if (![self.localFiterModel.topDesigners containsObject:topdesignerDict])
            {
                [self.localFiterModel.topDesigners addObject:topdesignerDict];
            }
            if (![self.localFiterModel.topDesignerIdArray containsObject:topDesignerId])
            {
                [self.localFiterModel.topDesignerIdArray addObject:topDesignerId];
            }
        }
        else
        {
            if ([self.selectedTopCellArray containsObject:[NSNumber numberWithInteger:indexPath.row]])
            {
                [self.selectedTopCellArray removeObject:[NSNumber numberWithInteger:indexPath.row]];
            }
            if ([self.localFiterModel.topDesigners containsObject:topdesignerDict])
            {
                [self.localFiterModel.topDesigners removeObject:topdesignerDict];
            }
            if ([self.localFiterModel.topDesignerIdArray containsObject:topDesignerId])
            {
                [self.localFiterModel.topDesignerIdArray removeObject:topDesignerId];
            }
        }

        [self.tbView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];

    }
    else
    {
        EYAllBrandsMtlModel * brandModel = [self.allDesignerModelArray objectAtIndex:indexPath.row];

        NSDictionary * designerDict = [self creatingFilterValueDictWithValueName:brandModel.brandName withValueId:brandModel.brandId withSelectedCellIndex:[NSNumber numberWithInteger:indexPath.row] ];
        
        NSNumber *allDesignerId = brandModel.brandId;
        if (cell.isCellSelected)
        {
            if(![self.selectedAllDesignerCellArray containsObject:[NSNumber numberWithInteger:indexPath.row]])
            {
                [self.selectedAllDesignerCellArray addObject:[NSNumber numberWithInteger:indexPath.row]];
            }
            if (![self.localFiterModel.allDesigners containsObject:designerDict])
            {
                [self.localFiterModel.allDesigners addObject:designerDict];
            }
            if (![self.localFiterModel.allDesignerIdArray containsObject:allDesignerId])
            {
                [self.localFiterModel.allDesignerIdArray addObject:allDesignerId];
            }

        }
        else
        {
            if ([self.selectedAllDesignerCellArray containsObject:[NSNumber numberWithInteger:indexPath.row]])
            {
                [self.selectedAllDesignerCellArray removeObject:[NSNumber numberWithInteger:indexPath.row]];
            }
            if ([self.localFiterModel.allDesigners containsObject:designerDict])
            {
                [self.localFiterModel.allDesigners removeObject:designerDict];
            }
            if ([self.localFiterModel.allDesignerIdArray containsObject:allDesignerId])
            {
                [self.localFiterModel.allDesignerIdArray removeObject:allDesignerId];
                
            }
        }
        [self.tbView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString * sectionName = [self getStringForSection:section];
    if ([sectionName isEqualToString:kTopDesignerString])
    {
        EYProductFilters *filter = [self.topDesignerModelArray objectAtIndex:0];
        return [filter.values count];
    }
    else
    {
        return [self.allDesignerModelArray count];
    }
}

- (NSInteger)getNumberOfSectionsCount
{
    NSInteger count = 2;
    if (self.topDesignerModelArray.count == 0)
    {
        count--;
    }
    if (self.allDesignerModelArray.count == 0)
    {
        count--;
    }
    
    return count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self getNumberOfSectionsCount];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    CGFloat sectionHeight = [self tableView:tableView heightForHeaderInSection:section];    // 52
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, sectionHeight)];
    [view setBackgroundColor:RGB(242, 246, 248)];
    
    NSString * sectionName = [self getStringForSection:section];
    
    if ([sectionName isEqualToString:kTopDesignerString])
    {
        sectionName = @"RELEVANT";
    }
    else if ([sectionName isEqualToString:kAllDesignerString])
    {
        sectionName =  @"ALL DESIGNERS";
    }
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [titleLabel setText:sectionName];
    [titleLabel setFont:AN_BOLD(11)];
    [titleLabel setTextColor:RGB(22, 37, 42)];
    
    CGSize titleSize = [EYUtility sizeForString:sectionName font:titleLabel.font width:view.frame.size.width - (2 * kTableViewLargePadding)];
    
    [titleLabel setFrame:CGRectMake(kTableViewLargePadding, sectionHeight - (titleSize.height + kcellPadding), view.frame.size.width - (2 * kTableViewLargePadding), titleSize.height)];
    [view addSubview:titleLabel];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 52;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48;
}

-(void) resettingDesingersFilter
{
//    self.appliedFilterModel = [[EYFilterDataModel alloc] init];
    [self.appliedFilterModel initialisingFilterModel];
//    self.localFiterModel = [[EYFilterDataModel alloc] init];
    [self.localFiterModel initialisingFilterModel];
    
    [self.selectedAllDesignerCellArray removeAllObjects];
    [self.selectedTopCellArray removeAllObjects];

    [self.tbView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
