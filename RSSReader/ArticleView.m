//
//  ArticleView.m
//  RSSReader
//
//  Created by Justin Beck on 12/22/11.
//  Copyright (c) 2011 BeckProduct. All rights reserved.
//

#import "ArticleView.h"

@implementation ArticleView

@synthesize title = _title;
@synthesize description = _description;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _title = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 14.0f)];
        [_title setFont:[UIFont fontWithName:@"Helvetica" size:12.0]];
        [_title setLineBreakMode:UILineBreakModeWordWrap];
        [_title setNumberOfLines:0];
        [self addSubview:_title];
        
        _description = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 14.0f, 320.0f, 400.0f)];
        [_description setFont:[UIFont fontWithName:@"Helvetica" size:10.0]];
        [_description setLineBreakMode:UILineBreakModeWordWrap];
        [_description setNumberOfLines:0];
        
        [self addSubview:_description];

    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
