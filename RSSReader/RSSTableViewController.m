//
//  RSSTableViewController.m
//  RSSReader
//
//  Created by Justin Beck on 12/12/11.
//  Copyright (c) 2011 BeckProduct. All rights reserved.
//

#import "RSSTableViewController.h"
#import "AFHTTPClient.h"
#import "AFXMLRequestOperation.h"
#import "Article.h"

@implementation RSSTableViewController

@synthesize activityIndicatorView = _activityIndicatorView;

const static NSDictionary *ENCODING;

// ^(.*?)<div.*</div>(<img.*?>)?$

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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
    content = [[NSMutableArray alloc] init];
    
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
    currentElement = [elementName copy];
    
    if ([elementName isEqualToString:@"item"]) {
        article = [[Article alloc] init];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI
    qualifiedName:(NSString *)qualifiedName
{
    if ([elementName isEqualToString:@"item"]) {
        [content addObject:article];
        isItem = NO;
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (isItem)
    {
        if ([currentElement isEqualToString:@"title"]) {
            [article.title appendString:string];
        } else if ([currentElement isEqualToString:@"link"]) {
            [article.link appendString:string];
        } else if ([currentElement isEqualToString:@"description"]) {
            [article.description appendString:string];
        }
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    for (Article *a in content)
    {
        NSLog(@"Title: %@", a.title);
        NSLog(@"Link: %@", a.link);
        NSLog(@"Description: %@", [self stripHTML:[self decodeXML:a.description]]);
    }
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

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
