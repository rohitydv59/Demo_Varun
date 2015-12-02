//
//  FilterViewController.m
//  EyveeFilterView
//
//  Created by Varun Kapoor on 11/08/15.
//  Copyright (c) 2015 Varun Kapoor. All rights reserved.
//

#import "FilterViewController.h"
#import "CheckBoxTableViewCell.h"
#import "PriceTableViewCell.h"
#import "RentalTableViewCell.h"
#import "DeliveryDateTableViewCell.h"
#import "EYConstant.h"
#import "EYUtility.h"
#import "ScrollButtonsTableViewCell.h"
#import "EYAllAPICallsManager.h"
#import "EYGetAllProductsMTLModel.h"
#import "EYFilterDataModel.h"
#import "EYCustomButton.h"
#import "TableViewCellWithSeparator.h"
#import "EYAddToBagViewController.h"
#import "EYCustomCollectionViewCell.h"
#import "ASCalendarController.h"

@interface FilterViewController () <ASCalendarControllerDelegate>
{
    NSInteger rentalSectionNum;
    NSInteger priceSectionNum;
}

@property (nonatomic, strong) ASCalendarController *calendar;
@property (nonatomic, strong) UIView *overlay;
@property (nonatomic, weak) IBOutlet UITableView * tbView;
@property (nonatomic) NSIndexPath* selectedIndexPath;
@property (nonatomic) NSIndexPath * previousIndexPath;
@property (nonatomic, strong) NSMutableSet *openSet;
@property (nonatomic ,strong) NSMutableArray *localFiltersProductModelArray;

//for storing selected cells
@property(nonatomic, strong) NSMutableArray *selectedOccasionCellArray;
@property(nonatomic, strong) NSMutableArray *selectedSizeCellArray;
@property(nonatomic, strong) NSMutableArray *selectedOtherCellArray;
@property(nonatomic, strong) NSMutableArray *selectedTopCellArray;

//for storing initial Mtl Model
@property (nonatomic, strong) NSMutableArray *sizeArrayValueIds;
@property (nonatomic, strong) NSMutableArray *sizeArrayValues;
@property (nonatomic ,strong) NSArray *colorIdArray;
@property (nonatomic ,strong) NSMutableArray *dateSelectedArray;

@end

@implementation FilterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.localFiltersProductModelArray = [[NSMutableArray alloc] init];
    
    self.sizeArrayValueIds = [[NSMutableArray alloc] init];
    self.sizeArrayValues = [[NSMutableArray alloc] init];
    self.colorIdArray = [[NSArray alloc] init];
    self.selectedOccasionCellArray = [[NSMutableArray alloc] init];
    self.selectedSizeCellArray = [[NSMutableArray alloc] init];
    self.selectedOtherCellArray = [[NSMutableArray alloc] init];
    self.selectedTopCellArray = [[NSMutableArray alloc] init];
    self.openSet = [[NSMutableSet alloc] init];
    self.selectedIndexPath = [NSIndexPath indexPathForRow:-1 inSection:-1];
    
    [self.tbView registerClass:[RentalTableViewCell class] forCellReuseIdentifier:@"rentalCell"];
    [self.tbView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"myCell"];

    for (EYProductFilters * productFilter in self.allProductsWithFilterModel.productsFilters)
    {
        if ([productFilter.name isEqualToString:NSLocalizedString(@"Color", @"")])
        {
            [self.localFiltersProductModelArray addObject:productFilter];
        }
    }
    for (EYProductFilters * productFilter in self.allProductsWithFilterModel.productsFilters)
    {
        if ([productFilter.name isEqualToString:NSLocalizedString(@"Size", @"")])
        {
            [self.localFiltersProductModelArray addObject:productFilter];
            break;
        }
    }
    for (EYProductFilters * productFilter in self.allProductsWithFilterModel.productsFilters)
    {
        if (!([productFilter.name isEqualToString:NSLocalizedString(@"fourdayrentalprice", @"")]) && !([productFilter.name isEqualToString:NSLocalizedString(@"eightdayrentalprice", @"")]) && !([productFilter.name isEqualToString:NSLocalizedString(@"Color", @"")]) && !([productFilter.name isEqualToString:NSLocalizedString(@"Size", @"")]))
        {
            [self.localFiltersProductModelArray addObject:productFilter];
        }
    }
    
    for (EYProductFilters * productFilter in self.allProductsWithFilterModel.allDeliveryArray)
    {
        self.localFiterModel = [[EYFilterDataModel alloc] initWithFourDayRentalFilter:productFilter];
        self.localFiterModel.rentalPeriod = self.appliedFilterModel.rentalPeriod;
        self.localFiterModel.startDate = self.appliedFilterModel.startDate;
        
        self.localFiterModel.priceRange = [NSMutableDictionary dictionaryWithDictionary:self.appliedFilterModel.priceRange];
        self.localFiterModel.occasions = [NSMutableArray arrayWithArray:self.appliedFilterModel.occasions];
        self.localFiterModel.sizes = [NSMutableArray arrayWithArray:self.appliedFilterModel.sizes];
        self.localFiterModel.colors = [NSMutableArray arrayWithArray:self.appliedFilterModel.colors];
        
        self.localFiterModel.otherFilters = [NSMutableArray arrayWithArray:self.appliedFilterModel.otherFilters];
        
        self.localFiterModel.topDesigners = [NSMutableArray arrayWithArray:self.appliedFilterModel.topDesigners];
        self.localFiterModel.topDesignerIdArray = [NSMutableArray arrayWithArray:self.appliedFilterModel.topDesignerIdArray];
        
        self.localFiterModel.colorIdArray = [NSMutableArray arrayWithArray:self.appliedFilterModel.colorIdArray];
        self.localFiterModel.sizeIdArray = [NSMutableArray arrayWithArray:self.appliedFilterModel.sizeIdArray];
        self.localFiterModel.occasionsIdArray = [NSMutableArray arrayWithArray:self.appliedFilterModel.occasionsIdArray];

        break;
    }
    for (EYProductFilters * productFilter in self.allProductsWithFilterModel.allSizeArray)
    {
        for (int i = 0; i < productFilter.valueIds.count; i++)
        {
            NSNumber * valueID = [productFilter.valueIds objectAtIndex:i];
            NSString * values = [productFilter.values objectAtIndex:i];
            if (valueID.intValue == FreeSizeID)                                  // freesize
            {
                continue;
            }
            else
            {
                [self.sizeArrayValueIds addObject:valueID];
                [self.sizeArrayValues addObject:values];
            }
        }
    }
    for (EYProductFilters * productFilter in self.allProductsWithFilterModel.allColorArray)
    {
        self.colorIdArray = productFilter.valueIds;
    }

    [self.tbView setContentInset:UIEdgeInsetsMake(-64, 0, 0, 0)];
    [self.tbView setScrollIndicatorInsets:UIEdgeInsetsMake(-64, 0, 0, 0)];
    [self.tbView reloadData];
}

- (NSString *)getStringForSection:(NSInteger)row
{
    if (row < 0)
    {
        return @"";
    }
    EYProductFilters * filter =  [self.localFiltersProductModelArray objectAtIndex:row];
    return filter.name;
}

