//
//  DKPhotoViewController.m
//  photoLibrary
//
//  Created by kuzindmitry on 13.04.17.
//  Copyright © 2017 kuzindmitry. All rights reserved.
//

#import "DKPhotoViewController.h"
#import "DKPhotoCell.h"
#import "DKEditImageViewController.h"

@interface DKPhotoViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, retain) UICollectionView *collectionView;
@property (nonatomic, retain) PHImageManager *manager;
@property (nonatomic) NSUInteger offset;
@property (nonatomic) CGFloat lastContentOffsetY;
@property (nonatomic) BOOL isLoad;
@property (nonatomic, retain) NSMutableArray* selectedAsset;
@property (nonatomic, retain) PHFetchResult *assets;

@end

@implementation DKPhotoViewController

-(instancetype)init {
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

-(void)setup {
    
    CGFloat quantityPerLine = 4;
    CGFloat spaceBetweenPhotos = 5;
    
    if (_limit == 0) {
        _limit = 50;
    }
    
    self.view.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:67.0/255.0 blue:99.0/255.0 alpha:1.0];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.minimumInteritemSpacing = spaceBetweenPhotos;
    flowLayout.minimumLineSpacing = spaceBetweenPhotos;
    flowLayout.sectionInset = UIEdgeInsetsMake(spaceBetweenPhotos, spaceBetweenPhotos,spaceBetweenPhotos, spaceBetweenPhotos);
    
    CGFloat width = ([UIScreen mainScreen].bounds.size.width - (spaceBetweenPhotos * (quantityPerLine + 1)))/quantityPerLine;
    
    flowLayout.itemSize = CGSizeMake(width, width);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 64) collectionViewLayout:flowLayout];
    [self.collectionView registerClass:[DKPhotoCell self] forCellWithReuseIdentifier:@"DKPhotoCell"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_collectionView];
    
    self.cancelRequestLibraryLabel = [[UILabel alloc] initWithFrame:self.view.bounds];
    self.cancelRequestLibraryLabel.textAlignment = NSTextAlignmentCenter;
    self.cancelRequestLibraryLabel.textColor = [UIColor whiteColor];
    self.cancelRequestLibraryLabel.text = @"We need your photos";
    self.cancelRequestLibraryLabel.hidden = YES;
    [self.view addSubview:self.cancelRequestLibraryLabel];
    
    self.manager = [PHImageManager defaultManager];
    
    UIBarButtonItem *barDone = [[UIBarButtonItem alloc] initWithTitle:@"Готово" style:UIBarButtonItemStyleDone target:self action:@selector(done)];
    barDone.enabled = NO;
    self.navigationItem.rightBarButtonItem = barDone;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkRequestStatus) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [self checkRequestStatus];
}

-(void)done {
    DKEditImageViewController *editViewController = [[DKEditImageViewController alloc] init];
    NSMutableArray *selectedAssets = [[NSMutableArray alloc] init];
    NSMutableArray *previewImages = [[NSMutableArray alloc] init];
    for (DKPhotoCell *cell in self.selectedAsset) {
        [selectedAssets addObject:cell.asset];
        [previewImages addObject:cell.photo];
    }

    editViewController.assets = [[NSMutableArray alloc] init];
    editViewController.assets = selectedAssets;
    editViewController.previewImages = previewImages;
    [self.navigationController pushViewController:editViewController animated:YES];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

-(void)updatePhotos {
    self.photos = [[NSMutableArray alloc] init];
    self.photos = [self fetchImages];
    [self.collectionView reloadData];
}

-(NSMutableArray *) fetchImages {
    
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
     self.assets = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:options];
    
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    
    CGSize size = CGSizeMake(150, 150);
    if (_imageSize.height != 0 && _imageSize.width != 0) {
        size = _imageSize;
    }
    PHImageRequestOptions *photoRequestOptions = [[PHImageRequestOptions alloc] init];
    photoRequestOptions.synchronous = YES;
    
    NSInteger currentOffset = _offset;
    NSInteger maxIndex = _limit + _offset;
    if (maxIndex > _assets.count) {
        maxIndex = _assets.count;
    }
    for (NSInteger i = currentOffset; i < maxIndex; i++)
    {
        PHAsset *asset = _assets[i];
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFit options:photoRequestOptions resultHandler:^(UIImage *result, NSDictionary *info) {
            if (result) {
                [photos addObject:result];
            }
        }];
        _offset++;
    }

    return photos;
}

-(void)checkRequestStatus {
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            switch (status) {
                case PHAuthorizationStatusAuthorized:
                    self.cancelRequestLibraryLabel.hidden = YES;
                    _offset = 0;
                    [self updatePhotos];
                    break;
                case PHAuthorizationStatusDenied:
                case PHAuthorizationStatusNotDetermined:
                case PHAuthorizationStatusRestricted:
                    self.cancelRequestLibraryLabel.hidden = NO;
                    break;
            }
        });
    }];
}

#pragma mark UICollectioViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photos.count + 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DKPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DKPhotoCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:245.0/255.0 blue:248.0/255.0 alpha:1.0];
    if (indexPath.row == 0) {
        UIImage *camera = self.imageCamera;
        [cell setPhoto:camera];
    } else {
        UIImage *photo = self.photos[indexPath.row - 1];
        [cell setPhoto:photo];
        cell.asset = self.assets[indexPath.row - 1];
    }
    return cell;
}

#pragma mark UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (!_selectedAsset) {
        self.selectedAsset = [[NSMutableArray alloc] init];
    }
    if (indexPath.row == 0) {
    
    } else {
        DKPhotoCell *cell = (DKPhotoCell *)[collectionView cellForItemAtIndexPath:indexPath];
        if (cell.isPhotoSelected) {
            [self.selectedAsset removeObject:cell];
            NSUInteger numberCell = cell.number;
            [cell setNumber:0];
            if (self.selectedAsset.count > 0) {
                for (DKPhotoCell *cel in self.selectedAsset) {
                    if (cel.number > numberCell) {
                        [cel setNumber:cel.number-1];
                    }
                }
            }
        } else {
            [self.selectedAsset addObject:cell];
            [cell setNumber:self.selectedAsset.count];
        }
        if (self.selectedAsset.count > 0) {
            self.navigationItem.rightBarButtonItem.enabled = YES;
        } else {
            self.navigationItem.rightBarButtonItem.enabled = NO;
        }
    }
}


#pragma mark UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y > self.lastContentOffsetY) {
        if (!self.isLoad) {
            self.isLoad = YES;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            
                NSMutableArray *array = [[NSMutableArray alloc] init];
                array = [self fetchImages];
                [self.photos addObjectsFromArray:array];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.collectionView reloadData];
                    self.isLoad = NO;
                });
            });
        }
    }
    _lastContentOffsetY = scrollView.contentOffset.y;
}


@end
