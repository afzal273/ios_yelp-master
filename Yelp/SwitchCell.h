//
//  SwitchCell.h
//  Yelp
//
//  Created by Syed, Afzal on 2/11/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

// forward declaration
@class SwitchCell;

@protocol SwitchCellDelegate <NSObject>

- (void) switchCell: (SwitchCell *)cell didUpdateValue:(BOOL)value;

@end


@interface SwitchCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property(nonatomic, assign) BOOL on;
@property(nonatomic, weak) id<SwitchCellDelegate> delegate;

- (void)setOn:(BOOL)on amimated:(BOOL)animated;


@end