-(void) updatingImageOfCell
{
    if (_previousIndexPath.section < 0 && _selectedIndexPath.section >= 0)
    {
        TableViewCellWithSeparator *prevCell = (TableViewCellWithSeparator *)[self.tbView cellForRowAtIndexPath:_selectedIndexPath];
        [prevCell.imgView setImage:[UIImage imageNamed:@"arrow_down"]];
    }
    else if (_previousIndexPath.section >= 0 && _selectedIndexPath.section < 0)
    {
        TableViewCellWithSeparator *prevCell = (TableViewCellWithSeparator *)[self.tbView cellForRowAtIndexPath:_previousIndexPath];
        [prevCell.imgView setImage:[UIImage imageNamed:@"arrow_right"]];
    }
    else
    {
        TableViewCellWithSeparator *prevCell = (TableViewCellWithSeparator *)[self.tbView cellForRowAtIndexPath:_previousIndexPath];
        [prevCell.imgView setImage:[UIImage imageNamed:@"arrow_right"]];
        
        TableViewCellWithSeparator *selectCell = (TableViewCellWithSeparator *)[self.tbView cellForRowAtIndexPath:_selectedIndexPath];
        [selectCell.imgView setImage:[UIImage imageNamed:@"arrow_down"]];
    }
}

-(NSDictionary *) creatingFilterValueDictWithValueName:(NSString *) valueName withValueId:(NSNumber *)valueId withSelectedCellIndex:(NSNumber *) indexPath
{
    NSDictionary * filterDict = @{@"valueName": valueName,
                                  @"valueId": valueId,
                                  @"selectedIndex" :indexPath};
    return filterDict;
}

-(NSDictionary *) creatingFilterValueDictWithValueName:(NSString *) valueName withValueId:(NSNumber *)valueId withSelectedCellIndex:(NSNumber *) indexPath WithFilterName:(NSString *) filterName
{
    NSDictionary * filterDict = @{@"valueName": valueName,
                                  @"valueId": valueId,
                                  @"selectedIndex" :indexPath,
                                  @"filterName" : filterName};
    return filterDict;
}

