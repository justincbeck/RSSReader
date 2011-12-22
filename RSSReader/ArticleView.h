//
//  ArticleView.h
//  RSSReader
//
//  Created by Justin Beck on 12/22/11.
//  Copyright (c) 2011 BeckProduct. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Article.h"

@interface ArticleView : UIView
{
    UILabel *_title;
    UILabel *_description;
}

@property (nonatomic, retain) UILabel *title;
@property (nonatomic, retain) UILabel *description;

@end
