//
//  ReaderTableViewCell.h
//  RSSReader
//
//  Created by Justin Beck on 12/22/11.
//  Copyright (c) 2011 BeckProduct. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReaderTableViewCell : UITableViewCell
{
    UILabel *_title;
    UILabel *_description;
}

@property (nonatomic, retain) UILabel *title;
@property (nonatomic, retain) UILabel *description;

@end