#pragma mark - tableview delegate and data source

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier;
    NSString *sectionName = [self getStringForSection:indexPath.section];
    
    if ([sectionName isEqualToString:kFourDayString])
    {
        rentalSectionNum = indexPath.section;
        if (indexPath.row == 0)
        {
            RentalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"rentalCell" forIndexPath:indexPath ];
            [cell.buttonDay1 addTarget:self action:@selector(rentalBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [cell.buttonDay2 addTarget:self action:@selector(rentalBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [cell updateMode:rentalCellFilter];
            [cell updateCellWithAppliedFilters:self.localFiterModel.rentalPeriod];
            return cell;
        }
        else
        {
            DeliveryDateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"deliveryCell"];
            if (!cell)
            {
                cell = [[DeliveryDateTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"deliveryCell" andMode:filterDeliveryDateMode];
            }
            [cell updateMode:filterDeliveryDateMode];
            [cell.calenderButton addTarget:self action:@selector(openCalenderController) forControlEvents:UIControlEventTouchUpInside];
            
            NSString *rentalStrtDate = [[EYUtility shared] getDateWithSuffix:_localFiterModel.startDate];
            [cell updateMiddleLabelFromDetailVC:rentalStrtDate];
            return cell;
        }
    }
    else if ([sectionName isEqualToString:kEightDayString])
    {
        priceSectionNum = indexPath.section;
        cellIdentifier = @"PriceTableViewCellIdentifier";
        PriceTableViewCell* priceCell = (PriceTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if(!priceCell)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PriceTableViewCell" owner:self options:nil];
            priceCell = [nib objectAtIndex:0];
        }
        [priceCell.rangeSlider setDelegate:self];
        
        NSMutableDictionary * rangeDict = self.localFiterModel.priceRange;
        
        float minValue = ((NSString *)[rangeDict objectForKey:@"minValue"]).floatValue;
        float maxValue = ((NSString *)[rangeDict objectForKey:@"maxValue"]).floatValue;
        float minValueSelected = ((NSString *)[rangeDict objectForKey:@"selectedMinValue"]).floatValue;
        float maxValueSelected = ((NSString *)[rangeDict objectForKey:@"selectedMaxValue"]).floatValue;
        
        [priceCell.rangeSlider settingMinAndMaxThumb:minValue withMaxValue:maxValue withSelectedMinValue:minValueSelected withSelectedMaxValue:maxValueSelected];
        [priceCell updateCell];
        return priceCell;
    }
    else if ([sectionName isEqualToString:kColorsString])
    {
        cellIdentifier = @"ColourTableViewCellIdentifier";
        ColourTableViewCell *cell = (ColourTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if(!cell)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ColourTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
            cell.colorFilterModel = [self.localFiltersProductModelArray objectAtIndex:indexPath.section];
        }
        [cell setDelegate:self];
        NSMutableArray * colArray = [[NSMutableArray alloc] init];
        for (NSDictionary * dict in self.localFiterModel.colors)
        {
            if (dict)
            {
                NSNumber * selectedCellIndex = [dict objectForKey:@"selectedIndex"];
                if (![colArray containsObject:selectedCellIndex])
                {
                    [colArray addObject:selectedCellIndex];
                }
            }
        }
        cell.cellArray = [[NSMutableArray alloc] initWithArray:colArray];
        return cell;
    }
    else if ([sectionName isEqualToString:kSizeString])                             // size
    {
        cellIdentifier = @"scrollButtons";
        ScrollButtonsTableViewCell *sizeCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        EYProductFilters * sizeFilter = [self.localFiltersProductModelArray objectAtIndex:indexPath.section];
        
        if (!sizeCell)
        {
            sizeCell = [[ScrollButtonsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier andMode:filterMode andArrayOfValues:sizeFilter.values andArrayOfValueIds:sizeFilter.valueIds];
        }
        [sizeCell.sizeView setDelegate:self];
        [sizeCell.sizeView.rightButton addTarget:self action:@selector(sizeGuideButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [sizeCell.sizeView updateButtons:self.localFiterModel.sizes];
        return sizeCell;
    }
    else if ([sectionName isEqualToString:kOccasionString])                         //occasion
    {
        if (indexPath.row == 0)
        {
            cellIdentifier = @"labelSeparator";
            TableViewCellWithSeparator* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell)
            {
                cell = [[TableViewCellWithSeparator alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            [cell setIsFilterMode:YES];
            
            [cell setBackgroundColor:kLightGrayBgColor];
            cell.isFilterMode = true;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell updateTextOfLabel:@"OCCASSION"];
            [cell.productDesc setFont:AN_BOLD(11)];
            [cell.productDesc setTextColor:kBlackTextColor];
            
            return cell;
        }
        else
        {
            cellIdentifier = @"CheckBoxTableViewCellIdentifier";
            
            CheckBoxTableViewCell *cell = (CheckBoxTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if(!cell)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CheckBoxTableViewCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            
            [cell setTag:kOccasionCellTag + indexPath.row];
            
            EYProductFilters * occasionFilter = [self.localFiltersProductModelArray objectAtIndex:indexPath.section];
            [cell.label setText:occasionFilter.values[indexPath.row - 1]];
            
            for (NSDictionary * dict in self.localFiterModel.occasions)
            {
                if (dict)
                {
                    NSNumber * selectedCellIndex = [dict objectForKey:@"selectedIndex"];
                    if (![self.selectedOccasionCellArray containsObject:selectedCellIndex])
                    {
                        [self.selectedOccasionCellArray addObject:selectedCellIndex];
                    }
                }
            }
            
            if ([self.selectedOccasionCellArray containsObject:[NSNumber numberWithInteger:indexPath.row]])
            {
                [cell.checkBoxButton setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateNormal];
                [cell.checkBoxButton setSelected:YES];
            }
            else
            {
                [cell.checkBoxButton setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
                [cell.checkBoxButton setSelected:NO];
            }
            return cell;
        }
    }
    else if ([sectionName isEqualToString:kDesignerString])                         //designer
    {
        if (indexPath.row == 0)
        {
            cellIdentifier = @"labelSeparator1";
            TableViewCellWithSeparator* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell)
            {
                cell = [[TableViewCellWithSeparator alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            [cell setIsFilterMode:YES];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell updateTextOfLabel:@"DESIGNERS"];
            [cell.productDesc setFont:AN_BOLD(11)];
            [cell.productDesc setTextColor:kBlackTextColor];
            [cell setBackgroundColor:kLightGrayBgColor];
            
            return cell;
        }
        else
        {
            cellIdentifier = @"CheckBoxTableViewCellIdentifier";
            
            CheckBoxTableViewCell *cell = (CheckBoxTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if(!cell)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CheckBoxTableViewCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            
            cell.tag = kTopTag + indexPath.row;
            
            EYProductFilters * filter = [self.localFiltersProductModelArray objectAtIndex:indexPath.section];
            
            [cell.label setText:[filter.values objectAtIndex:indexPath.row - 1]];
            
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
            
            if([self.selectedTopCellArray containsObject:[NSNumber numberWithInteger:indexPath.row]])
            {
                [cell.checkBoxButton setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateNormal];
                [cell.checkBoxButton setSelected:YES];
            }
            else
            {
                [cell.checkBoxButton setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
                [cell.checkBoxButton setSelected:NO];
            }
            return cell;
        }
    }
    else
    {
        if (indexPath.row == 0)
        {
            cellIdentifier = @"labelSeparator2";
            TableViewCellWithSeparator* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell) {
                cell = [[TableViewCellWithSeparator alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            [cell setIsFilterMode:YES];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            EYProductFilters * filter =  [self.localFiltersProductModelArray objectAtIndex:indexPath.section];
            
            NSString *uppercase = [filter.name uppercaseString];
            [cell updateTextOfLabel:uppercase];
            [cell.productDesc setFont:AN_BOLD(11)];
            [cell.productDesc setTextColor:kBlackTextColor];
            [cell setBackgroundColor:kLightGrayBgColor];
            
            return cell;
        }
        else
        {
            cellIdentifier = @"CheckBoxTableViewCellIdentifier";
            CheckBoxTableViewCell *cell = (CheckBoxTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if(!cell)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CheckBoxTableViewCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            
            cell.tag = kTopTag + indexPath.row;
            
            EYProductFilters *filter = [self.localFiltersProductModelArray objectAtIndex:indexPath.section];
            [cell.label setText:[filter.values objectAtIndex:indexPath.row - 1]];
            
            for (NSMutableDictionary * dict in self.localFiterModel.otherFilters)
            {
                if (dict)
                {
                    NSString * sectNamee = (NSString *) [dict objectForKey:@"sectionName"];
                    if ([sectNamee isEqualToString:sectionName])
                    {
                        NSMutableArray* indexArr = (NSMutableArray *)[dict objectForKey:@"indexPath"];
                        for (NSIndexPath * path  in indexArr)
                        {
                            if(path == indexPath)
                            {
                                if (![self.selectedOtherCellArray containsObject:indexPath])
                                {
                                    [self.selectedOtherCellArray addObject:indexPath];
                                }
                                
                            }
                        }
                    }
                }
            }
            
            if([self.selectedOtherCellArray containsObject:indexPath])
            {
                [cell.checkBoxButton setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateNormal];
                [cell.checkBoxButton setSelected:YES];
            }
            else
            {
                [cell.checkBoxButton setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
                [cell.checkBoxButton setSelected:NO];
            }
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *sectionName = [self getStringForSection:indexPath.section];
    
    if ([sectionName isEqualToString:kFourDayString])
    {
        if (indexPath.row == 1)
        {
            [self openCalenderController];
            [self.tbView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
    else if ([sectionName isEqualToString:kEightDayString])
    {
        
    }
    else if ([sectionName isEqualToString:kColorsString])
    {
        
    }
    else if ([sectionName isEqualToString:kSizeString])                             // size
    {
        
    }
    else if ([sectionName isEqualToString:kOccasionString])                         // for occasion
    {
        if (indexPath.row == 0)
        {
            _previousIndexPath = _selectedIndexPath;
            if (indexPath == _selectedIndexPath)
            {
                _selectedIndexPath = [NSIndexPath indexPathForRow:-1 inSection:-1];
            }
            else
            {
                _selectedIndexPath = indexPath;
            }
            
            if ([_openSet containsObject:indexPath])
            {
                [_openSet removeObject:indexPath];
                
            }
            else
            {
                [_openSet addObject:indexPath];
            }
            
            [self updatingImageOfCell];
            [self updateTableView:indexPath];
        }
        else
        {
            CheckBoxTableViewCell *cell = (CheckBoxTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
            cell.checkBoxButton.selected = !cell.checkBoxButton.selected;
            cell.isCellSelected = cell.checkBoxButton.selected;
            
            EYProductFilters * occasionFilter = (EYProductFilters*) self.allProductsWithFilterModel.allOccassionArray[0];
            NSDictionary * occasionDict = [self creatingFilterValueDictWithValueName:[occasionFilter.values objectAtIndex:indexPath.row - 1] withValueId:[occasionFilter.valueIds objectAtIndex:indexPath.row - 1] withSelectedCellIndex:[NSNumber numberWithInteger:indexPath.row] ];
            NSNumber *occasionId = [occasionFilter.valueIds objectAtIndex:indexPath.row - 1];
            
            if (cell.isCellSelected)
            {
                if (![self.selectedOccasionCellArray containsObject:[NSNumber numberWithInteger:indexPath.row]])
                {
                    [self.selectedOccasionCellArray addObject:[NSNumber numberWithInteger:indexPath.row]];
                }
                if (![self.localFiterModel.occasions containsObject:occasionDict])
                {
                    [self.localFiterModel.occasions addObject:occasionDict];
                }
                if (![self.localFiterModel.occasionsIdArray containsObject:occasionId])
                {
                    [self.localFiterModel.occasionsIdArray addObject:occasionId];
                }
            }
            else
            {
                if ([self.selectedOccasionCellArray containsObject:[NSNumber numberWithInteger:indexPath.row]])
                {
                    [self.selectedOccasionCellArray removeObject:[NSNumber numberWithInteger:indexPath.row]];
                }
                if ([self.localFiterModel.occasions containsObject:occasionDict])
                {
                    [self.localFiterModel.occasions removeObject:occasionDict];
                }
                if ([self.localFiterModel.occasionsIdArray containsObject:occasionId])
                {
                    [self.localFiterModel.occasionsIdArray removeObject:occasionId];
                }
            }
            [self.tbView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
    else if ([sectionName isEqualToString:kDesignerString])
    {
        if (indexPath.row == 0)
        {
            _previousIndexPath = _selectedIndexPath;
            if (indexPath == _selectedIndexPath)
            {
                _selectedIndexPath = [NSIndexPath indexPathForRow:-1 inSection:-1];
            }
            else
            {
                _selectedIndexPath = indexPath;
            }
            
            if ([_openSet containsObject:indexPath])
            {
                [_openSet removeObject:indexPath];
            }
            else
            {
                [_openSet addObject:indexPath];
            }
            
            [self updatingImageOfCell];
            [self updateTableView:indexPath];
        }
        else
        {
            CheckBoxTableViewCell *cell = (CheckBoxTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
            cell.checkBoxButton.selected = !cell.checkBoxButton.selected;
            cell.isCellSelected = cell.checkBoxButton.selected;
            
            EYProductFilters *filter = [self.allProductsWithFilterModel.allDesignerArray objectAtIndex:0];
            
            NSDictionary * topdesignerDict = [self creatingFilterValueDictWithValueName:[filter.values objectAtIndex:indexPath.row - 1] withValueId:[filter.valueIds objectAtIndex:indexPath.row - 1] withSelectedCellIndex:[NSNumber numberWithInteger:indexPath.row] ];
            NSNumber *topDesignerId = [filter.valueIds objectAtIndex:indexPath.row - 1];
            
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
    }
    else
    {
        if (indexPath.row == 0)
        {
            _previousIndexPath = _selectedIndexPath;
            if (indexPath == _selectedIndexPath)
            {
                _selectedIndexPath = [NSIndexPath indexPathForRow:-1 inSection:-1];
            }
            else
            {
                _selectedIndexPath = indexPath;
            }
            if ([_openSet containsObject:indexPath])
            {
                [_openSet removeObject:indexPath];
            }
            else
            {
                [_openSet addObject:indexPath];
            }
            
            [self updatingImageOfCell];
            [self updateTableView:indexPath];
        }
        else
        {
            CheckBoxTableViewCell *cell = (CheckBoxTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
            cell.checkBoxButton.selected = !cell.checkBoxButton.selected;
            cell.isCellSelected = cell.checkBoxButton.selected;
            EYProductFilters *filter = [self.localFiltersProductModelArray objectAtIndex:indexPath.section];
            NSNumber *otherValueId = [filter.valueIds objectAtIndex:indexPath.row - 1];
            if (cell.isCellSelected)
            {
                if(![self.selectedOtherCellArray containsObject:indexPath])
                {
                    [self.selectedOtherCellArray addObject:indexPath];
                }
                if (self.localFiterModel.otherFilters.count == 0)
                {
                    NSMutableArray * valueIdArray = [[NSMutableArray alloc] init];
                    NSMutableArray * indexPathArray = [[NSMutableArray alloc] init];
                    [indexPathArray addObject:indexPath];
                    [valueIdArray addObject:otherValueId];
                    NSMutableDictionary * filterDict = [[NSMutableDictionary alloc] init];
                    [filterDict setObject:indexPathArray forKey:@"indexPath"];
                    [filterDict setObject:valueIdArray forKey:@"valueIdArray"];
                    [filterDict setObject:sectionName forKey:@"sectionName"];
                    [self.localFiterModel.otherFilters addObject:filterDict];
                    
                }
                else
                {
                    for (NSMutableDictionary * dict in self.localFiterModel.otherFilters)
                    {
                        NSString *sectName = (NSString *)[dict objectForKey:@"sectionName"];
                        if ([sectionName isEqualToString:sectName])
                        {
                            NSMutableArray * indexArray = (NSMutableArray *) [dict objectForKey:@"indexPath"];
                            NSMutableArray * idArray = (NSMutableArray *) [dict objectForKey:@"valueIdArray"];
                            if (![idArray containsObject:otherValueId])
                            {
                                [idArray addObject:otherValueId];
                                [dict setObject:idArray forKey:@"valueIdArray"];
                            }
                            if (![idArray containsObject:indexPath])
                            {
                                [indexArray addObject:indexPath];
                                [dict setObject:indexArray forKey:@"indexPath"];
                            }
                            
                        }
                        else
                        {
                            BOOL isExist = false;
                            for (NSMutableDictionary * dict in self.localFiterModel.otherFilters)
                            {
                                NSString *sectName = (NSString *)[dict objectForKey:@"sectionName"];
                                
                                if ([sectionName isEqualToString:sectName])
                                {
                                    isExist = true;
                                    break;
                                }
                            }
                            if (!isExist)
                            {
                                NSMutableArray * valueIdArray = [[NSMutableArray alloc] init];
                                NSMutableArray * indexPathArray = [[NSMutableArray alloc] init];
                                [indexPathArray addObject:indexPath];
                                [valueIdArray addObject:otherValueId];
                                NSMutableDictionary * filterDict = [[NSMutableDictionary alloc] init];
                                [filterDict setObject:indexPathArray forKey:@"indexPath"];
                                [filterDict setObject:valueIdArray forKey:@"valueIdArray"];
                                [filterDict setObject:sectionName forKey:@"sectionName"];
                                [self.localFiterModel.otherFilters addObject:filterDict];
                            }
                        }
                    }
                }
            }
            else
            {
                BOOL isDict = false;
                NSDictionary * dictionary;
                if ([self.selectedOtherCellArray containsObject:indexPath])
                {
                    [self.selectedOtherCellArray removeObject:indexPath];
                }
                if (self.localFiterModel.otherFilters.count > 0)
                {
                    for (NSMutableDictionary * dict in self.localFiterModel.otherFilters)
                    {
                        NSString *sectName = (NSString *)[dict objectForKey:@"sectionName"];
                        if ([sectionName isEqualToString:sectName])
                        {
                            NSMutableArray * idArray = (NSMutableArray *) [dict objectForKey:@"valueIdArray"];
                            if ([idArray containsObject:otherValueId])
                            {
                                [idArray removeObject:otherValueId];
                            }
                            NSMutableArray * indexArray = (NSMutableArray *) [dict objectForKey:@"indexPath"];
                            if ([indexArray containsObject:indexPath])
                            {
                                [indexArray removeObject:indexPath];
                            }
                            if (idArray.count == 0)
                            {
                                dictionary = [NSMutableDictionary dictionaryWithDictionary:dict];
                                isDict = true;
                            }
                            else
                            {
                                [dict setObject:idArray forKey:@"valueIdArray"];
                            }
                            break;
                        }
                    }
                    
                    if (isDict && dictionary)
                    {
                        if ([self.localFiterModel.otherFilters containsObject:dictionary]) {
                            [self.localFiterModel.otherFilters removeObject:dictionary];
                        }
                    }
                }
            }
            [self.tbView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *sectionName = [self getStringForSection:section];
    
    if ([sectionName isEqualToString:kFourDayString])
    {
        return 2;
    }
    else if ([sectionName isEqualToString:kEightDayString])             // for price
    {
        return 1;
    }
    else if ([sectionName isEqualToString:kColorsString])
    {
        return 1;
    }
    if ([sectionName isEqualToString:kSizeString])
    {
        return self.sizeArrayValueIds.count ? 1 : 0;
    }
    else if([sectionName isEqualToString:kOccasionString])
    {
        if (self.allProductsWithFilterModel.allOccassionArray.count > 0)
        {
            EYProductFilters * occasionFilter = (EYProductFilters*)self.allProductsWithFilterModel.allOccassionArray[0];
            NSIndexPath * idPath = [NSIndexPath indexPathForRow:0 inSection:section];

            if ([_openSet containsObject:idPath])
            {
                return 1 + occasionFilter.values.count;
            }
            else
            {
                return 1;
            }
        }
        else
        {
            return 0;
        }
    }
    else if([sectionName isEqualToString:kDesignerString])
    {
        if (self.allProductsWithFilterModel.allDesignerArray.count > 0)
        {
            EYProductFilters * topDesignerFilter = (EYProductFilters*)self.allProductsWithFilterModel.allDesignerArray[0];
            NSIndexPath * idPath = [NSIndexPath indexPathForRow:0 inSection:section];
            if ([_openSet containsObject:idPath])
            {
                return 1 + topDesignerFilter.values.count;
            }
            else
            {
                return 1;
            }
        }
        else
        {
            return 0;
        }
    }
    else
    {
        EYProductFilters * filter =  [self.localFiltersProductModelArray objectAtIndex:section];
        NSIndexPath * idPath = [NSIndexPath indexPathForRow:0 inSection:section];
        if (filter.values.count > 0)
        {
            if ([_openSet containsObject:idPath])
            {
                return 1 + filter.values.count;
            }
            else
            {
                return 1;
            }
        }
        else
        {
            return 0;
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.localFiltersProductModelArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSString * sectionName = [self getStringForSection:section];
    if ([sectionName isEqualToString:kFourDayString] || [sectionName isEqualToString:kEightDayString] || [sectionName isEqualToString:kColorsString])
    {
        return 52;
    }
    return .001;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGFloat sectionHeight = [self tableView:tableView heightForHeaderInSection:section];    // 52
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, sectionHeight)];
    [view setBackgroundColor:kLightGrayBgColor];
    
    NSString * sectionName = [self getStringForSection:section];
    if ([sectionName isEqualToString:kFourDayString])
    {
        sectionName = @"DELIVERY DATE";
    }
    else if ([sectionName isEqualToString:kEightDayString])
    {
        sectionName =  @"RENTAL PRICE RANGE";
    }
    else if ([sectionName isEqualToString:kColorsString])
    {
        sectionName =  @"COLORS";
    }
    else if([sectionName isEqualToString:kSizeString])
    {
        return nil;
    }
    else if([sectionName isEqualToString:kOccasionString])
    {
        return nil;
    }
    else if([sectionName isEqualToString:kDesignerString])
    {
        return nil;
    }
    else
    {
        return nil;
    }
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [titleLabel setText:sectionName];
    [titleLabel setFont:AN_BOLD(11)];
    [titleLabel setTextColor:kBlackTextColor];
    
    CGSize titleSize = [EYUtility sizeForString:sectionName font:titleLabel.font width:view.frame.size.width - (2 * kTableViewLargePadding)];
    [titleLabel setFrame:CGRectMake(kTableViewLargePadding, sectionHeight - (titleSize.height + kcellPadding - 4) , view.frame.size.width - (2 * kTableViewLargePadding), titleSize.height)];
    [view addSubview:titleLabel];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * sectionName = [self getStringForSection:indexPath.section];
    if ([sectionName isEqualToString:kFourDayString])
    {
        return kFilterCellHeight;
    }
    else if ([sectionName isEqualToString:kEightDayString])
    {
        CGSize priceSizeLabel = [EYUtility sizeForString:@"Rs.300" font:[UIFont fontWithName:kRegularFontName size:12.0]];
        CGFloat height = 20 + 28 + 16 + priceSizeLabel.height + 28;
        return height;
    }
    else if ([sectionName isEqualToString:kColorsString])
    {
        return 92;
    }
    else if ([sectionName isEqualToString:kSizeString])
    {       
        return 144;
    }
    else
    {
        if (indexPath.row == 0)
        {
            return 52;
        }
        return kFilterCellHeight;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return .001;
}

-(void) updateTableView:(NSIndexPath *)indexPath
{
    NSString *selectedSectionName = [self getStringForSection:_selectedIndexPath.section];
    NSString *prevSectionName = [self getStringForSection:_previousIndexPath.section];
    
    if ([_openSet containsObject:indexPath])
    {
        NSMutableArray *insertArray = [[NSMutableArray alloc] init];
        NSMutableArray *deleteArray = [[NSMutableArray alloc] init];
        
        if ([selectedSectionName isEqualToString:@""])          // vkkkk
        {
            if ([prevSectionName isEqualToString:kOccasionString])
            {
                if ([_openSet containsObject:_previousIndexPath])
                {
                    [_openSet removeObject:_previousIndexPath];
                }
                EYProductFilters * occasionFilter = (EYProductFilters*)self.allProductsWithFilterModel.allOccassionArray[0];
                
                for (NSInteger i = 1; i <= occasionFilter.valueIds.count; i++)
                {
                    NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:_previousIndexPath.section];
                    [deleteArray addObject:path];
                }
            }
            else if ([prevSectionName isEqualToString:kDesignerString])
            {
                if ([_openSet containsObject:_previousIndexPath])
                {
                    [_openSet removeObject:_previousIndexPath];
                }
                EYProductFilters * topDesignerFilter = (EYProductFilters*)self.allProductsWithFilterModel.allDesignerArray[0];
                
                for (NSInteger i = 1; i <= topDesignerFilter.valueIds.count; i++)
                {
                    NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:_previousIndexPath.section];
                    [deleteArray addObject:path];
                }
            }
            else                                                // empty
            {
            }
        }
        else if ([selectedSectionName isEqualToString:kOccasionString])
        {
            if ([prevSectionName isEqualToString:@""])
            {
                EYProductFilters * occasionFilter = (EYProductFilters*)self.allProductsWithFilterModel.allOccassionArray[0];
                for (NSInteger i = 1; i <= occasionFilter.values.count; i++)
                {
                    NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:_selectedIndexPath.section];
                    [insertArray addObject:path];
                }
                if ([_openSet containsObject:_previousIndexPath])
                {
                    [_openSet removeObject:_previousIndexPath];
                }
            }
            else if ([prevSectionName isEqualToString:kDesignerString])
            {
                EYProductFilters * occasionFilter = (EYProductFilters*)self.allProductsWithFilterModel.allOccassionArray[0];
                EYProductFilters * topDesignerFilter = (EYProductFilters*)self.allProductsWithFilterModel.allDesignerArray[0];
                for (NSInteger i = 1; i <= occasionFilter.values.count; i++)
                {
                    NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:_selectedIndexPath.section];
                    [insertArray addObject:path];
                }
                for (NSInteger i = 1; i <= topDesignerFilter.valueIds.count; i++)
                {
                    NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:_previousIndexPath.section];
                    [deleteArray addObject:path];
                }
                if ([_openSet containsObject:_previousIndexPath])
                {
                    [_openSet removeObject:_previousIndexPath];
                }
            }
            else
            {
                EYProductFilters * occasionFilter = (EYProductFilters*)self.allProductsWithFilterModel.allOccassionArray[0];
                EYProductFilters * filter =  [self.localFiltersProductModelArray objectAtIndex:_previousIndexPath.section];
                for (NSInteger i = 1; i <= occasionFilter.valueIds.count; i++)   //other case
                {
                    NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:_selectedIndexPath.section];
                    [insertArray addObject:path];
                }
                for (NSInteger i = 1; i <= filter.values.count; i++)
                {
                    NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:_previousIndexPath.section];
                    [deleteArray addObject:path];
                }
                if ([_openSet containsObject:_previousIndexPath])
                {
                    [_openSet removeObject:_previousIndexPath];
                }
            }
        }
        else if ([selectedSectionName isEqualToString:kDesignerString])
        {
            if ([prevSectionName isEqualToString:@""])
            {
                EYProductFilters * topDesignerFilter = (EYProductFilters*)self.allProductsWithFilterModel.allDesignerArray[0];
                for (NSInteger i = 1; i <= topDesignerFilter.values.count; i++)
                {
                    NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:_selectedIndexPath.section];
                    [insertArray addObject:path];
                }
                if ([_openSet containsObject:_previousIndexPath])
                {
                    [_openSet removeObject:_previousIndexPath];
                }
            }
            else if ([prevSectionName isEqualToString:kOccasionString])
            {
                EYProductFilters * topDesignerFilter = (EYProductFilters*)self.allProductsWithFilterModel.allDesignerArray[0];
                EYProductFilters * occasionFilter = (EYProductFilters*)self.allProductsWithFilterModel.allOccassionArray[0];
                
                for (NSInteger i = 1; i <= topDesignerFilter.valueIds.count; i++)
                {
                    NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:_selectedIndexPath.section];
                    [insertArray addObject:path];
                }
                for (NSInteger i = 1; i <= occasionFilter.values.count; i++)
                {
                    NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:_previousIndexPath.section];
                    [deleteArray addObject:path];
                }
                if ([_openSet containsObject:_previousIndexPath])
                {
                    [_openSet removeObject:_previousIndexPath];
                }
            }
            else
            {
                if ([prevSectionName isEqualToString:kOccasionString])
                {
                    EYProductFilters * topDesignerFilter = (EYProductFilters*)self.allProductsWithFilterModel.allDesignerArray[0];
                    EYProductFilters * occasionFilter = (EYProductFilters*)self.allProductsWithFilterModel.allOccassionArray[0];
                    
                    for (NSInteger i = 1; i <= topDesignerFilter.valueIds.count; i++)
                    {
                        NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:_selectedIndexPath.section];
                        [insertArray addObject:path];
                    }
                    for (NSInteger i = 1; i <= occasionFilter.values.count; i++)
                    {
                        NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:_previousIndexPath.section];
                        [deleteArray addObject:path];
                    }
                    if ([_openSet containsObject:_previousIndexPath])
                    {
                        [_openSet removeObject:_previousIndexPath];
                    }
                }
                else if ([prevSectionName isEqualToString:kDesignerString])
                {
                    EYProductFilters * occasionFilter = (EYProductFilters*)self.allProductsWithFilterModel.allOccassionArray[0];
                    EYProductFilters * topDesignerFilter = (EYProductFilters*)self.allProductsWithFilterModel.allDesignerArray[0];
                    
                    for (NSInteger i = 1; i <= occasionFilter.values.count; i++)
                    {
                        NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:_selectedIndexPath.section];
                        [insertArray addObject:path];
                    }
                    for (NSInteger i = 1; i <= topDesignerFilter.valueIds.count; i++)
                    {
                        NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:_previousIndexPath.section];
                        [deleteArray addObject:path];
                    }
                    if ([_openSet containsObject:_previousIndexPath])
                    {
                        [_openSet removeObject:_previousIndexPath];
                    }
                }
                else
                {
                    EYProductFilters * topDesignerFilter = (EYProductFilters*)self.allProductsWithFilterModel.allDesignerArray[0];
                    EYProductFilters * filter =  [self.localFiltersProductModelArray objectAtIndex:_previousIndexPath.section];
                    
                    for (NSInteger i = 1; i <= topDesignerFilter.values.count; i++)
                    {
                        NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:_selectedIndexPath.section];
                        [insertArray addObject:path];
                    }
                    for (NSInteger i = 1; i <= filter.valueIds.count; i++)       //other case
                    {
                        NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:_previousIndexPath.section];
                        [deleteArray addObject:path];
                    }
                    if ([_openSet containsObject:_previousIndexPath])
                    {
                        [_openSet removeObject:_previousIndexPath];
                    }
                }
            }
        }
        else
        {
            if ([prevSectionName isEqualToString:kOccasionString])
            {
                EYProductFilters * topDesignerFilter = (EYProductFilters*)self.localFiltersProductModelArray[_selectedIndexPath.section];//other case
                EYProductFilters * occasionFilter = (EYProductFilters*)self.allProductsWithFilterModel.allOccassionArray[0];
                
                for (NSInteger i = 1; i <= topDesignerFilter.valueIds.count; i++)
                {
                    NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:_selectedIndexPath.section];
                    [insertArray addObject:path];
                }
                for (NSInteger i = 1; i <= occasionFilter.values.count; i++)
                {
                    NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:_previousIndexPath.section];
                    [deleteArray addObject:path];
                }
                if ([_openSet containsObject:_previousIndexPath])
                {
                    [_openSet removeObject:_previousIndexPath];
                }
            }
            else if ([prevSectionName isEqualToString:kDesignerString])
            {
                EYProductFilters * topDesignerFilter = (EYProductFilters*)self.allProductsWithFilterModel.allDesignerArray[0];
                EYProductFilters * filter =  [self.localFiltersProductModelArray objectAtIndex:indexPath.section];
                
                for (NSInteger i = 1; i <= filter.values.count; i++)     //other case
                {
                    NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:_selectedIndexPath.section];
                    [insertArray addObject:path];
                }
                for (NSInteger i = 1; i <= topDesignerFilter.valueIds.count; i++)
                {
                    NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:_previousIndexPath.section];
                    [deleteArray addObject:path];
                }
                if ([_openSet containsObject:_previousIndexPath])
                {
                    [_openSet removeObject:_previousIndexPath];
                    
                }
            }
            else
            {
                EYProductFilters * filter =  [self.localFiltersProductModelArray objectAtIndex:_selectedIndexPath.section];
                if ([prevSectionName isEqualToString:@""])
                {
                    for (NSInteger i = 1; i <= filter.values.count; i++)
                    {
                        NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:_selectedIndexPath.section];
                        [insertArray addObject:path];
                    }
                }
                else
                {
                    EYProductFilters * filter1 =  [self.localFiltersProductModelArray objectAtIndex:_previousIndexPath.section];
                    for (NSInteger i = 1; i <= filter.values.count; i++)
                    {
                        NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:_selectedIndexPath.section];
                        [insertArray addObject:path];
                    }
                    for (NSInteger i = 1; i <= filter1.values.count; i++)       //other case
                    {
                        NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:_previousIndexPath.section];
                        [deleteArray addObject:path];
                    }
                    if ([_openSet containsObject:_previousIndexPath])
                    {
                        [_openSet removeObject:_previousIndexPath];
                    }
                }
            }
        }
        
        [self.tbView beginUpdates];
        [self.tbView insertRowsAtIndexPaths:insertArray withRowAnimation:UITableViewRowAnimationTop];
        [self.tbView deleteRowsAtIndexPaths:deleteArray withRowAnimation:UITableViewRowAnimationTop];
        [self.tbView endUpdates];
        [self.tbView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:_selectedIndexPath.section] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    else
    {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        
        if (_previousIndexPath.section > -1)
        {
            if ([prevSectionName isEqualToString:@""])
            {
            }
            else if ([prevSectionName isEqualToString:kOccasionString])
            {
                EYProductFilters * occasionFilter = (EYProductFilters*)self.allProductsWithFilterModel.allOccassionArray[0];
                for (NSInteger i = 1; i <= occasionFilter.values.count; i++)
                {
                    NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:_previousIndexPath.section];
                    [array addObject:path];
                }
            }
            else if ([prevSectionName isEqualToString:kDesignerString])
            {
                EYProductFilters * topDesignerFilter = (EYProductFilters*)self.allProductsWithFilterModel.allDesignerArray[0];
                for (NSInteger i = 1; i <= topDesignerFilter.values.count; i++)
                {
                    NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:_previousIndexPath.section];
                    [array addObject:path];
                }
            }
            else
            {
                EYProductFilters * topDesignerFilter = (EYProductFilters*)self.localFiltersProductModelArray[indexPath.section];
                for (NSInteger i = 1; i <= topDesignerFilter.values.count; i++)
                {
                    NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:_previousIndexPath.section];
                    [array addObject:path];
                }
            }
            [self.tbView beginUpdates];
            
            [self.tbView deleteRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationTop];
            [self.tbView endUpdates];
            [self.tbView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:_previousIndexPath.section] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            
        }
        else
        {
            if ([selectedSectionName isEqualToString:@""])
            {
            }
            else if ([selectedSectionName isEqualToString:kOccasionString])
            {
                EYProductFilters * occasionFilter = (EYProductFilters*)self.allProductsWithFilterModel.allOccassionArray[0];
                for (NSInteger i = 1; i <= occasionFilter.values.count; i++)
                {
                    NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:_selectedIndexPath.section];
                    [array addObject:path];
                }
            }
            else if ([selectedSectionName isEqualToString:kDesignerString])
            {
                EYProductFilters * topDesignerFilter = (EYProductFilters*)self.allProductsWithFilterModel.allDesignerArray[0];
                for (NSInteger i = 1; i <= topDesignerFilter.values.count; i++)
                {
                    NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:_selectedIndexPath.section];
                    [array addObject:path];
                }
            }
            else
            {
                EYProductFilters * topDesignerFilter = (EYProductFilters*)self.localFiltersProductModelArray[indexPath.section];
                for (NSInteger i = 1; i <= topDesignerFilter.values.count; i++)
                {
                    NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:_selectedIndexPath.section];
                    [array addObject:path];
                }
            }
            [self.tbView beginUpdates];
            [self.tbView deleteRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationTop];
            [self.tbView endUpdates];
            [self.tbView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:_selectedIndexPath.section] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
    }
    [self updatingImageOfCell];
}

#pragma mark - calender

- (void)openCalenderController
{
    if (self.calendar)
    {
        return;
    }
    
    CGRect rect = [UIScreen mainScreen].bounds;
    self.overlay = [[UIView alloc] initWithFrame:rect];
    [self.navigationController.view addSubview:_overlay];
    self.overlay.userInteractionEnabled = YES;
    self.overlay.alpha = 0.0;
    self.overlay.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.4];
    
    UITapGestureRecognizer *tapOnOverlay = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOnOverlay:)];
    [self.overlay addGestureRecognizer:tapOnOverlay];
    UIPanGestureRecognizer *panOnOverlay = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panOnOverlay:)];
    [self.overlay addGestureRecognizer:panOnOverlay];
    
    self.calendar = [[ASCalendarController alloc] initWithNibName:nil bundle:nil];
    [self.calendar setDelegate:self];
    [self.calendar setStartDate:self.localFiterModel.startDate numberOfDays:self.localFiterModel.rentalPeriod];

    CGFloat h = kHeaderButtonHeight * 9;
    CGRect frame = (CGRect) {0.0, rect.size.height + 0, rect.size.width, h};
    self.calendar.view.frame = frame;
    
    [self.navigationController addChildViewController:self.calendar];
    [self.navigationController.view addSubview:self.calendar.view];
    
    frame.origin.y = rect.size.height - h;
    [UIView animateWithDuration:0.3 animations:^{
        self.overlay.alpha = 1.0;
        self.calendar.view.frame = frame;
    } completion:^(BOOL finished) {
        [self.calendar didMoveToParentViewController:self.navigationController];
    }];
}

