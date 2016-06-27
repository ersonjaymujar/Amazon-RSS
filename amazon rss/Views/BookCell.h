//
//  BookCell.h
//  amazon rss
//
//  Created by Erson Jay Mujar on 6/27/16.
//  Copyright © 2016 ersonjaymujar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *thumbnail;
@property (nonatomic, weak) IBOutlet UILabel *title;
@property (nonatomic, weak) IBOutlet UILabel *rating;
@property (nonatomic, weak) IBOutlet UILabel *pubDate;

@end
