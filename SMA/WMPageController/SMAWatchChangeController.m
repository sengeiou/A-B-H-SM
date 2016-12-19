//
//  SMAWatchChangeController.m
//  ViewFrameDemo
//
//  Created by 有限公司 深圳市 on 2016/12/6.
//  Copyright © 2016年 Wecan Studio. All rights reserved.
//

#import "SMAWatchChangeController.h"

@interface SMAWatchChangeController ()
{
    NSArray *watchInfos;
}
@property (nonatomic, strong) NSArray *musicCategories;
@end

@implementation SMAWatchChangeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeMethod];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)musicCategories {
    if (!_musicCategories) {
        _musicCategories = @[SMALocalizedString(@"setting_watchface_recommending"), SMALocalizedString(@"setting_watchface_dynamic"),SMALocalizedString(@"setting_watchface_pointer"),SMALocalizedString(@"setting_watchface_number"),SMALocalizedString(@"setting_watchface_other")];
    }
    return _musicCategories;
}

- (instancetype)init {
    if (self = [super init]) {
        self.titleSizeNormal = 15;
        self.titleSizeSelected = 15;
        self.menuViewStyle = WMMenuViewStyleLine;
        int imtemWidth;
        NSMutableArray *weightArr = [NSMutableArray array];
        for (int i = 0; i < self.musicCategories.count; i ++) {
            CGSize size = [[self.musicCategories objectAtIndex:i] sizeWithAttributes:@{NSFontAttributeName:FontGothamLight(15)}];
            [weightArr addObject:[NSString stringWithFormat:@"%f",size.width]];
        }
        imtemWidth =[[weightArr valueForKeyPath:@"@max.floatValue"] floatValue];
        self.menuItemWidth = imtemWidth + 3;
        self.titleSizeSelected = 15.0;
        self.titleSizeNormal = 14.0;
        self.titleFontName = @"Gotham-Light";
        self.menuHeight = 40;
     
        self.titleColorSelected = [SmaColor colorWithHexString:@"#5790f9" alpha:1];
        self.titleColorNormal = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0];

    }
    return self;
}

- (void)initializeMethod{
    self.title = SMALocalizedString(@"setting_watchface_title");
}

#pragma mark - Datasource & Delegate
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.musicCategories.count;
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    //创建一个layout布局类
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    //设置布局方向为垂直流布局
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //设置每个item的大小为100*100
    layout.itemSize = CGSizeMake(([UIScreen mainScreen].bounds.size.width-50)/3, ([UIScreen mainScreen].bounds.size.width-50)/3);
    SMAWatchCollectionController *vc = [[SMAWatchCollectionController alloc] initWithCollectionViewLayout:layout];
    watchInfos = @[watchface_recommending,watchface_dynamic,watchface_pointer,watchface_number,watchface_other];
    vc.watchBucket = [watchInfos objectAtIndex:index];
    return vc;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    return self.musicCategories[index];
}

- (void)pageController:(WMPageController *)pageController willEnterViewController:(__kindof UIViewController *)viewController withInfo:(NSDictionary *)info {
    NSLog(@"%@",viewController);
    SMAWatchChangeController *vc = (SMAWatchChangeController *)viewController;
//    NSLog(@"%@", NSStringFromCGPoint(vc.tableView.contentOffset));
//    if (vc.tableView.contentOffset.y > kWMHeaderViewHeight) {
//        return;
//    }
//    vc.tableView.contentOffset = CGPointMake(0, kNavigationBarHeight + kWMHeaderViewHeight - self.viewTop);
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
