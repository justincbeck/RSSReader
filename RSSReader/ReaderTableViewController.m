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
        NSMutableString *desc = [[string copy] autorelease]; 
        desc = [NSString stringWithString:[desc stringByReplacingOccurrencesOfString:key withString:[ENCODING valueForKey:key]]];
        string = desc;
    }
    
    return string;
}

- (NSString *)stripHTML:(NSString *)string
{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(.*?)<div.*</div>(<img.*?>)?" options:NSRegularExpressionCaseInsensitive | NSRegularExpressionDotMatchesLineSeparators error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:string options:0 range:NSMakeRange(0, [string length]) withTemplate:@"$1"];

    return modifiedString;
}

#pragma mark - NSXMLParserDelegate methods

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
    isItem = (isItem == YES || [elementName isEqualToString:@"item"]);
    _currentElement = [elementName copy];
    
    if ([elementName isEqualToString:@"item"]) {
        _articleTitle = [[NSMutableString alloc] init];
        _articleDescription = [[NSMutableString alloc] init];
        _articleLink = [[NSMutableString alloc] init];
        _article = [[Article alloc] init];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName
{
    if ([elementName isEqualToString:@"item"]) {
        _article.title = [self decodeXML:[self stripHTML:_articleTitle]];
        _article.description = [self decodeXML:[self stripHTML:_articleDescription]];
        _article.link = _articleLink;
        [_content addObject:_article];
        isItem = NO;
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (isItem)
    {
        if ([_currentElement isEqualToString:@"title"]) {
            [_articleTitle appendString:string];
        } else if ([_currentElement isEqualToString:@"link"]) {
            [_articleLink appendString:string];
        } else if ([_currentElement isEqualToString:@"description"]) {
            [_articleDescription appendString:string];
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
    
    [cnnClient release];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [_tableView reloadData];
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
        cell = [[[ReaderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier] autorelease];
    }
    
    Article *article = [_content objectAtIndex:[indexPath row]];
    if (article.read)
    {
        cell.title.textColor = [UIColor grayColor];
        cell.description.textColor = [UIColor grayColor];
    }
    
    [[cell title] setText:[article title]];
    [[cell description] setText:[article description]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: Figure out how to get the cell height
    return 69.0f;
}

#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ArticleViewController *articleViewController = [[ArticleViewController alloc] initWithNibName:nil bundle:nil];
    articleViewController.title = @"Article";
    [articleViewController setArticle:[_content objectAtIndex:[indexPath row]]];
    [self.navigationController pushViewController:articleViewController animated:YES];
    [articleViewController release];
    
    Article *article = [_content objectAtIndex:[indexPath row]];
    article.read = YES;
}

@end
