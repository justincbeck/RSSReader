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

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _title = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 60.0f)];
        [self addSubview:_title];
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
