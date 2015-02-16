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

NSInteger knumRowsForCategories = 4;

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
//        self.title = @"Filters";
        
        
        self.selectedCategories = [NSMutableSet set];

        self.selectedRadius = [NSMutableSet set];
        self.selectedDeal = [NSMutableSet set];
        self.selectedSort = [NSMutableSet set];        
        self.isExpandedSection = [NSMutableDictionary dictionary];
<<<<<<< HEAD

||||||| merged common ancestors
        


     //   self.selectedCategories = [defaults objectForKey:@"allSelectedFilters"];
        
=======
>>>>>>> FETCH_HEAD
        self.allFilters = [[AllFilters alloc] initAllFilters];
       
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationController.navigationBar.backgroundColor = [UIColor redColor];
    self.navigationController.navigationBar.barTintColor = [UIColor redColor];
    
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor whiteColor],NSForegroundColorAttributeName,
                                    [UIColor whiteColor],NSBackgroundColorAttributeName,nil];
    
    self.navigationController.navigationBar.titleTextAttributes = textAttributes;
    self.title = @"Filters";
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onCancelButton)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Apply" style:UIBarButtonItemStylePlain target:self action:@selector(onApplyButton)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SwitchCell" bundle:nil] forCellReuseIdentifier:@"SwitchCell"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"DefaultCell"];
    
    if ([self getFromDefaults:@"savedSelectedSort"] != nil) {
        self.selectedSort = [self getFromDefaults:@"savedSelectedSort"];
    }
    
    if ([self getFromDefaults:@"savedSelectedRadius"] != nil) {
        self.selectedRadius = [self getFromDefaults:@"savedSelectedRadius"];
    }
    
    if ([self getFromDefaults:@"savedSelectedDeal"] != nil) {
    self.selectedDeal = [self getFromDefaults:@"savedSelectedDeal"];
    }
    
    if ([self getFromDefaults:@"savedSelectedCategories"] != nil) {
        self.selectedCategories = [self getFromDefaults:@"savedSelectedCategories"];
    }
    
    
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
    view.tintColor = [UIColor redColor];
    
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
            return knumRowsForCategories+1;
        }
    }
    
     if ([self isExpandedSection:section]) {
    return expandedSectionCount;
    } else {
        return 1;
    }
    
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SwitchCell"];
   
    cell.delegate = self;
    
    NSInteger section = indexPath.section;

    
    NSString *sectionTitle = [[self.allFilters allFilters] objectAtIndex:section];

    
    NSArray *contents = [[self.allFilters allContents] objectForKey:sectionTitle];
    

    cell.titleLabel.text = contents[indexPath.row][@"name"];
    
    switch (section) {
        case 0:
<<<<<<< HEAD
        case 1:
        {
            
            NSString *label;
            NSMutableSet *totest;
            
            
            
            
            if (section == 0) {
                totest = self.selectedSort;
            } else if (section == 1) {
                totest = self.selectedRadius;
            }
            
            if ([totest count] == 0) {
                label = contents[0][@"name"];
            } else {
            
                for (NSDictionary *sort in totest) {
                    label = sort[@"name"];
                }
            }
            
            cell = [tableView dequeueReusableCellWithIdentifier:@"DefaultCell"];

            if ([self isExpandedSection:section]) {
                cell.textLabel.text = contents[indexPath.row][@"name"];

                if ([label isEqualToString:cell.textLabel.text]) {
                    cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CheckMark20.png"]];
                    return cell;
                }
                else {
                    cell.accessoryView = nil;
                    return cell;
                }
                
            } else {
                cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CirclePlus20.png"]];

                cell.textLabel.text = label;
||||||| merged common ancestors


            cell.on = [self.selectedSort containsObject:[contents objectAtIndex:[indexPath row]]];
            NSLog(@"output of cell.on is %d", [self.selectedSort containsObject:[contents objectAtIndex:[indexPath row]]]);
=======
            cell.on = [self.selectedSort containsObject:[contents objectAtIndex:[indexPath row]]];
>>>>>>> FETCH_HEAD
                return cell;
            }
            
        }

        case 2:
            cell.on = [self.selectedDeal containsObject:[contents objectAtIndex:[indexPath row]]];
                return cell;
        case 3:
<<<<<<< HEAD
            if (indexPath.row == knumRowsForCategories  && ![self isExpandedSection:section] ) {
                cell = [tableView dequeueReusableCellWithIdentifier:@"DefaultCell"];
                cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"CirclePlus20.png"]];
                cell.textLabel.text = @"Show all Categories";
||||||| merged common ancestors
            cell.on = [self.selectedCategories containsObject:[contents objectAtIndex:[indexPath row]]];
            NSLog(@"in the selected categories now");
            NSLog(@"output of cell.on in categories is %d", [self.selectedCategories containsObject:[contents objectAtIndex:[indexPath row]]]);
=======
            cell.on = [self.selectedCategories containsObject:[contents objectAtIndex:[indexPath row]]];
>>>>>>> FETCH_HEAD
                return cell;
                

            } else {
            cell.on = [self.selectedCategories containsObject:[contents objectAtIndex:[indexPath row]]];

                return cell;
            }
            
        default:
                @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"No such section exists" userInfo:nil];
    }
    

}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    

    
    return [[self.allFilters allFilters] objectAtIndex:section];


    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
