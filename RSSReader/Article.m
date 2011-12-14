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

- (id) init
{
    self.title = [[NSMutableString alloc] init];
    self.link = [[NSMutableString alloc] init];
    self.description = [[NSMutableString alloc] init];
    return self;
}

@end
