//
//  BKPhotoImageSelectCtr.m
//  MiniBuKe
//
//  Created by chenheng on 2018/11/14.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKPhotoImageSelectCtr.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "BKBookneededUploadCtr.h"

@interface BKPhotoImageSelectCtr ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UIButton *finishBtn;
@property (nonatomic, strong) NavView *navView;

//显示照片
@property (nonatomic, strong) UICollectionView *ado_collectionView;

//所有照片组的数组（内部是所有相册的组）
@property (nonatomic, strong) NSMutableArray *photoGroupArr;

//所有照片组内的url数组（内部是最大的相册的照片url，这个相册一般名字是 所有照片或All Photos）
@property (nonatomic, strong) NSMutableArray *allPhotoArr;

//所选择的图片数组
@property (nonatomic, strong) NSMutableArray *chooseArray;

//所选择的图片所在cell的序列号数组
@property (nonatomic, strong) NSMutableArray *chooseCellArray;

@property (nonatomic, strong) NSMutableArray *choosePhotoArr;

@property (nonatomic, strong) PHCachingImageManager *imageManager;

@end

@implementation BKPhotoImageSelectCtr
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hideBarStyle];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self showBarStyle];
}

- (void)hideBarStyle {
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.navigationController.navigationBar.hidden = YES;
}
- (void)showBarStyle {
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = UIColorFromRGB(0xffffff);
    
    [self.view addSubview:[self ado_collectionView]];
    
    [self makeNav];

    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusDenied) {
            [self creatAlertController_alert];
        }else{
            [self getAllPhotos];
        }
        
    }];
}

#pragma mark GetAllPhotos
- (void)getAllPhotos {
    
    if ([bkphoneVersion integerValue] >= 8) {
        //高版本使用PhotoKit框架
        [self getHeightVersionAllPhotos];
    }
    else {
        //低版本使用ALAssetsLibrary框架
        [self getLowVersionAllPhotos];
    }
}

#pragma mark 高版本使用PhotoKit框架
- (void)getHeightVersionAllPhotos {
    
    [WPFunctionView getHeightVersionAllPhotos:^(PHFetchResult *allPhotos) {
        
        _imageManager = [[PHCachingImageManager alloc]init];
        
        if (!_allPhotoArr) {
            _allPhotoArr = [[NSMutableArray alloc]init];
        }
        NSLog(@"一共有%ld张照片",allPhotos.count);
        for (NSInteger i = 0; i < allPhotos.count; i++) {
            
            PHAsset *asset = allPhotos[i];
            if (asset.mediaType == PHAssetMediaTypeImage) {
                [_allPhotoArr addObject:asset];
            }
        }
        [self.ado_collectionView registerClass:[myPhotoCell class] forCellWithReuseIdentifier:photoCellId];
        [self.ado_collectionView reloadData];
    }];
}

#pragma mark 低版本使用ALAssetsLibrary框架
- (void)getLowVersionAllPhotos {
    
    [WPFunctionView getLowVersionAllPhotos:^(ALAssetsGroup *group) {
        if (!_photoGroupArr) {
            _photoGroupArr = [[NSMutableArray alloc]init];
        }
        
        if (group!=nil) {
            [_photoGroupArr addObject:group];
        }
        else{
            ALAssetsGroup* allPhotoGroup = _photoGroupArr[_photoGroupArr.count-1];
            
            if (!_allPhotoArr) {
                _allPhotoArr = [[NSMutableArray alloc]init];
            }
            
            //获取相册分组里面的照片内容
            [allPhotoGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                
                if (result&&[[result valueForProperty:ALAssetPropertyType]isEqualToString:ALAssetTypePhoto]) {
                    
                    //照片内容url加入数组
                    [_allPhotoArr addObject:result.defaultRepresentation.url];
                }
                else{
                    //刷新显示
                    if (_allPhotoArr.count) {
                        [self.ado_collectionView registerClass:[myPhotoCell class] forCellWithReuseIdentifier:photoCellId];
                        [self.ado_collectionView reloadData];
                    }
                }
            }];
        }
    }];
}

