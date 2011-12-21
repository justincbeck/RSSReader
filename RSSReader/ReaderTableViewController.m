//
//  ReaderTableViewController.m
//  RSSReader
//
//  Created by Justin Beck on 12/21/11.
//  Copyright (c) 2011 BeckProduct. All rights reserved.
//

#import "ReaderTableViewController.h"
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
        NSURL *cnn = [NSURL URLWithString: @"http://rss.cnn.com/rss/"];
        
        AFHTTPClient *cnnClient = [[AFHTTPClient alloc] initWithBaseURL:cnn];
        
        [cnnClient getPath:@"cnn_topstories.rss" parameters:NULL success:^(__unused AFHTTPRequestOperation *operation, id XML) {
            
            NSXMLParser *parser = [[NSXMLParser alloc] initWithData:XML];
            [parser setDelegate:self];
            [parser parse];
            
        } failure:^(__unused AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"%@", @"Failure");
            
        }];
    }

    _content = [[NSMutableArray alloc] init];
    
    ENCODING = [[NSDictionary alloc] initWithObjectsAndKeys:
                @"&", @"&amp;",
                @"<", @"&lt;",
                @">", @"&gt;",
                @"\"", @"&quot;",
                @"'", @"&apos;",
                NULL]; 
    
    return self;
}

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
    for (Article *a in _content)
    {
        NSLog(@"Title: %@", a.title);
        NSLog(@"Link: %@", a.link);
        NSLog(@"Description: %@", [self stripHTML:[self decodeXML:a.description]]);
    }
    
    [_tableView reloadData];
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

- (void)parser:(NSXMLParser *)parser foundIgnorableWhitespace:(NSString *)whitespaceString
{
    NSLog(@"IgnorableContent: %@", whitespaceString);
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 460.0f)];
    self.view = _tableView;
    
    [_tableView release];
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

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
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_content count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];    
    
    NSLog(@"%@", ((Article *) [_content objectAtIndex:[indexPath row]]).title);
    
    [[cell textLabel] setText:((Article *) [_content objectAtIndex:[indexPath row]]).title];
    [[cell textLabel] setFont:[UIFont fontWithName:@"Helvetica" size:12.0]];
    [[cell textLabel] setLineBreakMode:UILineBreakModeWordWrap];
    [[cell textLabel] setNumberOfLines:0];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

@end
