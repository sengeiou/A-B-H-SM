

#import "SectionsViewController.h"
#import "UIImage+CKQ.h"
#import "SmaColor.h"
#import "NSDictionary-DeepMutableCopy.h"
#import "SmaLocalizeableInfo.h"
@interface SectionsViewController ()
{
    NSMutableData*_data;
    int _state;
    NSString* _duid;
    NSString* _token;
    NSString* _appKey;
    NSString* _appSecret;
    NSMutableArray* _areaArray;
}

@end


@implementation SectionsViewController
@synthesize names;
@synthesize keys;
@synthesize table;
@synthesize search;
@synthesize allNames;

#pragma mark -
#pragma mark Custom Methods
- (void)resetSearch
{
    NSMutableDictionary *allNamesCopy = [self.allNames mutableDeepCopy];
    self.names = allNamesCopy;
    NSMutableArray *keyArray = [[NSMutableArray alloc] init];
    [keyArray addObject:UITableViewIndexSearch];
    [keyArray addObjectsFromArray:[[self.allNames allKeys]
                                   sortedArrayUsingSelector:@selector(compare:)]];
    self.keys = keyArray;
}
- (void)handleSearchForTerm:(NSString *)searchTerm
{
    NSMutableArray *sectionsToRemove = [[NSMutableArray alloc] init];
    [self resetSearch];
    
    for (NSString *key in self.keys) {
        NSMutableArray *array = [names valueForKey:key];
        NSMutableArray *toRemove = [[NSMutableArray alloc] init];
        for (NSString *name in array) {
            if ([name rangeOfString:searchTerm
                            options:NSCaseInsensitiveSearch].location == NSNotFound)
                [toRemove addObject:name];
        }
        if ([array count] == [toRemove count])
            [sectionsToRemove addObject:key];
        [array removeObjectsInArray:toRemove];
    }
    [self.keys removeObjectsInArray:sectionsToRemove];
    [table reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    CGFloat statusBarHeight=0;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
    {
        statusBarHeight=20;
    }
    //改变电池栏颜色
    UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    
    statusBarView.backgroundColor=[UIColor colorWithRed:193/255.0 green:129/255.0 blue:253/255.0 alpha:1];
    [self.view addSubview:statusBarView];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0,0+statusBarHeight, self.view.frame.size.width, 44)];
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:[SmaLocalizeableInfo localizedString:@"login_choose_cou"]];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys: FontGothamLight(22),NSFontAttributeName,nil];
     [navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:193/255.0 green:129/255.0 blue:253/255.0 alpha:1] size:CGSizeMake(self.view.frame.size.width, 44)] forBarMetrics:UIBarMetricsDefault];
    navigationBar.titleTextAttributes = dic;
    [navigationBar pushNavigationItem:navigationItem animated:NO];
    [navigationItem setLeftBarButtonItem:[UIBarButtonItem itemWithIcon:@"icon_return" highIcon:@"icon_return" frame:CGRectMake(0, 0, 45, 30) target:self action:@selector(clickLeftButton) transfrom:270]];

    [self.view addSubview:navigationBar];
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 44+statusBarHeight, self.view.frame.size.width, 44)];
    searchBar.placeholder = @"";
    searchBar.barTintColor = [SmaColor colorWithHexString:@"#61C9FE" alpha:1];
    UITextField *searchField1 = [searchBar valueForKey:@"_searchField"];
    searchField1.font = FontGothamLight(12);
    self.search = searchBar;
    [self.view addSubview:self.search];
    
    table=[[UITableView alloc] initWithFrame:CGRectMake(0, 88+statusBarHeight, self.view.frame.size.width, self.view.bounds.size.height-(88+statusBarHeight)) style:UITableViewStylePlain];
    [self.view addSubview:table];
    
    table.dataSource=self;
    table.delegate=self;
    self.search.delegate=self;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"country"
                                                     ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc]
                          initWithContentsOfFile:path];
    self.allNames = dict;
    
    [self resetSearch];
    [table reloadData];
    [table setContentOffset:CGPointMake(0.0, 44.0) animated:NO];
}

