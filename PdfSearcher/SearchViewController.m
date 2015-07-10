//
//  ViewController.m
//  PdfSearcher
//
//  Created by WangXiaofei on 15/7/9.
//  Copyright (c) 2015年 WangXiaofei. All rights reserved.
//

#import "SearchViewController.h"
#import "ResultTableViewCell.h"
#import "GTMOAuth2ViewControllerTouch.h"
#import "GTLDrive.h"
#import "AFJSONRequestOperation.h"
#import "AFImageCache.h"
#import "Record.h"

#import "WebViewController.h"

static NSString *const ResultCellIdentifier = @"ResultTableViewCell";

static NSString *const searchAPIKey = @"AIzaSyDMXvzKqDq5mUUlnPxotHO0up1Bcp8QmCo";
static NSString *const searchEngineKey = @"017756918084100534407:khndsvwgsrk";

@interface SearchViewController ()

@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end

@implementation SearchViewController {
    NSMutableArray *searchResults;
    NSOperationQueue *queue;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    queue = [[NSOperationQueue alloc] init];
    
    [self.searchBar becomeFirstResponder];
    
    UINib *cellNib = [UINib nibWithNibName:ResultCellIdentifier  bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:ResultCellIdentifier];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"gg");
    [self performSearch];
}

- (void)performSearch
{
    if ([self.searchBar.text length] > 0) {
        [self.searchBar resignFirstResponder];
        
        [queue cancelAllOperations];
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
        
        [self.tableView reloadData];
        searchResults = [NSMutableArray arrayWithCapacity:10];
        NSURL *url = [self urlWithSearchText:self.searchBar.text];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        AFJSONRequestOperation *operation = [AFJSONRequestOperation
                                             JSONRequestOperationWithRequest:request
                                             success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                 [self parseDictionary:JSON];
                                                 [self.tableView reloadData];
                                                 
                                             } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                 NSLog(@"error %@, %@", error, JSON);
                                             }];
        [queue addOperation:operation];
        operation.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", nil];
        
    }
}

- (NSURL *)urlWithSearchText:(NSString *)searchText {
    NSString *temp = @".pdf";
    NSString *escapedSearchText = [[NSString stringWithFormat:@"%@%@", searchText, temp]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlString = [NSString stringWithFormat:@"https://www.googleapis.com/customsearch/v1?q=%@&key=%@&cx=%@", escapedSearchText, searchAPIKey, searchEngineKey];
    NSURL *url = [NSURL URLWithString:urlString];
    NSLog(@"%@", url);
    return url;
}

- (void)parseDictionary:(NSDictionary *)dictionary {
    NSArray *array = [dictionary objectForKey:@"items"];
    for (NSDictionary *resultDict in array) {
        Record *record = [self parseRecord:resultDict];
        [searchResults addObject:record];
    }
}

- (Record *)parseRecord:(NSDictionary *)dictionary {
    Record *record = [[Record alloc] init];
    [record configureWithDictionary:dictionary];
    return record;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [searchResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ResultCellIdentifier];
    Record *record = [searchResults objectAtIndex:indexPath.row];
    cell.nameLabel.text = record.name;
    cell.link = record.link;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"webView" sender:[searchResults objectAtIndex:indexPath.row]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"webView"]) {
        WebViewController *controller = segue.destinationViewController;
        Record *record = (Record *)sender;
        controller.webView.scalesPageToFit = YES;
        controller.url = record.link;
    }
}

@end
