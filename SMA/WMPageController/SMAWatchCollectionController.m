//
//  SMAWatchCollectionController.m
//  ViewFrameDemo
//
//  Created by 有限公司 深圳市 on 2016/12/6.
//  Copyright © 2016年 Wecan Studio. All rights reserved.
//

#import "SMAWatchCollectionController.h"

@interface SMAWatchCollectionController ()
{
    NSMutableArray *watchFaces;
    NSMutableArray *oldFaces;
    SmaDialSwitchView *switchView;
}
@end

@implementation SMAWatchCollectionController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.collectionView registerNib:[UINib nibWithNibName:@"SMAWatchCollectionCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self initializeMethod];
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initializeMethod{
     SmaBleMgr.BLdelegate = self;
     [SmaBleSend getSwitchNumber];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        SmaAnalysisWebServiceTool *tool = [[SmaAnalysisWebServiceTool alloc] init];
        [tool acloudDownLoadWatchInfos:_watchBucket offset:0 callBack:^(NSArray *finish, NSError *error) {
            watchFaces = [(NSArray*)finish mutableCopy];
            [self.collectionView reloadData];
        }
        ];
    });
}

- (void)createUI{
    [self setupRefresh];
}

/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.collectionView addFooterWithTarget:self action:@selector(headerRereshing)];
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    self.collectionView.footerPullToRefreshText = SMALocalizedString(@"device_pullSync");
    self.collectionView.footerReleaseToRefreshText = SMALocalizedString(@"device_loosenSync");
    self.collectionView.footerRefreshingText = SMALocalizedString(@"device_syncing");
}
#pragma mark 开始进入刷新状态
- (void)headerRereshing{
    self.collectionView.scrollEnabled = NO;
    self.collectionView.footerRefreshingText = SMALocalizedString(@"device_syncing");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        SmaAnalysisWebServiceTool *tool = [[SmaAnalysisWebServiceTool alloc] init];
        [tool acloudDownLoadWatchInfos:_watchBucket offset:(int)watchFaces.count/24 + 1 callBack:^(NSArray *finish, NSError *error) {
            NSArray *resFace = (NSArray*)finish;
            [watchFaces addObjectsFromArray:resFace];
             dispatch_async(dispatch_get_main_queue(), ^{
                 if (!error) {
                     self.collectionView.footerRefreshingText = SMALocalizedString(@"device_syncSucc");
                 }
                 else{
                      self.collectionView.footerRefreshingText = SMALocalizedString(@"device_syncFail");
                 }
            [self.collectionView footerEndRefreshing];
            self.collectionView.scrollEnabled = YES;
            [self.collectionView reloadData];
            });
        }];
    });
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return watchFaces.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    __block SMAWatchCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // UIImage *cornerImage = [UIImage imageNamed:[imageArr objectAtIndex:indexPath.row]];
        dispatch_async(dispatch_get_main_queue(), ^{
            // 绘制操作完成
            // cell.switchView.image  = cornerImage;
        });
    });
    cell.watchDic = watchFaces[indexPath.row];
    return cell;
}

#pragma mark <UICollectionViewDelegate>

#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(20, 10, 20, 10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 20.0f;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    SMAWatchCollectionCell *cell = (SMAWatchCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if ([SmaBleMgr checkBLConnectState]) {
        if (oldFaces.count < 3) {
            [MBProgressHUD showError:SMALocalizedString(@"setting_noWatch")];
            SmaBleMgr.BLdelegate = self;
            [SmaBleSend getSwitchNumber];
            return;
        }

        SMAWatchView *watch = [[SMAWatchView alloc] initWithWatchInfos:cell.watchDic watchImage:cell.switchView.image];
        watch.olSwitchArr = oldFaces;
        [watch didButSelect:^(NSMutableArray *switchArr) {
            oldFaces = switchArr;
        }];
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [app.window addSubview:watch];
    }
}

- (void)bledidDisposeMode:(SMA_INFO_MODE)mode dataArr:(NSMutableArray *)data{
    if (mode == WATCHFACE) {
        NSLog(@"eghehjj---%@",data);
        oldFaces = data;
    }
}

@end
