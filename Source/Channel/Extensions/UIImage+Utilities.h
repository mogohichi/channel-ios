//
//  UIImage+Utilities.h
//
//  Created by Apisit Toompakdee on 8/27/14.
//  Copyright (c) 2014 Mizu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AssetsLibrary/ALAssetsLibrary.h"
#import <AssetsLibrary/ALAssetRepresentation.h>
#import <AssetsLibrary/ALAssetsGroup.h>
#import <ImageIO/ImageIO.h>

@import UIKit;

@interface UIImage(Utilities)

- (CGRect)convertCropRect:(CGRect)cropRect;
- (UIImage *)croppedImage:(CGRect)cropRect;
- (UIImage*)cropImageFromLibrary:(CGRect)cropRect;
- (UIImage *)scaledToSize:(CGSize)size;
- (UIImage *)scaledToMaxWidth:(CGFloat)width maxHeight:(CGFloat)height;
- (NSString*)saveToCacheDirectory:(NSString*)filename;
+ (UIImage*)imageFromCacheDirectory:(NSString*)filename;
- (void)saveImageToAlbum;
+ (void)deleteFromCacheDirectory:(NSString*)filename;
- (UIImage*)withWhiteBorderLeft:(CGFloat)left right:(CGFloat)right top:(CGFloat)top bottom:(CGFloat)bottom;
@end
