//
//  BookRSSParser.m
//  amazon rss
//
//  Created by Erson Jay Mujar on 6/27/16.
//  Copyright © 2016 ersonjaymujar. All rights reserved.
//

#import "BookRSSParser.h"

@interface BookRSSParser()
{
    NSXMLParser *_xmlParser;
    NSMutableArray *_parsedBooks;
    NSMutableArray *_tagStack;
    NSString *_tagPath;
    Book *_newBook;
}
@end

@implementation BookRSSParser

-(instancetype)initWithUrl:(NSString *)url
{
    self = [super init];
    if(self){
        _url = url;
        NSURL *contentURL = [[NSURL alloc] initWithString:_url];
        _xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:contentURL];
        _xmlParser.delegate = self;
    }
    return self;
}

-(instancetype)init
{
    return [self initWithUrl:NULL];
}

-(void)parse
{
    [_xmlParser parse];
}

#pragma mark - NSXMLParserDelegate

-(void)parserDidStartDocument:(NSXMLParser *)parser
{
    _tagStack = [NSMutableArray new];
    _tagPath = [[NSMutableString alloc] initWithString:@"/"];
    _parsedBooks = [NSMutableArray new];
}

-(void)parserDidEndDocument:(NSXMLParser *)parser
{
    _tagStack = nil;
    _tagPath = nil;
    /**Books are successfully parsed. Inform the delegate. */
    [_delegate bookRssParser:self parsedBooks:_parsedBooks];
    _parsedBooks = nil;
}

-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(nonnull NSError *)parseError
{
    _parsedBooks = nil;
    _tagPath = nil;
    _tagStack = nil;
    /** Something went wrong. Inform the delegate */
    [_delegate bookRssParser:self errorOccured:parseError];
}

-(void)parser:(NSXMLParser *)parser didStartElement:(nonnull NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName attributes:(nonnull NSDictionary<NSString *,NSString *> *)attributeDict{
    
    if([elementName isEqualToString:@"item"]){
        //if it is an item, create a book object
        _newBook = [Book new];
    }
        
    /**
     prepare to successively receive characters
     then push element to stack
     */
    NSMutableDictionary *context = [NSMutableDictionary new];
    [context setObject:attributeDict forKey:@"attributes"];
    NSMutableString *text = [NSMutableString new];
    [context setObject:text forKey:@"text"];
    [_tagStack addObject:context];
    _tagPath = [_tagPath stringByAppendingPathComponent:elementName];
}

-(void)parser:(NSXMLParser *)parser didEndElement:(nonnull NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName
{
    NSMutableDictionary *context = [_tagStack lastObject];
    NSMutableString *text = [context objectForKey:@"text"];
    //NSDictionary *attributes = [context objectForKey:@"attributes"];
    
    if([_tagPath isEqualToString:@"/rss/channel/item/title"]){
        _newBook.title = text;
    }else if([_tagPath isEqualToString:@"/rss/channel/item/pubDate"]){
        _newBook.pubDate = text;
    }else if([_tagPath isEqualToString:@"/rss/channel/item/link"]){
        _newBook.url = text;
    }else if([_tagPath isEqualToString:@"/rss/channel/item/description"]){
        
        NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];
        TFHpple *htmlParser = [[TFHpple alloc] initWithHTMLData:data];
        
        NSArray *titleElements = [htmlParser searchWithXPathQuery:@"//span[@class='riRssTitle']/a"];
        TFHppleElement *titleElement = [titleElements firstObject];
        NSString *title = titleElement.firstChild.content;
        if(![title isEqualToString:@""] && title){
            _newBook.title = title;
        }
        
        //Get the book thumbnail and book cover
        NSArray *imageElements = [htmlParser searchWithXPathQuery:@"//a[@class='url']/img"];
        TFHppleElement *imageElement = [imageElements firstObject];
        NSString *imageSource = imageElement.attributes[@"src"];
        NSMutableArray *parts = [[imageSource componentsSeparatedByString:@"/"] mutableCopy];
        NSArray *pathParts = [parts.lastObject componentsSeparatedByString:@"."];
        [parts removeLastObject];
        //Create the url for the thumbnail
        [parts addObject:[NSString stringWithFormat:@"%@.%@.%@",pathParts.firstObject,@"_SL100", pathParts.lastObject]];
        NSString *thumbnailUrl  = [parts componentsJoinedByString:@"/"];
        _newBook.thumbnailUrl = thumbnailUrl;
        //Create the url for the cover
        [parts removeLastObject];
        [parts addObject:[NSString stringWithFormat:@"%@.%@.%@",pathParts.firstObject,@"_SL500", pathParts.lastObject]];
        NSString *bookCoverUrl = [parts componentsJoinedByString:@"/"];
        _newBook.coverUrl = bookCoverUrl;
        
        //Get the author
        NSArray *authorElements = [htmlParser searchWithXPathQuery:@"//span[@class='riRssContributor']/a"];
        TFHppleElement *authorElement = [authorElements firstObject];
        NSString *author = authorElement.firstChild.content;
        _newBook.author = author ? author:@"";
        
        //Get the price
        NSArray *priceElements = [htmlParser searchWithXPathQuery:@"//font/b"];
        TFHppleElement *priceElement = [priceElements firstObject];
        NSString *price = priceElement.firstChild.content;
        _newBook.price = price;
        
        //Get the rating
        NSArray *ratingElements = [htmlParser searchWithXPathQuery:@"//img"];
        for (TFHppleElement *element in ratingElements)
        {
            if (![element.attributes[@"src"] containsString:@"stars"])
                continue;
            
            NSArray *parts = [element.attributes[@"src"] componentsSeparatedByString:@"-"];
            if (parts.count < 5) continue;
            
            NSString *rating = [NSString stringWithFormat:@"%@.%@", parts[3], [parts[4] substringToIndex:1]];
            _newBook.rating = rating ? rating:@"0.0";
        }
        
    }else if([_tagPath isEqualToString:@"/rss/channel/item/guid"]){
        _newBook.guid = text;
    }else if([_tagPath isEqualToString:@"/rss/channel/item"]){
        [_parsedBooks addObject:_newBook];
        _newBook = nil;
    }
    
    [_tagStack removeLastObject];
    _tagPath = [_tagPath stringByDeletingLastPathComponent];
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    NSMutableDictionary *context = [_tagStack lastObject];
    NSMutableString *text = [context objectForKey:@"text"];
    [text appendString:string];
}

-(void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)data
{
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSMutableDictionary *context = [_tagStack lastObject];
    NSMutableString *text = [context objectForKey:@"text"];
    [text appendString:string];
}

@end
