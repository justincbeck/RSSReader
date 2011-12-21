//
//  ReaderTableViewController.h
//  RSSReader
//
//  Created by Justin Beck on 12/21/11.
//  Copyright (c) 2011 BeckProduct. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Article.h"

@interface ReaderTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, NSXMLParserDelegate>
{
    UIActivityIndicatorView *_activityIndicatorView;
    UITableView *_tableView;
    NSMutableArray *_content;
    Article *_article;
    Boolean isItem;
    NSString *_currentElement;
}

@property (readwrite, nonatomic, retain) UIActivityIndicatorView *activityIndicatorView;

- (NSString *)stripHTML:(NSString *)string;
- (NSString *)decodeXML:(NSString *)string;

@end
