//
//  Business.h
//  Yelp
//
//  Created by Syed, Afzal on 2/10/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Business : NSObject

@property  (nonatomic,strong) NSString *imageUrl;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *ratingImageUrl;
@property (nonatomic,assign) NSInteger numReviews;
@property (nonatomic,strong) NSString *address;
@property (nonatomic,strong) NSString *categories;
@property (nonatomic,assign) CGFloat distance;

+ (NSArray*) businessesWithDictionaies: (NSArray *) dictionaries;


@end

