//
//  Article.m
//  RSSReader
//
//  Created by Justin Beck on 12/13/11.
//  Copyright (c) 2011 BeckProduct. All rights reserved.
//

#import "Article.h"

@implementation Article

@synthesize title = _title;
@synthesize link = _link;
@synthesize description = _description;
@synthesize read = _read;

- (id) init
{
    self = [super init];
    if (self)
    {
        _title = [[NSString alloc] init];
        _link = [[NSString alloc] init];
        _description = [[NSString alloc] init];
        _read = NO;
    }
    return self;
}

- (void) dealloc
{
    [_title release];
    [_link release];
    [_description release];
    
    [super dealloc];
}

@end
