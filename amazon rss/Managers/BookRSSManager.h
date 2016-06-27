//
//  BookRSSManager.h
//  amazon rss
//
//  Created by Erson Jay Mujar on 6/27/16.
//  Copyright © 2016 ersonjaymujar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BookRSSParser.h"

@interface BookRSSManager : NSObject <BookRSSParserDelegate>

@property (nonatomic, weak) id delegate;

- (void)loadRSSFeedFromUrls:(NSArray *)urls clearPreviousBooks:(BOOL)shouldClear;
- (void)loadRSSFeedFromUrl:(NSString *)url clearPreviousBooks:(BOOL)shouldClear;
/** This will search for books with title that contains @param  title
    and with minimum rating @param minRating and maximum rating @param maxRating
    @param minRating and @param maxRating are inclusive.
 */
- (NSArray *)searchBookWithTitle:(NSString *)title withMinimumRating:(float)minRating andMaximumRating:(float)maxRating;
- (void)clearBooks;

@end


@protocol BookRSSManagerDelegate <NSObject>
/** Called when books from rss feed are ready */
- (void)onBooksAreReady;

@end
