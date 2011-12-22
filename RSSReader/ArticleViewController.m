//
//  ArticleViewController.m
//  RSSReader
//
//  Created by Justin Beck on 12/22/11.
//  Copyright (c) 2011 BeckProduct. All rights reserved.
//

#import "ArticleViewController.h"
#import "ArticleView.h"

@implementation ArticleViewController

@synthesize article = _article;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Nothing to see here
    }
    return self;
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
    ArticleView *articleView = [[ArticleView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 440.0f)];
    self.view = articleView;
    
    [articleView autorelease];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    [(ArticleView *) self.view title].text = _article.title;
    [(ArticleView *) self.view description].text = _article.description;
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

@end