-(void)setAreaArray:(NSMutableArray*)array
{
    _areaArray=[NSMutableArray arrayWithArray:array];
}

#pragma mark Table View Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [keys count];
    
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    if ([keys count] == 0)
        return 0;
    
    NSString *key = [keys objectAtIndex:section];
    NSArray *nameSection = [names objectForKey:key];
    return [nameSection count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger section = [indexPath section];
    NSString *key = [keys objectAtIndex:section];
    NSArray *nameSection = [names objectForKey:key];
    
    static NSString *SectionsTableIdentifier = @"SectionsTableIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             SectionsTableIdentifier ];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier: SectionsTableIdentifier ];
    }
    
    NSString* str1 = [nameSection objectAtIndex:indexPath.row];
    NSRange range=[str1 rangeOfString:@"+"];
    NSString* str2=[str1 substringFromIndex:range.location];
    NSString* areaCode=[str2 stringByReplacingOccurrencesOfString:@"+" withString:@""];
    NSString* countryName=[str1 substringToIndex:range.location];
    
    cell.textLabel.text=countryName;
    cell.detailTextLabel.text=[NSString stringWithFormat:@"+%@",areaCode];
    cell.textLabel.font = FontGothamLight(16);
    cell.detailTextLabel.font = FontGothamLight(16);
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section
{
    if ([keys count] == 0)
        return nil;
    NSString *key = [keys objectAtIndex:section];
    if (key == UITableViewIndexSearch)
        return nil;
    
    return key;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ([keys count] == 0)
        return nil;
    NSString *key = [keys objectAtIndex:section];
    if (key == UITableViewIndexSearch)
        return nil;
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 30)];
    lab.backgroundColor = [SmaColor colorWithHexString:@"#9DACFD" alpha:1];
    lab.text = key;
    lab.font = FontGothamLight(16);
    return lab;
}

//右边蓝色指示条
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (isSearching)
        return nil;
    return keys;
}
#pragma mark -
#pragma mark Table View Delegate Methods
- (NSIndexPath *)tableView:(UITableView *)tableView
  willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.search resignFirstResponder];
    self.search.text = @"";
    isSearching = NO;
    [tableView reloadData];
    return indexPath;
}
- (NSInteger)tableView:(UITableView *)tableView
sectionForSectionIndexTitle:(NSString *)title
               atIndex:(NSInteger)index
{
    NSString *key = [keys objectAtIndex:index];
    if (key == UITableViewIndexSearch)
    {
        [tableView setContentOffset:CGPointZero animated:NO];
        return NSNotFound;
    }
    else return index;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger section = [indexPath section];
    NSString *key = [keys objectAtIndex:section];
    NSArray *nameSection = [names objectForKey:key];
    
    NSString* str1 = [nameSection objectAtIndex:indexPath.row];
    NSRange range=[str1 rangeOfString:@"+"];
    NSString* str2=[str1 substringFromIndex:range.location];
    NSString* areaCode=[str2 stringByReplacingOccurrencesOfString:@"+" withString:@""];
    NSString* countryName=[str1 substringToIndex:range.location];
    
    
    NSLog(@"%@ %@",countryName,areaCode);
    
    [self.view endEditing:YES];
    

    //传递数据
    if ([self.delegate respondsToSelector:@selector(setSecondData:)]) {
        [self.delegate setSecondData:[NSString stringWithFormat:@"%@,%@",countryName,areaCode]];
    }
    
    //关闭当前
    [self clickLeftButton];
}

#pragma mark -
#pragma mark Search Bar Delegate Methods
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *searchTerm = [searchBar text];
    [self handleSearchForTerm:searchTerm];
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    isSearching = YES;
    [table reloadData];
}
- (void)searchBar:(UISearchBar *)searchBar
    textDidChange:(NSString *)searchTerm
{
    if ([searchTerm length] == 0)
    {
        [self resetSearch];
        [table reloadData];
        return;
    }
    
    [self handleSearchForTerm:searchTerm];
    
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    isSearching = NO;
    self.search.text = @"";
    
    [self resetSearch];
    [table reloadData];
    
    [searchBar resignFirstResponder];
}

-(void)clickLeftButton
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
