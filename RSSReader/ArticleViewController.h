//
//  ArticleViewController.h
//  RSSReader
//
//  Created by Justin Beck on 12/22/11.
//  Copyright (c) 2011 BeckProduct. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Article.h"

@interface ArticleViewController : UIViewController
{
    Article *_article;
}

@property (nonatomic, retain) Article *article;

@end
