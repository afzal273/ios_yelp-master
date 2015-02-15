//
//  AllFilters.h
//  Yelp
//
//  Created by Syed, Afzal on 2/13/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AllFilters : NSObject
@property(strong, nonatomic) NSMutableArray *allFilters;
@property(strong, nonatomic) NSMutableDictionary *allContents;


- (id) initAllFilters;


@end
