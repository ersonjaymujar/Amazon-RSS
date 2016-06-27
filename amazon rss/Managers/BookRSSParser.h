//
//  BookRSSParser.h
//  amazon rss
//
//  Created by Erson Jay Mujar on 6/27/16.
//  Copyright © 2016 ersonjaymujar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFHpple.h"
#import "Book.h"

@protocol BookRSSParserDelegate;

@interface BookRSSParser : NSObject <NSXMLParserDelegate>

@property(nonatomic,weak) id<BookRSSParserDelegate> delegate;
/** The url that this parser is working on */
@property(nonatomic,readonly) NSString *url;

-(instancetype)initWithUrl:(NSString*)url;
-(void)parse;

@end

@protocol BookRSSParserDelegate <NSObject>

/** Callback when successfully parsed */
-(void)bookRssParser:(BookRSSParser*)parser parsedBooks:(NSArray*)books;
/** Callback when error occured while parsing */
-(void)bookRssParser:(BookRSSParser *)parser errorOccured:(NSError*)error;

@end
