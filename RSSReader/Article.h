//
//  Article.h
//  RSSReader
//
//  Created by Justin Beck on 12/13/11.
//  Copyright (c) 2011 BeckProduct. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Article : NSObject

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *link;
@property (nonatomic, retain) NSString *description;

@end
