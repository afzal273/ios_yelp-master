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
@property (nonatomic, strong) NSArray *sortTypes;
@property (nonatomic, strong) NSArray *radiusTypes;
@property (nonatomic, strong) NSMutableSet *selectedCategories;
@property (nonatomic, strong) NSString *selectedSortType;
@property (nonatomic, strong) NSString *selectedRadiusType;
@property (nonatomic, strong) NSString *selectedDealsType;
@property(nonatomic, strong) NSMutableDictionary *isExpandedSection;
@property (nonatomic, strong) AllFilters *allFilters;

//@property (nonatomic, strong) UISwitch *dealsSwitch;

- (void) initCategories;
- (void) initSortTypes;
- (void) initRadiusTypes;
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
        self.isExpandedSection = [NSMutableDictionary dictionary];
        
        // Setting defaults for Filters
        self.selectedSortType = @"0";
        self.selectedDealsType = @"0";
        self.selectedRadiusType = @"483";
        
//        [self initCategories];
//        [self initSortTypes];
//        [self initRadiusTypes];
        
        
        self.allFilters = [[AllFilters alloc] initAllFilters];
        NSLog(@"%@", [self.allFilters allFilters]);
        NSLog(@"%@", [self.allFilters allContents]);
        
        
        
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
    NSInteger row = indexPath.row;
    
    NSString *key = [[self.allFilters allFilters] objectAtIndex:[indexPath section]];
    NSLog(@"key is %@", key );
    
    NSArray *contents = [[self.allFilters allContents] objectForKey:key];
    
    NSString *contentForThisRow = [contents objectAtIndex:[indexPath row]];
     cell.on = [self.selectedCategories containsObject:[contents objectAtIndex:[indexPath row]]];
    cell.titleLabel.text = contents[indexPath.row][@"name"];
    return cell;
    
    
    
//    
////    NSLog(@"row is %ld",row);
//    switch (section) {
//        case 0:
//            cell = [tableView dequeueReusableCellWithIdentifier:@"DefaultCell"];
//            cell.textLabel.text = self.sortTypes[indexPath.row][@"name"];
//            if ([self isExpandedSection:section]) {
//                cell.accessoryType = UITableViewCellAccessoryCheckmark;
//                
//            } else {
//
////            cell.accessoryType = UITableViewCellAccessoryNone;
//
//            cell.accessoryView  = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"CirclePlus24.png"]];
//            }
//            //cell.on = [self.sortTypes containsObject:self.sortTypes[indexPath.row]];
//           // cell.delegate = self;
//            return cell;
//
//        case 1:
//            cell = [tableView dequeueReusableCellWithIdentifier:@"DefaultCell"];
//            cell.textLabel.text = self.radiusTypes[indexPath.row][@"name"];
//            if ([self isExpandedSection:section]) {
//                cell.accessoryType = UITableViewCellAccessoryCheckmark;
//                
//            } else {
//                
//                //            cell.accessoryType = UITableViewCellAccessoryNone;
//                
//                cell.accessoryView  = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"CirclePlus24.png"]];
//            }
//            //cell.on = [self.sortTypes containsObject:self.sortTypes[indexPath.row]];
//            // cell.delegate = self;
//            return cell;
//        case 2:
//            cell = [tableView dequeueReusableCellWithIdentifier:@"SwitchCell"];
//            cell.titleLabel.text = @"Offering a Deal";
////            cell.accessoryView = self.dealsSwitch;
////            cell.delegate = self;
//            return cell;
//        case 3:
//            cell = [tableView dequeueReusableCellWithIdentifier:@"SwitchCell"];
//            cell.titleLabel.text = self.categories[indexPath.row][@"name"];
//            
//            if (row == numRowsForCategories && ![self isExpandedSection:section]) {
//                cell = [tableView dequeueReusableCellWithIdentifier:@"DefaultCell"];
//                cell.textLabel.text = @"See All";
//                cell.accessoryView  = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"CirclePlus24.png"]];
//
//
//            } else {
//            
//            
//            cell.on = [self.selectedCategories containsObject:self.categories[indexPath.row]];
//            cell.delegate = self;
//            }
//            return cell;
//            
//            
//        default:
//            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"invalid section" userInfo:nil];
//            
//
//    }
//
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    

    
    return [[self.allFilters allFilters] objectAtIndex:section];
    

    
