//
//  ViewController.m
//  PdfSearcher
//
//  Created by WangXiaofei on 15/7/9.
//  Copyright (c) 2015年 WangXiaofei. All rights reserved.
//

#import "SearchViewController.h"
#import "ResultCell.h"
#import "LoadingCell.h"
#import "NothingFoundCell.h"
#import "GTMOAuth2ViewControllerTouch.h"
#import "GTLDrive.h"
#import "AFJSONRequestOperation.h"
#import "AFImageCache.h"
#import "Record.h"

#import "WebViewController.h"

static NSString *const ResultCellIdentifier = @"ResultCell";
static NSString *const LoadingCellIdentifier = @"LoadingCell";
static NSString *const NothingFoundCellIdentifier = @"NothingFoundCell";

static NSString *const searchAPIKey = @"AIzaSyDMXvzKqDq5mUUlnPxotHO0up1Bcp8QmCo";
static NSString *const searchEngineKey = @"017756918084100534407:khndsvwgsrk";

@interface SearchViewController ()

@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end

@implementation SearchViewController {
    NSMutableArray *searchResults;
    NSOperationQueue *queue;
    BOOL isLoading;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    queue = [[NSOperationQueue alloc] init];
    
    [self.searchBar becomeFirstResponder];
    
    UINib *cellNib = [UINib nibWithNibName:ResultCellIdentifier  bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:ResultCellIdentifier];
    cellNib = [UINib nibWithNibName:LoadingCellIdentifier bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:LoadingCellIdentifier];
    cellNib = [UINib nibWithNibName:NothingFoundCellIdentifier  bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:NothingFoundCellIdentifier];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self performSearch];
}

- (void)performSearch
{
    if ([self.searchBar.text length] > 0) {
        [self.searchBar resignFirstResponder];
        
        [queue cancelAllOperations];
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
        
        isLoading = YES;
        [self.tableView reloadData];
        searchResults = [NSMutableArray arrayWithCapacity:10];
        NSURL *url = [self urlWithSearchText:self.searchBar.text];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        AFJSONRequestOperation *operation = [AFJSONRequestOperation
                                             JSONRequestOperationWithRequest:request
                                             success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                 [self parseDictionary:JSON];
                                                 isLoading = NO;
                                                 [self.tableView reloadData];
                                                 
                                             } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                 isLoading = NO;
                                                 [self.tableView reloadData];
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
    if (isLoading) {
        return 1;
    } else if (searchResults == nil) {
        return 0;
    } else if ([searchResults count] == 0){
        return 1;
    } else {
        return [searchResults count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (isLoading) {
        LoadingCell *cell = (LoadingCell *)[tableView dequeueReusableCellWithIdentifier:LoadingCellIdentifier];
        return cell;
    } else if ([searchResults count] == 0) {
        NothingFoundCell *cell = (NothingFoundCell *)[tableView dequeueReusableCellWithIdentifier:NothingFoundCellIdentifier];
        return cell;
    } else {
        ResultCell *cell = [tableView dequeueReusableCellWithIdentifier:ResultCellIdentifier];
        Record *record = [searchResults objectAtIndex:indexPath.row];
        cell.nameLabel.text = record.name;
        cell.link = record.link;
        return cell;
    }
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
