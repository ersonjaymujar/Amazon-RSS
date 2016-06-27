//
//  BookRSSManager.m
//  amazon rss
//
//  Created by Erson Jay Mujar on 6/27/16.
//  Copyright © 2016 ersonjaymujar. All rights reserved.
//

#import "BookRSSManager.h"

@interface BookRSSManager()
{
    NSMutableDictionary<NSString *,Book *> *_books;
    NSOperationQueue *_parserOperationQueue;
}
@end

@implementation BookRSSManager

- (instancetype)init
{
    self = [super init];
    if(self){
        _books = [NSMutableDictionary new];
        _parserOperationQueue = [NSOperationQueue new];
    }
    return self;
}

- (void)loadRSSFeedFromUrls:(NSArray *)urls clearPreviousBooks:(BOOL)shouldClear
{
    if(shouldClear) [self clearBooks];
    for (NSString *url in urls) {
        [self loadRSSFeedFromUrl:url clearPreviousBooks:false];
    }
}

- (void)loadRSSFeedFromUrl:(NSString *)url clearPreviousBooks:(BOOL)shouldClear
{
    if([url isEqualToString:@""] || url == nil) return;
    if(shouldClear) [self clearBooks];
    NSInvocationOperation *parserOperation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(createParser:) object:url];
    [_parserOperationQueue addOperation:parserOperation];
}

- (NSArray *)searchBookWithTitle:(NSString *)title withMinimumRating:(float)minRating andMaximumRating:(float)maxRating
{
    //Filter books by rating first
    NSPredicate *ratingPredicate = [NSPredicate predicateWithBlock:^BOOL(Book *book, NSDictionary<NSString *,id> *bindings) {
        return [book.rating floatValue] >= minRating && [book.rating floatValue] <= maxRating;
    }];
    NSArray *booksFilteredByRating = [[_books allValues] filteredArrayUsingPredicate:ratingPredicate];
    //Filter by title
    NSPredicate *titlePredicate = [NSPredicate predicateWithBlock:^BOOL(Book *book, NSDictionary<NSString *,id> *bindings) {
        return [book.title.lowercaseString containsString:title.lowercaseString];
    }];
    NSArray *booksFilteredByTitle = [booksFilteredByRating filteredArrayUsingPredicate:titlePredicate];
    return booksFilteredByTitle;
}

- (void)clearBooks
{
    [_books removeAllObjects];
}

#pragma mark - Helpers
- (void)createParser:(NSString*)url
{
    BookRSSParser *parser = [[BookRSSParser alloc] initWithUrl:url];
    parser.delegate = self;
    [parser parse];
}

#pragma mark - BookRSSParserDelegate
- (void)bookRssParser:(BookRSSParser *)parser parsedBooks:(NSArray *)books
{
    /** Update our list of books. This will replace old entry if a new book with the same
        guid is parsed.
     */
    for (Book *book in books) {
        [_books setObject:book forKey:book.guid];
    }
    if(_parserOperationQueue.operationCount <= 1){
        dispatch_async(dispatch_get_main_queue(), ^{
            [_delegate onBooksAreReady];
        });
    }
}

- (void)bookRssParser:(BookRSSParser *)parser errorOccured:(NSError *)error
{
    
}

@end
