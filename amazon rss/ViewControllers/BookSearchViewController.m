//
//  BookSearchViewController.m
//  amazon rss
//
//  Created by Erson Jay Mujar on 6/27/16.
//  Copyright © 2016 ersonjaymujar. All rights reserved.
//

#import "BookSearchViewController.h"

@interface BookSearchViewController ()
{
    BookRSSManager *_bookRSSManager;
    NSArray *_rssUrls;
    NSString *_bookToSearch;
}
@end

@implementation BookSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _bookRSSManager = [BookRSSManager new];
    _bookRSSManager.delegate = self;
    /** Load the config */
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:AMAZON_URL_LIST_FILENAME ofType:@"plist"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    if(dictionary) _rssUrls = [dictionary objectForKey:AMAZON_URL_KEY];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"bookTableView"]) {
        _bookTVC = (BookTableViewController *)segue.destinationViewController;
    }
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    _bookToSearch = searchText;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [_bookRSSManager loadRSSFeedFromUrls:_rssUrls clearPreviousBooks:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    searchBar.text = @"";
    _bookToSearch = @"";
    _bookTVC.books = nil;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    _bookToSearch = @"";
    _bookTVC.books = nil;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    [searchBar becomeFirstResponder];
    return YES;
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES;
}

#pragma mark - BookRSSManagerDelegate
- (void)onBooksAreReady
{
    NSArray *searchedBooks = [_bookRSSManager searchBookWithTitle:_bookToSearch withMinimumRating:4.5 andMaximumRating:5.0];
    if(searchedBooks.count == 0){
        searchedBooks = [_bookRSSManager searchBookWithTitle:_bookToSearch withMinimumRating:4.0 andMaximumRating:4.0];
    }
    /** Sort */
    NSSortDescriptor *sortByRating = [[NSSortDescriptor alloc] initWithKey:@"rating" ascending:NO];
    NSSortDescriptor *sortByTitle = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
    NSArray *sortedResult = [searchedBooks sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sortByRating, sortByTitle,nil]];
    _bookTVC.books = sortedResult;
    /** Check if found books */
    if(sortedResult.count == 0){
        [self showNoFoundBooksAlert];
    }
}

#pragma mark - UITapGestureRecognizer Callback
- (void)dismissKeyboard
{
    [self.view endEditing:YES];
}

#pragma mark - Helper
- (void)showNoFoundBooksAlert
{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Search Result"
                                          message:[NSString stringWithFormat:@"No found books with title \"%@\"",_bookToSearch]
                                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   NSLog(@"OK action");
                               }];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
