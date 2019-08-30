//
//  BKSearchController.m
//  MiniBuKe
//
//  Created by chenheng on 2019/1/8.
//  Copyright © 2019年 深圳偶家科技有限公司. All rights reserved.
//
#import "BKSearchController.h"
#import "BKCustomSearchView.h"
#import "BKSearchImagineCell.h"
#import <WebKit/WebKit.h>
#import "CommonUsePackaging.h"
#import "IntensiveReadingController.h"
#import "StoryPlayListViewController.h"
#import "XBKNetWorkManager.h"
#import "BkSearchResultModel.h"

#define URLH5Search     [NSString stringWithFormat:@"%@/template/html/searchPage/searchPage.html",H5SERVER_URL]
#define H5NoticFlag @"JsAction"

/* H5交互
 监听 JsAction
 JS方法: getSearchKeyword() / showResultEmpty()
 1.点击搜索历史 {ID:1001,data{}}
 2.点击绘本 ID:1002,data{}
 3.点击英语 ID:1003,data{}
 4.点击听听 ID:1004,data{}
 5. 搜索结果页开始滑动: ID:"scroll"
 **/
@interface BKSearchController ()<BKCustomSearchViewDelegate,UITableViewDelegate,UITableViewDataSource,WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>

@property (nonatomic, strong) BKCustomSearchView *searchView;//搜索框
@property (nonatomic, strong) UITableView *searchImaineTableView;//搜索联想view
@property (nonatomic, strong) WKWebView *webview;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) BKSearchImagineModel *imagineModel;
@property (nonatomic, copy) NSString* imagineWord;
@property (nonatomic, copy) NSString* changeWordWord;

@property (nonatomic, strong) UIProgressView *progress;

@end

@implementation BKSearchController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [self changeAnimationSearchView];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];

    [self.view addSubview:self.webview];
    [self LoadWebView];
}

- (void)setUI{
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, kStatusBarH, SCREEN_WIDTH, 44)];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    
    self.cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-52.f, 7, 52.f, 30)];
    [_cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:COLOR_STRING(@"#2f2f2f") forState:UIControlStateNormal];
    _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [topView addSubview:_cancelBtn];
    
    self.searchView = [[BKCustomSearchView alloc]initWithFrame:CGRectMake(0.5*(SCREEN_WIDTH-222), 6, 222, 32)];
    self.searchView.delegate = self;
    [topView addSubview:self.searchView];
    
    [self registerCustomTableViewCell];
}

- (void)cancelBtnClick{
    if ([self.webview isLoading]) {
        [self.webview stopLoading];
    }
    [self.searchView changeResignFirstResponder];
    
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)changeAnimationSearchView{
    if(self.searchView.frame.size.width == 222){
        [self.searchView changeAnimationUI];
        
        [UIView animateWithDuration:0.4 animations:^{
            self.searchView.frame = CGRectMake(15, 6, SCREEN_WIDTH-52.f-15.f, 32);
        }completion:^(BOOL finished) {
            [self.searchView changeBecomeFirstResponder];
        }];
    }
}
#pragma mark - BKCustomSearchViewDelegate 搜索框回调
- (void)SearchDoneWithText:(NSString *)searchStr{
    NSLog(@"end editing!-%@",searchStr);
    [self.searchView changeResignFirstResponder];
    [self removeSearchImagineView];
    
    [self toSearchWithStr:searchStr];
}

- (void)SearchFiledTextChange:(NSString *)changeStr{
    NSLog(@"change editing!-%@",changeStr);
    self.changeWordWord = changeStr;
    if (changeStr.length) {
        //搜索联想
        [self requestSearchImagineWithStr:changeStr];
    }else{
        //清空联想
        [self removeSearchImagineView];
        //回到历史记录页
        [self toSearchWithStr:@""];
    }
}

- (void)toSearchWithStr:(NSString*)str{
    NSDictionary *dic = @{@"content":str};
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    [self.webview evaluateJavaScript:[NSString stringWithFormat:@"getSearchKeyword(%@)",jsonString] completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        NSLog(@"%@",error);
    }];
}
#pragma mark - SearchImagine Action 搜索词联想
//请求搜索联想接口
- (void)requestSearchImagineWithStr:(NSString*)str{
    [XBKNetWorkManager requestSearchImagineWordWithSearchKey:str AndAndFinish:^(BKSearchImagineModel * _Nonnull model, NSError * _Nonnull error) {
        if (error == nil && model.code == 1) {
            if (model.data.count) {
                self.imagineModel = model;
                //添加搜索联想界面
                self.imagineWord = str;
                [self addSearchImagineView];
                NSLog(@"搜索到联想词列表-%@",self.imagineWord);
            }else{
                NSLog(@"无无无搜索联想词");
            }
        }
    }];
}

