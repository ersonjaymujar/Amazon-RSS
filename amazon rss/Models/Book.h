//
//  Book.h
//  amazon rss
//
//  Created by Erson Jay Mujar on 6/27/16.
//  Copyright © 2016 ersonjaymujar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Serializable.h"

@interface Book : NSObject<Serializable>

@property (nonatomic, strong) NSString *guid;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *thumbnailUrl;
@property (nonatomic, strong) NSString *coverUrl;
@property (nonatomic, strong) NSString *pubDate;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *rating;

@end
