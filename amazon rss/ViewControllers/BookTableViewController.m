//
//  BookTableViewController.m
//  amazon rss
//
//  Created by Erson Jay Mujar on 6/27/16.
//  Copyright © 2016 ersonjaymujar. All rights reserved.
//

#import "BookTableViewController.h"

@interface BookTableViewController ()
{
    NSMutableDictionary *_bookThumbnails;
    NSMutableDictionary *_bookDictionary;
}
@end

@implementation BookTableViewController

- (void)setBooks:(NSArray *)books
{
    _books = books;
    _bookThumbnails = [NSMutableDictionary new];
    _bookDictionary = [NSMutableDictionary new];
    /** We have this to make searching for books to update thumbnail easier */
    for (Book *book in _books) {
        NSMutableArray *bookArray = [_bookDictionary objectForKey:book.thumbnailUrl];
        if(!bookArray){
            bookArray = [NSMutableArray new];
            [_bookDictionary setObject:bookArray forKey:book.thumbnailUrl];
        }
        [bookArray addObject:book];
    }
    [self downloadBookThumbnails];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _books.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BookCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bookCell" forIndexPath:indexPath];
    if(!cell){
        cell = [[BookCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bookCell"];
    }
    
    Book *book = [_books objectAtIndex:indexPath.row];
    cell.title.text = book.title;
    cell.pubDate.text = book.pubDate;
    cell.rating.text = book.rating;
    
    //Set thumbnail
    UIImage *thumbnail = [_bookThumbnails objectForKey:book.thumbnailUrl];
    if(thumbnail == nil){
        thumbnail = [UIImage imageNamed:@"book_icon.png"];
    }
    cell.thumbnail.image = thumbnail;
    
    return cell;
}

#pragma mark - Helpers
- (void)downloadBookThumbnails
{
    for (Book *book in _books) {
        NSURLRequest *downloadRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:book.thumbnailUrl]];
        [[AFImageDownloader defaultInstance] downloadImageForURLRequest:downloadRequest success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull responseObject) {
            [_bookThumbnails setObject:responseObject forKey:[downloadRequest.URL absoluteString]];
            //Find the book that has this thumbnail
            NSArray *fBooks = [_bookDictionary objectForKey:[downloadRequest.URL  absoluteString]];
            if(fBooks){
                for (Book *fb in fBooks) {
                    NSInteger index = [_books indexOfObject:fb];
                    //Update the image of the book's cell
                    NSIndexPath *path = [NSIndexPath indexPathForRow:index inSection:0];
                    BookCell *cell = [self.tableView cellForRowAtIndexPath:path];
                    cell.thumbnail.image = responseObject;
                }
            }
        } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
            //failed to download
        }];
    }
}

@end
