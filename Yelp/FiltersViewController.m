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

NSInteger numRowsForCategories = 4;

@interface FiltersViewController ()<UITableViewDataSource, UITableViewDelegate, SwitchCellDelegate>
@property (nonatomic, readonly)NSDictionary *filters;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *categories;
@property (nonatomic, strong) NSMutableSet *selectedCategories;
@property (nonatomic, strong) NSMutableArray *selectedSort;
@property (nonatomic, strong) NSMutableArray *selectedRadius;
@property (nonatomic, strong) NSMutableArray *selectedDeal;
//@property (nonatomic, strong) NSString *selectedSortType;
//@property (nonatomic, strong) NSString *selectedRadiusType;
//@property (nonatomic, strong) NSString *selectedDealsType;
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

        self.selectedRadius = [NSMutableArray array];
        self.selectedDeal = [NSMutableArray array];
        self.isExpandedSection = [NSMutableDictionary dictionary];
        


     //   self.selectedCategories = [defaults objectForKey:@"allSelectedFilters"];
        
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
  
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    for (id category in [defaults objectForKey:@"savedSelectedCategories"]) {
        [self.selectedCategories addObject:category];
    }
    self.selectedSort = [NSMutableArray arrayWithObject:[defaults objectForKey:@"savedSortFilter"]];
    
//    [categories enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        [categoryNames addObject:obj[0]];
//    }];
    
//    [[defaults objectForKey:@"savedSortFilter"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
//        [self.selectedSort addObject:obj];
//    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.allFilters allFilters].count;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSString *key = [[self.allFilters allFilters] objectAtIndex:section];
   return [[[self.allFilters allContents] objectForKey:key] count];
    
    
    
    
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SwitchCell"];
   
    cell.delegate = self;
  //  SwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DefaultCell"];
    NSInteger section = indexPath.section;
//    NSInteger row = indexPath.row;
    
    NSString *sectionTitle = [[self.allFilters allFilters] objectAtIndex:section];
    //NSLog(@"key is %@", key );
    
    NSArray *contents = [[self.allFilters allContents] objectForKey:sectionTitle];
    

    
    cell.titleLabel.text = contents[indexPath.row][@"name"];
    
    
    switch (section) {
        case 0:
            cell.on = [self.selectedSort containsObject:[contents objectAtIndex:[indexPath row]]];
        case 1:
            cell.on = [self.selectedRadius containsObject:[contents objectAtIndex:[indexPath row]]];
        case 2:
            cell.on = [self.selectedDeal containsObject:[contents objectAtIndex:[indexPath row]]];
        case 3:
            cell.on = [self.selectedCategories containsObject:[contents objectAtIndex:[indexPath row]]];
            
        default:
            break;
    }
    
    return cell;
    
    

}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    

    
    return [[self.allFilters allFilters] objectAtIndex:section];


    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//    NSInteger section = indexPath.section;
//    NSInteger row = indexPath.row;
    

   
    
}

#pragma mark - Switch cell delegate methods

- (void)switchCell:(SwitchCell *)cell didUpdateValue:(BOOL)value {
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSString *key = [[self.allFilters allFilters] objectAtIndex:[indexPath section]];
    NSArray *contents = [[self.allFilters allContents] objectForKey:key];
    
    //NSString *contentForThisRow = [contents objectAtIndex:[indexPath row]];
    
    
    //cell.titleLabel.text = contents[indexPath.row][@"name"];
    
    //NSInteger section = indexPath.section;
    //NSInteger row = indexPath.row;
    
    if ([key isEqualToString:@"Sort By"]) {
        NSLog(@"Flipping switch in sort by");

        //[self.tableView reloadData];
        if (value) {
            [self.selectedSort removeAllObjects];
            [self.selectedSort addObject:[contents objectAtIndex:[indexPath row]]];
            //[self.tableView reloadData];
            NSLog(@"selected sort looks like %@", self.selectedSort);
            
            
        } else {
            
        }
        
    } else if ([key isEqualToString:@"Distance"]) {
            NSLog(@"Flipping switch in distance");
            
            //[self.tableView reloadData];
            if (value) {
                [self.selectedRadius removeAllObjects];
                [self.selectedRadius addObject:[contents objectAtIndex:[indexPath row]]];
                //[self.tableView reloadData];
                NSLog(@"selected radius looks like %@", self.selectedRadius);
                
                
            } else {
                
            }
    } else if ([key isEqualToString:@"Deals"]) {
        NSLog(@"Flipping switch in Deals");
        
        //[self.tableView reloadData];
        if (value) {
            [self.selectedDeal addObject:[contents objectAtIndex:[indexPath row]]];
            //[self.tableView reloadData];
            NSLog(@"selected radius deal looks like %@", self.selectedDeal);
            
            
        } else {
            [self.selectedDeal removeObject:[contents objectAtIndex:[indexPath row]]];
            //[self.tableView reloadData];
            NSLog(@"selected deal looks like %@", self.selectedDeal);
            
        }
        
        
    } else if ([key isEqualToString:@"Categories"]) {
        if (value) {
            NSLog(@"Selected categories are %@ and trying to add to it %@",self.selectedCategories, [contents objectAtIndex:[indexPath row]]);
            [self.selectedCategories addObject:[contents objectAtIndex:[indexPath row]]];
            //    NSLog(@"%ld, %ld, %@",[indexPath section],[indexPath row], );
            
            
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
    NSMutableDictionary *filters = [NSMutableDictionary dictionary];

//    [filters setObject:self.selectedSortType forKey:@"sort"];
//    [filters setObject:self.selectedRadiusType forKey:@"radius_filter"];
//    [filters setObject:self.selectedDealsType forKey:@"deals_filter"];

    
    
//    [filters setObject:self.selectedRadius forKey:@"radius_filter"];
    
    for (NSDictionary *sort in self.selectedSort) {
        [filters setObject:sort[@"code"] forKey:@"sort"];
    }
    
    for (NSDictionary *radius in self.selectedRadius) {
        [filters setObject:radius[@"code"] forKey:@"radius_filter"];
    }
    
    
    
    if (self.selectedDeal.count > 0) {
        [filters setObject:@"1" forKey:@"deal"];
        NSLog(@"setting deals inside filter initi");
        
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
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *defaultAllSelectedCategories = [[NSMutableArray alloc]init];
    for (id category in self.selectedCategories) {
        [defaultAllSelectedCategories addObject:category];
    }
    [defaults setObject:defaultAllSelectedCategories forKey:@"savedSelectedCategories"];
    
//    [self.selectedSort enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
//        [defaults setObject:obj forKey:@"savedSortFilter"];
//              }];
    
//          [[defaults objectForKey:@"savedSortFilter"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
  //          [self.selectedSort addObject:obj];
    
    [defaults setObject:self.selectedSort forKey:@"savedSortFilter"];
    
    [defaults synchronize];
    [self.delegate filtersViewController:self didChangeFilters:self.filters];
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end