#pragma mark Collection
-(UICollectionView *)ado_collectionView
{
    if (!_ado_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setItemSize:CGSizeMake((SelfView_W-50)/4, (SelfView_W-50)/4)];
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        
        _ado_collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SelfView_W, SelfView_H) collectionViewLayout:layout];
        _ado_collectionView.backgroundColor = [UIColor whiteColor];
        _ado_collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _ado_collectionView.dataSource = self;
        _ado_collectionView.delegate = self;
        [_ado_collectionView setContentInset:UIEdgeInsetsMake(44, 0, 0, 0)];
        [self.ado_collectionView registerClass:[myPhotoCell class] forCellWithReuseIdentifier:photoCellId];
    }
    return _ado_collectionView;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.allPhotoArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (_allPhotoArr.count) {
        myPhotoCell *cell = (myPhotoCell *)[collectionView dequeueReusableCellWithReuseIdentifier:photoCellId forIndexPath:indexPath];
        cell.chooseStatus = NO;
        cell.signImage.image = WPhoto_btn_UnSelected;
       
        if (self.chooseCellArray.count) {
            if ([self.chooseCellArray containsObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row]]) {
                cell.signImage.image = WPhoto_Btn_Selected;
                cell.chooseStatus = YES;
                NSLog(@"selectok");
            }
        }

        if ([bkphoneVersion integerValue] >= 8) {
            PHAsset *asset = _allPhotoArr[_allPhotoArr.count - indexPath.item - 1];
            cell.progressView.hidden = YES;
            cell.representedAssetIdentifier = asset.localIdentifier;
            CGFloat scale = [UIScreen mainScreen].scale;
            CGSize cellSize = cell.frame.size;
            CGSize AssetGridThumbnailSize = CGSizeMake(cellSize.width * scale, cellSize.height * scale);
            
            [_imageManager requestImageForAsset:asset
                                     targetSize:AssetGridThumbnailSize
                                    contentMode:PHImageContentModeDefault
                                        options:nil
                                  resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                      if ([cell.representedAssetIdentifier isEqualToString:asset.localIdentifier]) {
                                          cell.photoView.image = result;
                                      }
                                  }];
            
        } else {
            if (!cell.photoView.image) {
                cell.progressView.hidden = YES;
                NSURL *url = self.allPhotoArr[self.allPhotoArr.count - indexPath.row - 1];
                ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
                [assetLibrary assetForURL:url resultBlock:^(ALAsset *asset) {
                    UIImage *image = [UIImage imageWithCGImage:asset.thumbnail];
                    cell.photoView.image = image;
                } failureBlock:^(NSError *error) {
                    NSLog(@"error=%@", error);
                }];
            }
        }
        
        return cell;
    } else {
        myPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:photoCellId forIndexPath:indexPath];
        cell.chooseStatus = NO;
        cell.signImage.image = WPhoto_btn_UnSelected;
        return cell;
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (!_chooseArray) {
        _chooseArray = [[NSMutableArray alloc]init];
    }
    if (!_chooseCellArray) {
        _chooseCellArray = [[NSMutableArray alloc]init];
    }
    
    myPhotoCell *cell = (myPhotoCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    if (_chooseArray.count>=_selectPhotoOfMax && cell.chooseStatus == NO) {
        UIAlertView *alertVC = [[UIAlertView alloc] initWithTitle:@"最多选择九张图片" message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:@"好", nil];
        [alertVC show];
        return;
    }

    if ([bkphoneVersion integerValue] >= 8) {
        PHAsset *asset = _allPhotoArr[_allPhotoArr.count-indexPath.row-1];
        
        [WPFunctionView getChoosePicPHImageManager:^(double progress) {
            
            cell.progressView.hidden = NO;
            cell.progressFloat = progress;
            
        } manager:^(UIImage *result) {
            // Hide the progress view now the request has completed.
            
            cell.progressView.hidden = YES;
            
            // Check if the request was successful.
            if (!result) {
                return;
            } else {
                
                if (cell.chooseStatus == NO) {
                    if ((_chooseArray.count+_choosePhotoArr.count)< _selectPhotoOfMax) {
                        [_chooseArray addObject:result];
                        [_chooseCellArray addObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
                        [self.navView changeBtnWithNumber:_chooseArray.count];
                        
                        cell.signImage.image = WPhoto_Btn_Selected;
                        [WPFunctionView shakeToShow:cell.signImage];
                        
                        cell.chooseStatus = YES;
                    }
                } else{
                    
                    for (NSInteger j = 0; j<_chooseCellArray.count; j++) {
                        
                        NSIndexPath *ip = [NSIndexPath indexPathForRow:[_chooseCellArray[j] integerValue] inSection:0];
                        
                        if (indexPath.row == ip.row) {
                            [_chooseArray removeObjectAtIndex:j];
                        }
                    }
                    [_chooseArray removeObject:result];
                    [_chooseCellArray removeObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
                    [self.navView changeBtnWithNumber:_chooseArray.count];

                    cell.chooseStatus = NO;
                    cell.signImage.image = WPhoto_btn_UnSelected;

                }
            }
        } asset:asset viewSize:self.view.bounds.size];
        
    } else {
        if (cell.chooseStatus == NO) {
            if ((_chooseArray.count+_choosePhotoArr.count) < _selectPhotoOfMax) {
                [_chooseArray addObject:_allPhotoArr[_allPhotoArr.count-indexPath.row-1]];
                [_chooseCellArray addObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
                [self.navView changeBtnWithNumber:_chooseArray.count];

                cell.chooseStatus = YES;
                cell.signImage.image = WPhoto_Btn_Selected;
                [WPFunctionView shakeToShow:cell.signImage];

            }
        } else{
            
            [_chooseArray removeObject:_allPhotoArr[_allPhotoArr.count-indexPath.row-1]];
            [_chooseCellArray removeObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
            [self.navView changeBtnWithNumber:_chooseArray.count];

            cell.chooseStatus = NO;
            cell.signImage.image = WPhoto_btn_UnSelected;
        }
    }
}

#pragma mark FinishButton

//-(void)finishChoosePhotos:(UIButton *)finishbtn{
//
//    NSString *finishStr = [NSString stringWithFormat:@"0/%ld 完成", (long)_selectPhotoOfMax];
//    if (![finishbtn.titleLabel.text isEqualToString:finishStr]&&_chooseArray.count) {
//        [WPFunctionView finishChoosePhotos:^(NSMutableArray *myChoosePhotoArr) {
//            _selectPhotosBack(myChoosePhotoArr);
//            [self btnClickBack];
//        } chooseArray:_chooseArray];
//    }
//}
#pragma mark createNav
-(void)makeNav {
    self.navView = [[NavView alloc] init];
    _navView.frame = CGRectMake(0, 0, SelfView_W, navView_H);
    __weak typeof(self) weakSelf = self;
    [_navView setNavViewBack:^{
        [weakSelf btnClickBack];
    }];
    [_navView setQuitDoneBack:^{
        [weakSelf quitDoneBack];
    }];
    [self.view addSubview:_navView];
}

#pragma mark 选择完成
-(void)quitDoneBack{
    if (self.chooseArray.count) {
        
        BKBookneededUploadCtr *ctr = [[BKBookneededUploadCtr alloc]init];
        [ctr addDataWithArray:self.chooseArray];
        [self.navigationController pushViewController:ctr animated:YES];
        [self cancelAllChoose];
    }
}

- (void)cancelAllChoose{
        if (_ado_collectionView&&_chooseArray&&_chooseCellArray) {
            if (_chooseArray.count&&_chooseCellArray.count) {
    
                for (NSInteger i = 0; i<_chooseCellArray.count; i++) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[_chooseCellArray[i] integerValue] inSection:0];
                    myPhotoCell *cell = (myPhotoCell *)[_ado_collectionView cellForItemAtIndexPath:indexPath];
                    cell.signImage.image = WPhoto_btn_UnSelected;
                    cell.chooseStatus = NO;
                }
                [_chooseArray removeAllObjects];
                [_chooseCellArray removeAllObjects];
                [self.navView changeBtnWithNumber:_chooseArray.count];
            }
        }
}

#pragma mark 返回
-(void)btnClickBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)creatAlertController_alert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:@"请将'设置->隐私->照片->'设置为允许." preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [alert addAction:action2];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
