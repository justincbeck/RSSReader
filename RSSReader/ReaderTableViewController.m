//
//  ReaderTableViewController.m
//  RSSReader
//
//  Created by Justin Beck on 12/21/11.
//  Copyright (c) 2011 BeckProduct. All rights reserved.
//

#import "ReaderTableViewController.h"
#import "ReaderTableViewCell.h"
#import "ArticleViewController.h"
#import "AFHTTPClient.h"
#import "AFXMLRequestOperation.h"
#import "Article.h"

@implementation ReaderTableViewController

@synthesize activityIndicatorView = _activityIndicatorView;

const static NSDictionary *ENCODING;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _content = [[NSMutableArray alloc] init];
        
        ENCODING = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"&", @"&amp;",
                    @"<", @"&lt;",
                    @">", @"&gt;",
                    @"\"", @"&quot;",
                    @"'", @"&apos;",
                    NULL]; 
    }

    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (NSString *)decodeXML:(NSString *)string
{
    for (NSString *key in ENCODING) {
        NSMutableString *desc = [string copy]; 
        desc = [NSString stringWithString:[desc stringByReplacingOccurrencesOfString:key withString:[ENCODING valueForKey:key]]];
        string = desc;
    }
    
    return string;
}

- (NSString *)stripHTML:(NSString *)string
{
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(.*?)<div.*</div>(<img.*?>)?" options:NSRegularExpressionCaseInsensitive | NSRegularExpressionDotMatchesLineSeparators error:&error];
    
    NSString *modifiedString = [regex stringByReplacingMatchesInString:string options:0 range:NSMakeRange(0, [string length]) withTemplate:@"$1"];
    
    return modifiedString;
}

#pragma mark - NSXMLParserDelegate methods

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
    isItem = (isItem == YES || [elementName isEqualToString:@"item"]);
    _currentElement = [elementName copy];
    
    if ([elementName isEqualToString:@"item"]) {
        _article = [[Article alloc] init];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName
{
    if ([elementName isEqualToString:@"item"]) {
        [_content addObject:_article];
        isItem = NO;
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (isItem)
    {
        if ([_currentElement isEqualToString:@"title"]) {
            [_article.title appendString:string];
        } else if ([_currentElement isEqualToString:@"link"]) {
            [_article.link appendString:string];
        } else if ([_currentElement isEqualToString:@"description"]) {
            [_article.description appendString:string];
        }
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    [_tableView reloadData];
}

- (void)parser:(NSXMLParser *)parser foundIgnorableWhitespace:(NSString *)whitespaceString
{
    NSLog(@"IgnorableContent: %@", whitespaceString);
}

#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 460.0f)];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    
    [self setView:_tableView];
    
    [_tableView release];
}

- (void)viewDidLoad
{
    NSURL *cnn = [NSURL URLWithString: @"http://rss.cnn.com/rss/"];
    
    AFHTTPClient *cnnClient = [[AFHTTPClient alloc] initWithBaseURL:cnn];
    
    void *success = ^(__unused AFHTTPRequestOperation *operation, id XML) {
        
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:XML];
        [parser setDelegate:self];
        [parser parse];
        
    };
    
    void *failure = ^(__unused AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", [error description]);
        
    };
    
    [cnnClient getPath:@"cnn_topstories.rss" parameters:NULL success: success failure: failure];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_content count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdentifier = @"ReaderCell";
    ReaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil)
    {
        cell = [[ReaderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    
    [[cell title] setText:[[_content objectAtIndex:[indexPath row]] title]];
    [[cell description] setText:[[_content objectAtIndex:[indexPath row]] description]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: Figure out how to get the cell height
    return 44.0f;
}

#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ArticleViewController *articleViewController = [[ArticleViewController alloc] initWithNibName:nil bundle:nil];
    articleViewController.title = @"Article";
    [articleViewController setArticle:[_content objectAtIndex:[indexPath row]]];
    [self.navigationController pushViewController:articleViewController animated:YES];
    [articleViewController release];
}

@end
