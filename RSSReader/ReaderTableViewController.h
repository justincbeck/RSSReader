//
//  ReaderTableViewController.h
//  RSSReader
//
//  Created by Justin Beck on 12/21/11.
//  Copyright (c) 2011 BeckProduct. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Article.h"
#import "ReaderTableView.h"

@interface ReaderTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, NSXMLParserDelegate>
{
    UIActivityIndicatorView *_activityIndicatorView;
    ReaderTableView *_tableView;
    NSMutableArray *_content;
    Article *_article;
    Boolean isItem;
    NSString *_currentElement;
}

@property (readwrite, nonatomic, retain) UIActivityIndicatorView *activityIndicatorView;

- (NSString *)stripHTML:(NSString *)string;
- (NSString *)decodeXML:(NSString *)string;

@end
