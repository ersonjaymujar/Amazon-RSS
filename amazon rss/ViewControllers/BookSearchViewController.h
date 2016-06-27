//
//  BookSearchViewController.h
//  amazon rss
//
//  Created by Erson Jay Mujar on 6/27/16.
//  Copyright © 2016 ersonjaymujar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookRSSManager.h"
#import "BookTableViewController.h"

#define AMAZON_URL_LIST_FILENAME @"AmazonUrlList"
#define AMAZON_URL_KEY @"RSSUrl"

@interface BookSearchViewController : UIViewController <UISearchBarDelegate, BookRSSManagerDelegate>

@property (nonatomic,weak) BookTableViewController *bookTVC;

@end
