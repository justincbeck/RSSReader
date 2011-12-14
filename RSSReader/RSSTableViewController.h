//
//  RSSTableViewController.h
//  RSSReader
//
//  Created by Justin Beck on 12/12/11.
//  Copyright (c) 2011 BeckProduct. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Article.h"

@interface RSSTableViewController : UITableViewController <NSXMLParserDelegate>
{
    NSMutableArray *content;
    Article *article;
    Boolean isItem;
    NSString *currentElement;
}

@property (readwrite, nonatomic, retain) UIActivityIndicatorView *activityIndicatorView;

- (NSString *)stripHTML:(NSString *)string;
- (NSString *)decodeXML:(NSString *)string;

@end
