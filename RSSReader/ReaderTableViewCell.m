//
//  ReaderTableViewCell.m
//  RSSReader
//
//  Created by Justin Beck on 12/22/11.
//  Copyright (c) 2011 BeckProduct. All rights reserved.
//

#import "ReaderTableViewCell.h"

@implementation ReaderTableViewCell

@synthesize title = _title;
@synthesize description = _description;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _title = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 14.0f)];
        [_title setFont:[UIFont fontWithName:@"Helvetica" size:12.0]];
        [_title setLineBreakMode:UILineBreakModeWordWrap];
        [_title setNumberOfLines:0];
        
        [[self contentView] addSubview:_title];
        
        _description = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 14.0f, 320.0f, 30.0f)];
        [_description setFont:[UIFont fontWithName:@"Helvetica" size:10.0]];
        [_description setLineBreakMode:UILineBreakModeWordWrap];
        [_description setNumberOfLines:0];
        
        [[self contentView] addSubview:_description];

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