- (void)goToSearchImagineWithStr:(NSString*)searchstr{
    [self.searchView changeTheTextWithStr:searchstr];
    [self SearchDoneWithText:searchstr];
}
- (void)addSearchImagineView{
    if (![self.changeWordWord isEqualToString:self.imagineWord]) {
        return;
    }
    if (self.searchImaineTableView.superview == nil) {
        self.searchImaineTableView.frame = CGRectMake(0, kNavbarH, SCREEN_HEIGHT, SCREEN_HEIGHT-kNavbarH);
        [self.view addSubview:self.searchImaineTableView];
        [self.searchImaineTableView reloadData];
        
        [self.webview evaluateJavaScript:@"showResultEmpty(1)" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            NSLog(@"%@",error);
        }];
        
    }else{
        [self.searchImaineTableView reloadData];
    }
}

- (void)removeSearchImagineView{
    if (self.searchImaineTableView.superview) {
        [self.searchImaineTableView removeFromSuperview];
    }
}
#pragma mark- tableViewdelegate&dataSource
- (UITableView *)searchImaineTableView{
    if (_searchImaineTableView == nil) {
        _searchImaineTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,SCREEN_HEIGHT-kNavbarH) style:UITableViewStyleGrouped];
        _searchImaineTableView.delegate = self;
        _searchImaineTableView.dataSource = self;
        _searchImaineTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (@available(iOS 11.0, *)) {
            _searchImaineTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _searchImaineTableView.estimatedRowHeight = 0;
        _searchImaineTableView.estimatedSectionFooterHeight = 0;
        _searchImaineTableView.estimatedSectionHeaderHeight = 0;
        _searchImaineTableView.backgroundColor = COLOR_STRING(@"#F7F9FB");
        _searchImaineTableView.showsVerticalScrollIndicator = NO;
    }
    return _searchImaineTableView;
}

- (void)registerCustomTableViewCell{
    [self.searchImaineTableView registerClass:[BKSearchImagineCell class] forCellReuseIdentifier:NSStringFromClass([BKSearchImagineCell class])];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.imagineModel == nil) {
        return 0;
    }else{
        return self.imagineModel.data.count > 10 ? 10:self.imagineModel.data.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BKSearchImagineCell *cell = [BKSearchImagineCell BKBaseTableViewCellWithTableView:tableView];
    [cell setModelWithTitle:self.imagineModel.data[indexPath.row] andHightTitle:self.imagineWord];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [BKSearchImagineCell heightForCellWithObject:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self goToSearchImagineWithStr:self.imagineModel.data[indexPath.row]];
        //上报联想词点击
        [XBKNetWorkManager requestSearchImagineWordRecordWithSearchKey:self.changeWordWord andImagineKey:self.imagineModel.data[indexPath.row] AndAndFinish:^(id  _Nonnull responseObj, NSError * _Nonnull error) {
            NSLog(@"%@-error=%@",responseObj,error);
        }];
    });
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    BKSearchImagineCell *cell = (BKSearchImagineCell*)[tableView cellForRowAtIndexPath:indexPath];
    [cell changeTheHighlightedUI:YES];
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        BKSearchImagineCell *cell = (BKSearchImagineCell*)[tableView cellForRowAtIndexPath:indexPath];
        [cell changeTheHighlightedUI:NO];
    });
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (self.searchImaineTableView.superview) {
        [self.searchView changeResignFirstResponder];
    }
    if ([scrollView.superview isKindOfClass:[WKWebView class]]) {
        [self.searchView changeResignFirstResponder];
    }
}

#pragma mark - web页相关
- (void)LoadWebView{
    NSString *url = [NSString stringWithFormat:@"%@?token=%@",URLH5Search,APP_DELEGATE.mLoginResult.token];
    NSString *encodedString = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:encodedString]]];
    [BKLoadAnimationView ShowHitOn:self.webview Frame:self.webview.bounds];
}

- (UIProgressView *)progress
{
    if (_progress == nil)
    {
        _progress = [[UIProgressView alloc]initWithFrame:CGRectMake(0, -1.5, SCREEN_WIDTH, 2)];
        _progress.progressTintColor = COLOR_STRING(@"#6FD06C");
        _progress.trackTintColor = COLOR_STRING(@"ededed");
        _progress.backgroundColor = [UIColor whiteColor];
        [self.webview addSubview:_progress];
    }
    return _progress;
}
-(WKWebView *)webview
{
    if (!_webview) {
        [CommonUsePackaging deletWebCache];
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        WKPreferences *preferences = [WKPreferences new];
        preferences.javaScriptCanOpenWindowsAutomatically = YES;
        configuration.preferences = preferences;
        _webview = [[WKWebView alloc]initWithFrame:CGRectMake(0, kNavbarH, SCREEN_WIDTH, SCREEN_HEIGHT-kNavbarH) configuration:configuration];
        _webview.UIDelegate = self;
        _webview.navigationDelegate = self;
        _webview.backgroundColor = [UIColor whiteColor];
        _webview.scrollView.delegate = self;
        _webview.scrollView.showsHorizontalScrollIndicator =NO;
        _webview.scrollView.showsVerticalScrollIndicator = NO;
//        [_webview addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
        [_webview.configuration.userContentController addScriptMessageHandler:self name:H5NoticFlag];
    }
    return _webview;
}

