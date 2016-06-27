//
//  BookTableViewController.h
//  amazon rss
//
//  Created by Erson Jay Mujar on 6/27/16.
//  Copyright © 2016 ersonjaymujar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Book.h"
#import "BookCell.h"
#import "AFImageDownloader.h"

@interface BookTableViewController : UITableViewController

@property (nonatomic,strong) NSArray *books;

@end
