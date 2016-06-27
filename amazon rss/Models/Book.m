//
//  Book.m
//  amazon rss
//
//  Created by Erson Jay Mujar on 6/27/16.
//  Copyright © 2016 ersonjaymujar. All rights reserved.
//

#import "Book.h"

@implementation Book

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(self){
        _guid = [dictionary objectForKey:@"guid"];
        _title = [dictionary objectForKey:@"title"];
        _author = [dictionary objectForKey:@"author"];
        _url = [dictionary objectForKey:@"url"];
        _thumbnailUrl = [dictionary objectForKey:@"thumbnailUrl"];
        _coverUrl = [dictionary objectForKey:@"coverUrl"];
        _pubDate = [dictionary objectForKey:@"pubDate"];
        _price = [dictionary objectForKey:@"price"];
        _rating = [dictionary objectForKey:@"rating"];
    }
    return self;
}

- (NSDictionary *)serialize
{
    NSMutableDictionary *data = [NSMutableDictionary new];
    [data setObject:_guid forKey:@"guid"];
    [data setObject:_title forKey:@"title"];
    [data setObject:_author forKey:@"author"];
    [data setObject:_url forKey:@"url"];
    [data setObject:_thumbnailUrl forKey:@"thumbnailUrl"];
    [data setObject:_coverUrl forKey:@"coverUrl"];
    [data setObject:_pubDate forKey:@"pubDate"];
    [data setObject:_price forKey:@"price"];
    [data setObject:_rating forKey:@"rating"];
    return data;
}

- (NSString *)description
{
    NSString *description = [NSString stringWithFormat:@"title: %@\nauthor: %@\nguid: %@\nurl: %@\ncoverUrl: %@\nthumbnailUrl %@\npubDate: %@\nprice: %@\nrating: %@",_title,_author,_guid,_url,_coverUrl,_thumbnailUrl,_pubDate,_price,_rating];
    return description;
}

@end
