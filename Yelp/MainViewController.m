//
//  MainViewController.m
//  Yelp
//
//
//
//

#import "MainViewController.h"
#import "YelpClient.h"
#import "Business.h"
#import "BusinessCell.h"
#import "FiltersViewController.h"

NSString * const kYelpConsumerKey = @"vxKwwcR_NMQ7WaEiQBK_CA";
NSString * const kYelpConsumerSecret = @"33QCvh5bIF5jIHR5klQr7RtBDhQ";
NSString * const kYelpToken = @"uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV";
NSString * const kYelpTokenSecret = @"mqtKIxMIR4iBtBPZCmCLEb-Dz3Y";

@interface MainViewController ()<UITableViewDataSource, UITableViewDelegate, FiltersViewControllerDelegate, UISearchBarDelegate, UISearchDisplayDelegate>

@property (nonatomic, strong) YelpClient *client;
@property (nonatomic, strong) NSArray *businesses;
@property (nonatomic, strong)NSMutableArray *searchedBusinesses;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) IBOutlet UISearchBar *searchBar;

- (void) fetchBusinessesWithQuery: (NSString *)query params: (NSDictionary*)params;


@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
        self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
        
        [self fetchBusinessesWithQuery:@"Restaurants" params:nil];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.tableView.dataSource = self;
    self.tableView.delegate = self;

//    self.searchBar.di
    
    // Teach the table view about the cell
    
    [self.tableView registerNib:[UINib nibWithNibName:@"BusinessCell" bundle:nil] forCellReuseIdentifier:@"BusinessCell"];
    
    //self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 85;
    self.title = @"Yelp";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:self action:@selector(onFilterButton)];
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];
    self.searchBar.delegate = self;
    self.navigationItem.titleView = self.searchBar;
    self.navigationController.navigationBar.backgroundColor = [UIColor redColor];
    self.navigationController.navigationBar.barTintColor = [UIColor redColor];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Search Methods

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
//    [searchBar sizeToFit];
    [searchBar setShowsCancelButton:YES animated:YES];
//    [searchBar setSearchResultsButtonSelected:YES];
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"Search button clicked");
    //    NSString *test = [self.searchBar.text];
    NSString *query = self.searchBar.text;
    [self fetchBusinessesWithQuery:query params:nil];
    //    [self ]
    [searchBar setShowsCancelButton:NO];
    [searchBar resignFirstResponder];
}

// Reset searchbar on cancel
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:NO animated:YES];
    self.searchBar.text = @"";
    [self fetchBusinessesWithQuery:@"" params:nil];
    [searchBar resignFirstResponder];

//    self.searching = NO;
//    [self refreshView];
//    [searchBar sizeToFit];
}



#pragma mark - Table Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.businesses.count;
    
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Grab me a cell, create a new one if there isnt' one or dequeue one
    BusinessCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BusinessCell"];
    
    //the cell itself knows how to configure the business
    cell.business = self.businesses[indexPath.row];
    return cell;
    
    
 }

#pragma mark - Filter delegate methods

- (void)filtersViewController:(FiltersViewController *)filtersViewController didChangeFilters:(NSDictionary *)filters {
    //fire a network event
    [self fetchBusinessesWithQuery:@"Restaurants" params:filters];
    //NSLog(@"Fire new network event: %@", filters);
}


#pragma mark - Private methods

- (void) fetchBusinessesWithQuery: (NSString *)query params: (NSDictionary*)params {
    
    [self.client searchWithTerm:query params:params success:^(AFHTTPRequestOperation *operation, id response) {
       // NSLog(@"response %@", response);
        NSArray *businessDictionaries = response[@"businesses"];
        self.businesses = [Business businessesWithDictionaies:businessDictionaries];
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"error: %@", [error description]);
    }];


}

- (void) onFilterButton{
    FiltersViewController *vc = [[FiltersViewController alloc]init];
    vc.delegate = self;
    UINavigationController *nvc = [[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:nil];
}




@end