<<<<<<< HEAD
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    switch (section) {
            
        case 0:
        case 1:
            if ([self isExpandedSection:section]) {
                [self collapseSection:section withRow:row];
            } else {
                [self expandSection:section];
            }
            break;
        case 3:
            if (row == knumRowsForCategories && ![self isExpandedSection:section]) {
                [self expandSection:section];
            }
            break;
            
        default:
            break;
    }
||||||| merged common ancestors
//    NSInteger section = indexPath.section;
//    NSInteger row = indexPath.row;
    
=======
>>>>>>> FETCH_HEAD

    
}

#pragma mark - Switch cell delegate methods

- (void)switchCell:(SwitchCell *)cell didUpdateValue:(BOOL)value {
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSString *key = [[self.allFilters allFilters] objectAtIndex:[indexPath section]];
    NSArray *contents = [[self.allFilters allContents] objectForKey:key];
<<<<<<< HEAD
||||||| merged common ancestors
    
    //NSString *contentForThisRow = [contents objectAtIndex:[indexPath row]];
    
    
    //cell.titleLabel.text = contents[indexPath.row][@"name"];
    
    //NSInteger section = indexPath.section;
    //NSInteger row = indexPath.row;
    
    if ([key isEqualToString:@"Sort By"]) {
        NSLog(@"Flipping switch in sort by");
=======
    
    if ([key isEqualToString:@"Sort By"]) {
>>>>>>> FETCH_HEAD

<<<<<<< HEAD
     if ([key isEqualToString:@"Deals"]) {
        
||||||| merged common ancestors
      //  [self.tableView reloadData];
        if (value) {
            [self.selectedSort removeAllObjects];
            [self.selectedSort addObject:[contents objectAtIndex:[indexPath row]]];
            [self.tableView reloadData];
            NSLog(@"selected sort looks like %@", self.selectedSort);
            
            
        } else {
            [self.selectedSort removeObject:[contents objectAtIndex:[indexPath row]]];
        }
        
    } else if ([key isEqualToString:@"Distance"]) {
            NSLog(@"Flipping switch in distance");
            
            //[self.tableView reloadData];
            if (value) {
                [self.selectedRadius removeAllObjects];
                [self.selectedRadius addObject:[contents objectAtIndex:[indexPath row]]];
                [self.tableView reloadData];
                NSLog(@"selected radius looks like %@", self.selectedRadius);
                
                
            } else {
                
            }
    } else if ([key isEqualToString:@"Deals"]) {
        NSLog(@"Flipping switch in Deals");
        
        //[self.tableView reloadData];
=======
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

>>>>>>> FETCH_HEAD
        if (value) {
            [self.selectedDeal addObject:[contents objectAtIndex:[indexPath row]]];
<<<<<<< HEAD
            
            
||||||| merged common ancestors
            //[self.tableView reloadData];
            NSLog(@"selected radius deal looks like %@", self.selectedDeal);
            
            
=======
          
>>>>>>> FETCH_HEAD
        } else {
            [self.selectedDeal removeObject:[contents objectAtIndex:[indexPath row]]];
            
        }
        
        
    } else if ([key isEqualToString:@"Categories"]) {
        if (value) {
<<<<<<< HEAD

||||||| merged common ancestors
            NSLog(@"Flipping switch in sort by");
            NSLog(@"Selected categories are %@ and trying to add to it %@",self.selectedCategories, [contents objectAtIndex:[indexPath row]]);
=======
>>>>>>> FETCH_HEAD
            [self.selectedCategories addObject:[contents objectAtIndex:[indexPath row]]];
<<<<<<< HEAD
            
||||||| merged common ancestors
            //    NSLog(@"%ld, %ld, %@",[indexPath section],[indexPath row], );
            
=======
>>>>>>> FETCH_HEAD
            
        }else {
            [self.selectedCategories removeObject:[contents objectAtIndex:[indexPath row]]];
            
        }
    }
<<<<<<< HEAD
    
||||||| merged common ancestors
    

    
=======

>>>>>>> FETCH_HEAD
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
    
    NSString *sectionTitle = [[self.allFilters allFilters] objectAtIndex:section];
    
    NSArray *contents = [[self.allFilters allContents] objectForKey:sectionTitle];
    
    switch (section) {
        case 0:
            [self.selectedSort removeAllObjects];
            [self.selectedSort addObject:[contents objectAtIndex:row]];
            break;
            
        case 1:
            [self.selectedRadius removeAllObjects];
            [self.selectedRadius addObject:[contents objectAtIndex:row]];
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
<<<<<<< HEAD

||||||| merged common ancestors

//    [filters setObject:self.selectedSortType forKey:@"sort"];
//    [filters setObject:self.selectedRadiusType forKey:@"radius_filter"];
//    [filters setObject:self.selectedDealsType forKey:@"deals_filter"];

    
    
//    [filters setObject:self.selectedRadius forKey:@"radius_filter"];
=======
>>>>>>> FETCH_HEAD
    
    for (NSDictionary *sort in self.selectedSort) {
        [filters setObject:sort[@"code"] forKey:@"sort"];
    }
    
    for (NSDictionary *radius in self.selectedRadius) {
        [filters setObject:radius[@"code"] forKey:@"radius_filter"];
    }
    
<<<<<<< HEAD
    
||||||| merged common ancestors
    
    
=======
>>>>>>> FETCH_HEAD
    if (self.selectedDeal.count > 0) {
        [filters setObject:@"1" forKey:@"deal"];
    }
<<<<<<< HEAD

||||||| merged common ancestors


        

=======
>>>>>>> FETCH_HEAD
 
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



