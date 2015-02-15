//
//  FiltersViewController.h
//  Yelp
//
//  Created by Syed, Afzal on 2/10/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

//Forward declaration
//This class is going to exist, it will be defined later
@class FiltersViewController;

@protocol FiltersViewControllerDelegate <NSObject>

- (void)filtersViewController:(FiltersViewController *) filtersViewController didChangeFilters:(NSDictionary *)filters;
- (void) setSelectedCategories : (NSMutableSet *) selectedCategories;

@end





@interface FiltersViewController : UIViewController

//need to make this property as weak as we don't want to leak memory
@property (nonatomic, weak) id<FiltersViewControllerDelegate> delegate;

@end
