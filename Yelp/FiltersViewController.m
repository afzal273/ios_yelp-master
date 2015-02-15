//
//  FiltersViewController.m
//  Yelp
//
//  Created by Syed, Afzal on 2/10/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "FiltersViewController.h"
#import "SwitchCell.h"
#import "AllFilters.h"

NSInteger kNumRowsForCategories = 4;

@interface FiltersViewController ()<UITableViewDataSource, UITableViewDelegate, SwitchCellDelegate>
@property (nonatomic, readonly)NSDictionary *filters;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *categories;
@property (nonatomic, strong) NSMutableSet *selectedCategories;
@property (nonatomic, strong) NSMutableSet *selectedSort;
@property (nonatomic, strong) NSMutableSet *selectedRadius;
@property (nonatomic, strong) NSMutableSet *selectedDeal;
@property(nonatomic, strong) NSMutableDictionary *isExpandedSection;
@property (nonatomic, strong) AllFilters *allFilters;

- (BOOL)isExpandedSection:(NSInteger)section;
- (void)expandSection:(NSInteger)section;
- (void)collapseSection:(NSInteger)section withRow: (NSInteger) row;


@end

@implementation FiltersViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self){
        self.title = @"Filters";
        self.selectedCategories = [NSMutableSet set];
        self.selectedRadius = [NSMutableSet set];
        self.selectedDeal = [NSMutableSet set];
        self.selectedSort = [NSMutableSet set];        
        self.isExpandedSection = [NSMutableDictionary dictionary];
        self.allFilters = [[AllFilters alloc] initAllFilters];
       
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onCancelButton)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Apply" style:UIBarButtonItemStylePlain target:self action:@selector(onApplyButton)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SwitchCell" bundle:nil] forCellReuseIdentifier:@"SwitchCell"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"DefaultCell"];

    
    self.selectedSort = [self getFromDefaults:@"savedSelectedSort"];
    self.selectedRadius = [self getFromDefaults:@"savedSelectedRadius"];
    self.selectedDeal = [self getFromDefaults:@"savedSelectedDeal"];
    self.selectedCategories = [self getFromDefaults:@"savedSelectedCategories"];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.allFilters allFilters].count;
    
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor orangeColor];
    
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor whiteColor]];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSString *key = [[self.allFilters allFilters] objectAtIndex:section];
    NSInteger expandedSectionCount = [[[self.allFilters allContents] objectForKey:key] count];
    
    if ([key isEqualToString:@"Categories"]) {
        if ([self isExpandedSection:section]) {
            return expandedSectionCount;
        } else {
            return kNumRowsForCategories+1;
        }
    }

   // if ([self isExpandedSection:section]) {
        return expandedSectionCount;
    //} else {
   //     return 1;
    //}

    
 //  return [[[self.allFilters allContents] objectForKey:key] count];
  
    
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SwitchCell"];
   
    cell.delegate = self;
  //  SwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DefaultCell"];
    NSInteger section = indexPath.section;

    
    NSString *sectionTitle = [[self.allFilters allFilters] objectAtIndex:section];

    
    NSArray *contents = [[self.allFilters allContents] objectForKey:sectionTitle];
    

    
    cell.titleLabel.text = contents[indexPath.row][@"name"];
    
    
    switch (section) {
        case 0:
            cell.on = [self.selectedSort containsObject:[contents objectAtIndex:[indexPath row]]];
                return cell;

        case 1:
            cell.on = [self.selectedRadius containsObject:[contents objectAtIndex:[indexPath row]]];
                return cell;
        case 2:
            cell.on = [self.selectedDeal containsObject:[contents objectAtIndex:[indexPath row]]];
                return cell;
        case 3:
            cell.on = [self.selectedCategories containsObject:[contents objectAtIndex:[indexPath row]]];
                return cell;

            
        default:
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"invalid section" userInfo:nil];    }
    

}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    

    
    return [[self.allFilters allFilters] objectAtIndex:section];


    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    
}

#pragma mark - Switch cell delegate methods