- (void)calendar:(ASCalendarController *)cont didSelectDate:(NSDate *)date
{
    self.localFiterModel.startDate = date;
    NSIndexPath * indexpath = [NSIndexPath indexPathForRow:1 inSection:0];
    DeliveryDateTableViewCell * cell = (DeliveryDateTableViewCell *)[self.tbView cellForRowAtIndexPath:indexpath];
    
    if (cell)
    {
        NSString *rentalStrtDate = [[EYUtility shared] getDateWithSuffix:date];
        [cell updateMiddleLabelFromDetailVC:rentalStrtDate];
    }
    
    [self dismissCalendar];
}

- (void)dismissCalendar
{
    [self.calendar willMoveToParentViewController:nil];
    
    CGRect frame = self.calendar.view.frame;
    frame.origin.y += frame.size.height;
    [UIView animateWithDuration:0.3 animations:^{
        self.calendar.view.frame = frame;
        self.overlay.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.calendar.view removeFromSuperview];
        [self.calendar removeFromParentViewController];
        self.calendar = nil;
        [self.overlay removeFromSuperview];
        self.overlay = nil;
    }];
}

- (void)panOnOverlay:(id)sender
{
    [self dismissCalendar];
}

- (void)tapOnOverlay:(id)sender
{
    [self dismissCalendar];
}