- (void)userContentController:(nonnull WKUserContentController *)userContentController didReceiveScriptMessage:(nonnull WKScriptMessage *)message {
    if ([message.name isEqualToString:H5NoticFlag]) {
        NSString *messageStr = message.body;
        NSData *jsonData = [messageStr dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        NSString *actionID = dic[@"ID"];
        NSDictionary *dataDic = dic[@"data"];
        if ([actionID isEqualToString:@"1001"]) {//点击搜索历史
            NSString *searchStr = [dataDic objectForKey:@"keyword"];
            [self.searchView changeTheTextWithStr:searchStr];
            
        }else if ([actionID isEqualToString:@"1002"]){//点击绘本
            
            BkSearchResultModel *model = [BkSearchResultModel mj_objectWithKeyValues:dataDic];
            [self webActionJumpBookWithBookId:model.resultId];
            
        }else if ([actionID isEqualToString:@"1003"]){//点击英语
            
            BkSearchResultModel *model = [BkSearchResultModel mj_objectWithKeyValues:dataDic];
            [self webActionJumpBookWithBookId:model.resultId];
            
        }else if ([actionID isEqualToString:@"1004"]){//点击听听
            
            BkSearchResultModel *model = [BkSearchResultModel mj_objectWithKeyValues:dataDic];
            [self webActionJumpTingTingWith:model];
            
        }else if ([actionID isEqualToString:@"scroll"]){//结果页滑动
            [self.searchView changeResignFirstResponder];
        }
    }
}

-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"===didStartProvisionalNavigation=====");
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    [MBProgressHUD showMessage:@"" toView:self.webview];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    NSLog(@"didFinishNavigation");
//    [MBProgressHUD hideHUDForView:self.view];
    [BKLoadAnimationView HiddenFrom:self.webview];
    [self.searchView changeBecomeFirstResponder];

    NSString *injectionJSString = @"var script = document.createElement('meta');"
    "script.name = 'viewport';"
    "script.content=\"width=device-width, initial-scale=1.0,maximum-scale=1.0, minimum-scale=1.0, user-scalable=no\";"
    "document.getElementsByTagName('head')[0].appendChild(script);";
    [webView evaluateJavaScript:injectionJSString completionHandler:nil];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"%@",error);
    [BKLoadAnimationView HiddenFrom:self.webview];
    [self addNetError];
}

//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
//    //加载进度值
//    if ([keyPath isEqualToString:@"estimatedProgress"])
//    {
//        if (object == self.webview)
//        {
//            if(self.webview.estimatedProgress >= 1.0f)
//            {
//                [MBProgressHUD hideHUDForView:self.view];
//            }
//
//            [self.progress setAlpha:1.0f];
//            [self.progress setProgress:self.webview.estimatedProgress animated:YES];
//            if(self.webview.estimatedProgress >= 1.0f)
//            {
//                [UIView animateWithDuration:0.5f
//                                      delay:0.3f
//                                    options:UIViewAnimationOptionCurveEaseOut
//                                 animations:^{
//                                     [self.progress setAlpha:0.0f];
//                                 }
//                                 completion:^(BOOL finished) {
//                                     [self.progress setProgress:0.0f animated:NO];
//                                 }];
//            }
//        }
//        else
//        {
//            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
//        }
//    }
//    else
//    {
//        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
//    }
//}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    [self.webview removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webview.configuration.userContentController removeScriptMessageHandlerForName:H5NoticFlag];
    self.webview.navigationDelegate = nil;
    self.webview.scrollView.delegate = nil;
    self.webview.UIDelegate = nil;
    self.webview = nil;
}

#pragma mark - web交互跳转
- (void)webActionJumpBookWithBookId:(NSString*)bookId{
    //跳绘本页面
    IntensiveReadingController *vc = [[IntensiveReadingController alloc]init];
    vc.bookid = bookId;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)webActionJumpTingTingWith:(BkSearchResultModel*)model{
    //跳转听听专辑列表
    StoryPlayListViewController *playListViewController = [[StoryPlayListViewController alloc]init];
    StoryListModel *listModel = [[StoryListModel alloc]init];
    listModel.storyId = [model.resultId integerValue];
    listModel.picUrl = model.coverPic;
    listModel.sumTime = model.storyTime;
    listModel.storyCount = [model.storyNumber integerValue];
    listModel.name = model.title;
    playListViewController.listModel = listModel;
    [self.navigationController pushViewController:playListViewController animated:YES];
}

//- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
//    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        completionHandler();
//    }])];
//    [self presentViewController:alertController animated:YES completion:nil];
//
//}

#pragma mark - netError
- (void)addNetError{
    BKNetWorkErrorBackView *backView = [BKNetWorkErrorBackView showOn:self.webview WithFrame:self.webview.bounds];
    kWeakSelf(weakSelf);
    [backView setTryAgainAction:^{
        [weakSelf reloadAgain];
    }];
}
-(void)reloadAgain{
    [self LoadWebView];
}
@end