//    switch (section) {
//        case 0:
//                return @"SORT BY";
//
//        case 1:
//                return @"DISTANCE";
//
//        case 2:
//
//                return @"DEALS";
//        case 3:
//
//                return @"CATEGORIES";
//        default:
//            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"invalid section" userInfo:nil];
//    }

    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
//    switch (section) {
//        case 0:
//            if ([self isExpandedSection:section]) {
//                [self collapseSection:section withRow:row];
//                NSLog(@"Getting into expanded secion for 0th section");
//                
//                
//            } else {
//                [self expandSection:section];
//            }
//        case 1:
//            if ([self isExpandedSection:section]) {
//                [self collapseSection:section withRow:row];
//                
//                
//            } else {
//                [self expandSection:section];
//            }
//        case 3:
//            if (row == numRowsForCategories && ![self isExpandedSection:section]){
//                [self expandSection:section];
//                }
//    
//    }
   
    
}

#pragma mark - Switch cell delegate methods

- (void)switchCell:(SwitchCell *)cell didUpdateValue:(BOOL)value {

    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    

    
    NSString *key = [[self.allFilters allFilters] objectAtIndex:[indexPath section]];
    
    NSArray *contents = [[self.allFilters allContents] objectForKey:key];
    
    NSString *contentForThisRow = [contents objectAtIndex:[indexPath row]];
    
    cell.titleLabel.text = contents[indexPath.row][@"name"];
    
    //NSInteger section = indexPath.section;
    //NSInteger row = indexPath.row;
    if (value) {
        [self.selectedCategories addObject:[contents objectAtIndex:[indexPath row]]];
        
    }else {
        [self.selectedCategories removeObject:[contents objectAtIndex:[indexPath row]]];
        
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
    [self.delegate filtersViewController:self didChangeFilters:self.filters];
    [self dismissViewControllerAnimated:YES completion:nil];
}
//
//-(void)initSortTypes {
//    self.sortTypes =
//    @[@{@"name" : @"Best Matched", @"code": @"0" },
//      @{@"name" : @"Distance", @"code": @"1" },
//      @{@"name" : @"Highest Rated", @"code": @"2" }];
//
//}
//
//- (void)initRadiusTypes {
//    self.radiusTypes =
//    @[@{@"name" : @"0.3 miles", @"code": @"483" },
//      @{@"name" : @"1 mile", @"code": @"1609" },
//      @{@"name" : @"5 miles", @"code": @"8047" },
//      @{@"name" : @"20 miles", @"code": @"32187" }];
//    
//}
//
//- (void)initCategories {
//    self.categories =
//    @[@{@"name" : @"Afghan", @"code": @"afghani" },
//      @{@"name" : @"African", @"code": @"african" },
//      @{@"name" : @"American, New", @"code": @"newamerican" },
//      @{@"name" : @"American, Traditional", @"code": @"tradamerican" },
//      @{@"name" : @"Arabian", @"code": @"arabian" },
//      @{@"name" : @"Argentine", @"code": @"argentine" },
//      @{@"name" : @"Armenian", @"code": @"armenian" },
//      @{@"name" : @"Asian Fusion", @"code": @"asianfusion" },
//      @{@"name" : @"Asturian", @"code": @"asturian" },
//      @{@"name" : @"Australian", @"code": @"australian" },
//      @{@"name" : @"Austrian", @"code": @"austrian" },
//      @{@"name" : @"Baguettes", @"code": @"baguettes" },
//      @{@"name" : @"Bangladeshi", @"code": @"bangladeshi" },
//      @{@"name" : @"Barbeque", @"code": @"bbq" },
//      @{@"name" : @"Basque", @"code": @"basque" },
//      @{@"name" : @"Bavarian", @"code": @"bavarian" },
//      @{@"name" : @"Beer Garden", @"code": @"beergarden" },
//      @{@"name" : @"Beer Hall", @"code": @"beerhall" },
//      @{@"name" : @"Beisl", @"code": @"beisl" },
//      @{@"name" : @"Belgian", @"code": @"belgian" },
//      @{@"name" : @"Bistros", @"code": @"bistros" },
//      @{@"name" : @"Black Sea", @"code": @"blacksea" },
//      @{@"name" : @"Brasseries", @"code": @"brasseries" },
//      @{@"name" : @"Brazilian", @"code": @"brazilian" },
//      @{@"name" : @"Breakfast & Brunch", @"code": @"breakfast_brunch" },
//      @{@"name" : @"British", @"code": @"british" },
//      @{@"name" : @"Buffets", @"code": @"buffets" },
//      @{@"name" : @"Bulgarian", @"code": @"bulgarian" },
//      @{@"name" : @"Burgers", @"code": @"burgers" },
//      @{@"name" : @"Burmese", @"code": @"burmese" },
//      @{@"name" : @"Cafes", @"code": @"cafes" },
//      @{@"name" : @"Cafeteria", @"code": @"cafeteria" },
//      @{@"name" : @"Cajun/Creole", @"code": @"cajun" },
//      @{@"name" : @"Cambodian", @"code": @"cambodian" },
//      @{@"name" : @"Canadian", @"code": @"New)" },
//      @{@"name" : @"Canteen", @"code": @"canteen" },
//      @{@"name" : @"Caribbean", @"code": @"caribbean" },
//      @{@"name" : @"Catalan", @"code": @"catalan" },
//      @{@"name" : @"Chech", @"code": @"chech" },
//      @{@"name" : @"Cheesesteaks", @"code": @"cheesesteaks" },
//      @{@"name" : @"Chicken Shop", @"code": @"chickenshop" },
//      @{@"name" : @"Chicken Wings", @"code": @"chicken_wings" },
//      @{@"name" : @"Chilean", @"code": @"chilean" },
//      @{@"name" : @"Chinese", @"code": @"chinese" },
//      @{@"name" : @"Comfort Food", @"code": @"comfortfood" },
//      @{@"name" : @"Corsican", @"code": @"corsican" },
//      @{@"name" : @"Creperies", @"code": @"creperies" },
//      @{@"name" : @"Cuban", @"code": @"cuban" },
//      @{@"name" : @"Curry Sausage", @"code": @"currysausage" },
//      @{@"name" : @"Cypriot", @"code": @"cypriot" },
//      @{@"name" : @"Czech", @"code": @"czech" },
//      @{@"name" : @"Czech/Slovakian", @"code": @"czechslovakian" },
//      @{@"name" : @"Danish", @"code": @"danish" },
//      @{@"name" : @"Delis", @"code": @"delis" },
//      @{@"name" : @"Diners", @"code": @"diners" },
//      @{@"name" : @"Dumplings", @"code": @"dumplings" },
//      @{@"name" : @"Eastern European", @"code": @"eastern_european" },
//      @{@"name" : @"Ethiopian", @"code": @"ethiopian" },
//      @{@"name" : @"Fast Food", @"code": @"hotdogs" },
//      @{@"name" : @"Filipino", @"code": @"filipino" },
//      @{@"name" : @"Fish & Chips", @"code": @"fishnchips" },
//      @{@"name" : @"Fondue", @"code": @"fondue" },
//      @{@"name" : @"Food Court", @"code": @"food_court" },
//      @{@"name" : @"Food Stands", @"code": @"foodstands" },
//      @{@"name" : @"French", @"code": @"french" },
//      @{@"name" : @"French Southwest", @"code": @"sud_ouest" },
//      @{@"name" : @"Galician", @"code": @"galician" },
//      @{@"name" : @"Gastropubs", @"code": @"gastropubs" },
//      @{@"name" : @"Georgian", @"code": @"georgian" },
//      @{@"name" : @"German", @"code": @"german" },
//      @{@"name" : @"Giblets", @"code": @"giblets" },
//      @{@"name" : @"Gluten-Free", @"code": @"gluten_free" },
//      @{@"name" : @"Greek", @"code": @"greek" },
//      @{@"name" : @"Halal", @"code": @"halal" },
//      @{@"name" : @"Hawaiian", @"code": @"hawaiian" },
//      @{@"name" : @"Heuriger", @"code": @"heuriger" },
//      @{@"name" : @"Himalayan/Nepalese", @"code": @"himalayan" },
//      @{@"name" : @"Hong Kong Style Cafe", @"code": @"hkcafe" },
//      @{@"name" : @"Hot Dogs", @"code": @"hotdog" },
//      @{@"name" : @"Hot Pot", @"code": @"hotpot" },
//      @{@"name" : @"Hungarian", @"code": @"hungarian" },
//      @{@"name" : @"Iberian", @"code": @"iberian" },
//      @{@"name" : @"Indian", @"code": @"indpak" },
//      @{@"name" : @"Indonesian", @"code": @"indonesian" },
//      @{@"name" : @"International", @"code": @"international" },
//      @{@"name" : @"Irish", @"code": @"irish" },
//      @{@"name" : @"Island Pub", @"code": @"island_pub" },
//      @{@"name" : @"Israeli", @"code": @"israeli" },
//      @{@"name" : @"Italian", @"code": @"italian" },
//      @{@"name" : @"Japanese", @"code": @"japanese" },
//      @{@"name" : @"Jewish", @"code": @"jewish" },
//      @{@"name" : @"Kebab", @"code": @"kebab" },
//      @{@"name" : @"Korean", @"code": @"korean" },
//      @{@"name" : @"Kosher", @"code": @"kosher" },
//      @{@"name" : @"Kurdish", @"code": @"kurdish" },
//      @{@"name" : @"Laos", @"code": @"laos" },
//      @{@"name" : @"Laotian", @"code": @"laotian" },
//      @{@"name" : @"Latin American", @"code": @"latin" },
//      @{@"name" : @"Live/Raw Food", @"code": @"raw_food" },
//      @{@"name" : @"Lyonnais", @"code": @"lyonnais" },
//      @{@"name" : @"Malaysian", @"code": @"malaysian" },
//      @{@"name" : @"Meatballs", @"code": @"meatballs" },
//      @{@"name" : @"Mediterranean", @"code": @"mediterranean" },
//      @{@"name" : @"Mexican", @"code": @"mexican" },
//      @{@"name" : @"Middle Eastern", @"code": @"mideastern" },
//      @{@"name" : @"Milk Bars", @"code": @"milkbars" },
//      @{@"name" : @"Modern Australian", @"code": @"modern_australian" },
//      @{@"name" : @"Modern European", @"code": @"modern_european" },
//      @{@"name" : @"Mongolian", @"code": @"mongolian" },
//      @{@"name" : @"Moroccan", @"code": @"moroccan" },
//      @{@"name" : @"New Zealand", @"code": @"newzealand" },
//      @{@"name" : @"Night Food", @"code": @"nightfood" },
//      @{@"name" : @"Norcinerie", @"code": @"norcinerie" },
//      @{@"name" : @"Open Sandwiches", @"code": @"opensandwiches" },
//      @{@"name" : @"Oriental", @"code": @"oriental" },
//      @{@"name" : @"Pakistani", @"code": @"pakistani" },
//      @{@"name" : @"Parent Cafes", @"code": @"eltern_cafes" },
//      @{@"name" : @"Parma", @"code": @"parma" },
//      @{@"name" : @"Persian/Iranian", @"code": @"persian" },
//      @{@"name" : @"Peruvian", @"code": @"peruvian" },
//      @{@"name" : @"Pita", @"code": @"pita" },
//      @{@"name" : @"Pizza", @"code": @"pizza" },
//      @{@"name" : @"Polish", @"code": @"polish" },
//      @{@"name" : @"Portuguese", @"code": @"portuguese" },
//      @{@"name" : @"Potatoes", @"code": @"potatoes" },
//      @{@"name" : @"Poutineries", @"code": @"poutineries" },
//      @{@"name" : @"Pub Food", @"code": @"pubfood" },
//      @{@"name" : @"Rice", @"code": @"riceshop" },
//      @{@"name" : @"Romanian", @"code": @"romanian" },
//      @{@"name" : @"Rotisserie Chicken", @"code": @"rotisserie_chicken" },
//      @{@"name" : @"Rumanian", @"code": @"rumanian" },
//      @{@"name" : @"Russian", @"code": @"russian" },
//      @{@"name" : @"Salad", @"code": @"salad" },
//      @{@"name" : @"Sandwiches", @"code": @"sandwiches" },
//      @{@"name" : @"Scandinavian", @"code": @"scandinavian" },
//      @{@"name" : @"Scottish", @"code": @"scottish" },
//      @{@"name" : @"Seafood", @"code": @"seafood" },
//      @{@"name" : @"Serbo Croatian", @"code": @"serbocroatian" },
//      @{@"name" : @"Signature Cuisine", @"code": @"signature_cuisine" },
//      @{@"name" : @"Singaporean", @"code": @"singaporean" },
//      @{@"name" : @"Slovakian", @"code": @"slovakian" },
//      @{@"name" : @"Soul Food", @"code": @"soulfood" },
//      @{@"name" : @"Soup", @"code": @"soup" },
//      @{@"name" : @"Southern", @"code": @"southern" },
//      @{@"name" : @"Spanish", @"code": @"spanish" },
//      @{@"name" : @"Steakhouses", @"code": @"steak" },
//      @{@"name" : @"Sushi Bars", @"code": @"sushi" },
//      @{@"name" : @"Swabian", @"code": @"swabian" },
//      @{@"name" : @"Swedish", @"code": @"swedish" },
//      @{@"name" : @"Swiss Food", @"code": @"swissfood" },
//      @{@"name" : @"Tabernas", @"code": @"tabernas" },
//      @{@"name" : @"Taiwanese", @"code": @"taiwanese" },
//      @{@"name" : @"Tapas Bars", @"code": @"tapas" },
//      @{@"name" : @"Tapas/Small Plates", @"code": @"tapasmallplates" },
//      @{@"name" : @"Tex-Mex", @"code": @"tex-mex" },
//      @{@"name" : @"Thai", @"code": @"thai" },
//      @{@"name" : @"Traditional Norwegian", @"code": @"norwegian" },
//      @{@"name" : @"Traditional Swedish", @"code": @"traditional_swedish" },
//      @{@"name" : @"Trattorie", @"code": @"trattorie" },
//      @{@"name" : @"Turkish", @"code": @"turkish" },
//      @{@"name" : @"Ukrainian", @"code": @"ukrainian" },
//      @{@"name" : @"Uzbek", @"code": @"uzbek" },
//      @{@"name" : @"Vegan", @"code": @"vegan" },
//      @{@"name" : @"Vegetarian", @"code": @"vegetarian" },
//      @{@"name" : @"Venison", @"code": @"venison" },
//      @{@"name" : @"Vietnamese", @"code": @"vietnamese" },
//      @{@"name" : @"Wok", @"code": @"wok" },
//      @{@"name" : @"Wraps", @"code": @"wraps" },
//      @{@"name" : @"Yugoslav", @"code": @"yugoslav" }];
//}

@end