#pragma mark - rental

-(void) rentalBtnClicked:(id) sender
{
    NSIndexPath * indexpath = [NSIndexPath indexPathForRow:0 inSection:rentalSectionNum];
    RentalTableViewCell * cell = (RentalTableViewCell *)[self.tbView cellForRowAtIndexPath:indexpath];
  
    NSIndexPath * indexpathDelivery = [NSIndexPath indexPathForRow:1 inSection:0];
    DeliveryDateTableViewCell * deliveryCell = (DeliveryDateTableViewCell *)[self.tbView cellForRowAtIndexPath:indexpathDelivery];
    
    UIButton * button = (UIButton *) sender;
    if (button.tag == 4)                // for four day rental
    {
        [cell.buttonDay1 setTintColor:kAppGreenColor];
        [cell.buttonDay2 setTintColor:kAppLightGrayColor];
        for (EYProductFilters * productFilter in self.allProductsWithFilterModel.allDeliveryArray)
        {
            if ([productFilter.name isEqualToString:kFourDayString])
            {
                self.localFiterModel.rentalPeriod = 4;
                [self.localFiterModel.priceRange setObject:[NSString stringWithFormat:@"%d",productFilter.minVal.intValue] forKey:@"minValue"];
                [self.localFiterModel.priceRange setObject:[NSString stringWithFormat:@"%d",productFilter.maxVal.intValue] forKey:@"maxValue"];
                [self.localFiterModel.priceRange setObject:[NSString stringWithFormat:@"%d",productFilter.minVal.intValue] forKey:@"selectedMinValue"];
                [self.localFiterModel.priceRange setObject:[NSString stringWithFormat:@"%d",productFilter.maxVal.intValue] forKey:@"selectedMaxValue"];
                [deliveryCell updateMiddleLabelFromDetailVC:@""];
            }
        }
    }
    else                                // for eight day rental
    {
        [cell.buttonDay2 setTintColor:kAppGreenColor];
        [cell.buttonDay1 setTintColor:kAppLightGrayColor];
        for (EYProductFilters * productFilter in self.allProductsWithFilterModel.allDeliveryArray)
        {
            if ([productFilter.name isEqualToString:kEightDayString])
            {
                self.localFiterModel.rentalPeriod = 8;
                [self.localFiterModel.priceRange setObject:[NSString stringWithFormat:@"%d",productFilter.minVal.intValue] forKey:@"minValue"];
                [self.localFiterModel.priceRange setObject:[NSString stringWithFormat:@"%d",productFilter.maxVal.intValue] forKey:@"maxValue"];
                [self.localFiterModel.priceRange setObject:[NSString stringWithFormat:@"%d",productFilter.minVal.intValue] forKey:@"selectedMinValue"];
                [self.localFiterModel.priceRange setObject:[NSString stringWithFormat:@"%d",productFilter.maxVal.intValue] forKey:@"selectedMaxValue"];
                [deliveryCell updateMiddleLabelFromDetailVC:@""];
            }
        }
    }

    [self.tbView reloadData];
}