- (void)switchCell:(SwitchCell *)cell didUpdateValue:(BOOL)value {
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSString *key = [[self.allFilters allFilters] objectAtIndex:[indexPath section]];
    NSArray *contents = [[self.allFilters allContents] objectForKey:key];
    
    if ([key isEqualToString:@"Sort By"]) {

        if (value) {
            [self.selectedSort removeAllObjects];
            [self.selectedSort addObject:[contents objectAtIndex:[indexPath row]]];
            [self.tableView reloadData];
         
        } else {
            [self.selectedSort removeObject:[contents objectAtIndex:[indexPath row]]];
        }
        
    } else if ([key isEqualToString:@"Distance"]) {

            if (value) {
                [self.selectedRadius removeAllObjects];
                [self.selectedRadius addObject:[contents objectAtIndex:[indexPath row]]];
                [self.tableView reloadData];
            } else {
                [self.selectedRadius removeObject:[contents objectAtIndex:[indexPath row]]];
                
            }
    } else if ([key isEqualToString:@"Deals"]) {

        if (value) {
            [self.selectedDeal addObject:[contents objectAtIndex:[indexPath row]]];
          
        } else {
            [self.selectedDeal removeObject:[contents objectAtIndex:[indexPath row]]];
            
        }
        
        
    } else if ([key isEqualToString:@"Categories"]) {
        if (value) {
            [self.selectedCategories addObject:[contents objectAtIndex:[indexPath row]]];
            
        }else {
            [self.selectedCategories removeObject:[contents objectAtIndex:[indexPath row]]];
            
        }
    }

}

#pragma mark - Private Methods

- (BOOL)isExpandedSection:(NSInteger)section {
    return [self.isExpandedSection[@(section)] boolValue];
}

- (void)expandSection:(NSInteger)section {
    self.isExpandedSection[@(section)] = @YES;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)collapseSection:(NSInteger)section withRow: (NSInteger) row {
    //NSIndexPath *prevSelectionIndexPath;
    switch (section) {
        case 0:
     //       prevSelectionIndexPath = [NSIndexPath indexPathForRow: inSection:section];
            break;
            
        default:
            break;
    }
    
    self.isExpandedSection[@(section)] = @NO;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
    
}
    



- (NSDictionary * ) filters {
    // Creating the filters dictionary to be sent to yelp
    NSMutableDictionary *filters = [NSMutableDictionary dictionary];
    
    for (NSDictionary *sort in self.selectedSort) {
        [filters setObject:sort[@"code"] forKey:@"sort"];
    }
    
    for (NSDictionary *radius in self.selectedRadius) {
        [filters setObject:radius[@"code"] forKey:@"radius_filter"];
    }
    
    if (self.selectedDeal.count > 0) {
        [filters setObject:@"1" forKey:@"deal"];
    }
 
    if (self.selectedCategories.count > 0) {
        NSMutableArray *names = [NSMutableArray array];
        for (NSDictionary *category in self.selectedCategories) {
            [names addObject:category[@"code"]];
        }
        NSString *categoryFilter = [names componentsJoinedByString:@","];
        [filters setObject:categoryFilter forKey:@"category_filter"];
    }
    
    return filters;
}


- (void) onCancelButton {

    [self.delegate filtersViewController:self didChangeFilters:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void) onApplyButton {
    

    [self saveToDefault:self.selectedSort forKey:@"savedSelectedSort"];
    [self saveToDefault:self.selectedRadius forKey:@"savedSelectedRadius"];
    [self saveToDefault:self.selectedDeal forKey:@"savedSelectedDeal"];
    [self saveToDefault:self.selectedCategories forKey:@"savedSelectedCategories"];

    [self.delegate filtersViewController:self didChangeFilters:self.filters];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) saveToDefault:(id) filter forKey:(NSString*) forKey{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:filter];
    [defaults setObject:data forKey:forKey];
    [defaults synchronize];
}

-(id) getFromDefaults:(NSString*) forKey{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    NSData *data = [defaults objectForKey:forKey];
    if (data != nil) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:data];
    } else {
        return nil;
    }
    
}

@end



