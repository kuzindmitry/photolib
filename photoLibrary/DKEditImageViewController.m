//
//  DKEditImageViewController.m
//  photoLibrary
//
//  Created by kuzindmitry on 13.04.17.
//  Copyright © 2017 kuzindmitry. All rights reserved.
//

#import "DKEditImageViewController.h"
#import "DKPhotoCell.h"

@interface DKEditImageViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate>
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UIImageView* imageView;
@property (nonatomic, retain) UICollectionView *collectionView;
@end

@implementation DKEditImageViewController

-(instancetype)init {
    if (self = [super init]) {
        self.assets = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
        self.view.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:67.0/255.0 blue:99.0/255.0 alpha:1.0];
    
    UIImage *image = [self getImageForAsset:_assets[0]];
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width)];
    _scrollView.clipsToBounds = YES;
    [self.view addSubview:_scrollView];
    
    
//    
    CGFloat newWidth;// = self.view.bounds.size.width;
    CGFloat newHeight;// = newWidth * ratio;
//
    if (image.size.width > image.size.height) {
        CGFloat ratio = image.size.width/image.size.height;
        newHeight = self.view.bounds.size.width;
        newWidth = newHeight * ratio;
    } else if (image.size.width < image.size.height) {
        CGFloat ratio = image.size.height/image.size.width;
        newWidth = self.view.bounds.size.width;
        newHeight = newWidth * ratio;
    } else {
        newWidth = self.view.bounds.size.width;
        newHeight = newWidth;
    }
    NSLog(@"width = %f and height = %f", newWidth, newHeight);
    self.scrollView.minimumZoomScale = 0.1;
    self.scrollView.maximumZoomScale = 1.0;
    self.scrollView.zoomScale = 1.0;
    self.scrollView.alwaysBounceVertical = YES;
    self.scrollView.delegate = self;
    self.scrollView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, newWidth, newHeight)];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    self.imageView.image = image;
    [self.scrollView addSubview:_imageView];
    [self.scrollView setContentSize:CGSizeMake(newWidth, newHeight)];
    _scrollView.contentSize = CGSizeMake(newWidth+1, newHeight+1);
    CGFloat newContentOffsetX = (self.scrollView.contentSize.width/2) - (self.scrollView.bounds.size.width/2);
    CGFloat newContentOffsetY = (self.scrollView.contentSize.height/2) - (self.scrollView.bounds.size.height/2);
    self.scrollView.contentOffset = CGPointMake(newContentOffsetX, newContentOffsetY);

    
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    flowLayout.minimumInteritemSpacing = 5;
    flowLayout.minimumLineSpacing = 5;
    flowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    flowLayout.itemSize = CGSizeMake(70, 70);
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.scrollView.frame) + 5, self.view.frame.size.width, 80) collectionViewLayout:flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    [_collectionView registerClass:[DKPhotoCell self] forCellWithReuseIdentifier:@"DKPhotoPreviewCell"];
    [self.view addSubview:_collectionView];
}

//-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
//    return self.imageView;
//}

-(UIImage *)getImageForAsset:(PHAsset *)asset {

    __block UIImage *image;
    PHImageRequestOptions *photoRequestOptions = [[PHImageRequestOptions alloc] init];
    photoRequestOptions.synchronous = YES;
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFit options:photoRequestOptions resultHandler:^(UIImage *result, NSDictionary *info) {
        if (result) {
            image = result;
        }
    }];
    return image;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DKPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DKPhotoPreviewCell" forIndexPath:indexPath];
    [cell setPhoto:self.previewImages[indexPath.row]];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.imageView.image = [self getImageForAsset:self.assets[indexPath.row]];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return  self.previewImages.count;
}
@end