-(void)gettingValuesForSlider:(float)minValue withMaxValue:(float)maxValue
{
    NSIndexPath * indexpath = [NSIndexPath indexPathForRow:0 inSection:priceSectionNum];
    PriceTableViewCell * cell = (PriceTableViewCell *)[self.tbView cellForRowAtIndexPath:indexpath];
    
    NSString * minV = [NSString stringWithFormat:@"%@",[[EYUtility shared]getCurrencyFormatFromNumber:minValue]] ;
    NSString * maxV = [NSString stringWithFormat:@"%@",[[EYUtility shared]getCurrencyFormatFromNumber:maxValue]] ;

    [cell.fromPriceLabel setAttributedText:[self getPriceRange:@"From " withEndString:minV]];
    
    [cell.toPriceLabel setAttributedText:[self getPriceRange:@"to " withEndString:maxV]];
    
    [self.localFiterModel.priceRange setObject:[NSString stringWithFormat:@"%d", (int)minValue] forKey:@"selectedMinValue"];
    [self.localFiterModel.priceRange setObject:[NSString stringWithFormat:@"%d", (int) maxValue] forKey:@"selectedMaxValue"];
}

#pragma mark - price Range

- (NSAttributedString *)getPriceRange:(NSString *) startingString withEndString:(NSString *) endingString
{
    NSMutableAttributedString *startingLabelAttributes = [[NSMutableAttributedString alloc] initWithString:startingString];
    [startingLabelAttributes addAttribute:NSFontAttributeName value:AN_REGULAR(12) range:NSMakeRange(0, startingString.length)];
    [startingLabelAttributes addAttribute:NSForegroundColorAttributeName value:kRowLeftLabelColor range:NSMakeRange(0, startingString.length)];
    
    NSMutableAttributedString * endingLabelAttributes = [[NSMutableAttributedString alloc] initWithString:endingString];
    [endingLabelAttributes addAttribute:NSFontAttributeName value:AN_MEDIUM(12) range:NSMakeRange(0, endingString.length)];
    [endingLabelAttributes addAttribute:NSForegroundColorAttributeName value:kAppGreenColor range:NSMakeRange(0, endingString.length)];
    
    [startingLabelAttributes appendAttributedString:endingLabelAttributes];
    return startingLabelAttributes;
}

