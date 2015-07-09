//
//  ViewController.m
//  PdfSearcher
//
//  Created by WangXiaofei on 15/7/9.
//  Copyright (c) 2015年 WangXiaofei. All rights reserved.
//

#import "SearchViewController.h"
#import "ResultTableViewCell.h"

static NSString *const ResultCellIdentifier = @"ResultTableViewCell";

@interface SearchViewController ()

@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.searchBar becomeFirstResponder];
    
    UINib *cellNib = [UINib nibWithNibName:ResultCellIdentifier  bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:ResultCellIdentifier];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ResultTableViewCell *cell = (ResultTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"ResultTableViewCell"];
    cell.nameLabel.text = @"123";
    return cell;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
}

@end