#pragma mark - size

-(void) updatingSelectedSizeArray:(BOOL) isButtonSelected andSelectedIndex:(NSNumber*)selectedSizeId
{
    NSInteger indexOfObj;
    if ([_sizeArrayValueIds containsObject:selectedSizeId])
    {
       indexOfObj = [_sizeArrayValueIds indexOfObject:selectedSizeId];
    }
    NSDictionary * dict = [self creatingFilterValueDictWithValueName:[_sizeArrayValues objectAtIndex:indexOfObj] withValueId:[_sizeArrayValueIds objectAtIndex:indexOfObj] withSelectedCellIndex:[NSNumber numberWithInteger:indexOfObj]];
    NSNumber *sizeId = [_sizeArrayValueIds objectAtIndex:indexOfObj];
    if (isButtonSelected)
    {
        if (![self.localFiterModel.sizes containsObject:dict])
        {
            [self.localFiterModel.sizes addObject:dict];
        }
        if (![self.localFiterModel.sizeIdArray containsObject:sizeId])
        {
            [self.localFiterModel.sizeIdArray addObject:sizeId];
        }
    }
    else
    {
        if ([self.localFiterModel.sizes containsObject:dict])
        {
            [self.localFiterModel.sizes removeObject:dict];
        }
        if ([self.localFiterModel.sizeIdArray containsObject:sizeId])
        {
            [self.localFiterModel.sizeIdArray removeObject:sizeId];
        }
    }
}

-(void) sizeGuideButtonClicked:(id) sender
{
    NSLog(@"sizeGuideButtonClicked filter");
}

#pragma mark - colour

-(void) colorButtonClicked:(BOOL)isButtonClicked andSelectedIndex:(NSInteger)selectedIndex
{
    EYProductFilters * colorFilter = (EYProductFilters*) self.allProductsWithFilterModel.allColorArray[0];
    NSDictionary * dict = [self creatingFilterValueDictWithValueName:[colorFilter.values objectAtIndex:selectedIndex] withValueId:[_colorIdArray objectAtIndex:selectedIndex] withSelectedCellIndex:[NSNumber numberWithInteger:selectedIndex]];
    
    NSNumber *colorId = [_colorIdArray objectAtIndex:selectedIndex];
    if (isButtonClicked)
    {
        if (![self.localFiterModel.colors containsObject:dict])
        {
            [self.localFiterModel.colors addObject:dict];
        }
        if (![self.localFiterModel.colorIdArray containsObject:colorId])
        {
            [self.localFiterModel.colorIdArray addObject:colorId];
        }
    }
    else
    {
        if ([self.localFiterModel.colors containsObject:dict])
        {
            [self.localFiterModel.colors removeObject:dict];
        }
        if ([self.localFiterModel.colorIdArray containsObject:colorId])
        {
            [self.localFiterModel.colorIdArray removeObject:colorId];
        }
    }
}

-(void)resettingPreferencesFilter
{
    [self.appliedFilterModel initialisingFilterModel];
    [self.localFiterModel initialisingFilterModel];
    [self.selectedOccasionCellArray removeAllObjects];
    [self.selectedSizeCellArray removeAllObjects];
    [self.selectedTopCellArray removeAllObjects];
    [self.tbView reloadData];
}

@end
