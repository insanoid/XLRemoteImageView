//
//  UIImageView+XLNetworking.m
//  XLRemoteImageView
//
//  Created by Martin Barreto on 9/3/13.
//  Copyright (c) 2013 Xmartlabs. All rights reserved.
//

#import "UIImageView+XLNetworking.h"
#import "XLCircleProgressIndicator.h"
#import <SDWebImageDownloader.h>
#import <UIImageView+WebCache.h>
#import <objc/message.h>

@interface AFImageCache : NSCache
- (UIImage *)cachedImageForRequest:(NSURLRequest *)request;
- (void)cacheImage:(UIImage *)image
        forRequest:(NSURLRequest *)request;
@end

@implementation UIImageView (XLNetworking)

- (void)setImageWithURLRequest:(NSURLRequest *)urlRequest
              placeholderImage:(UIImage *)placeholderImage
                       success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image))success
                       failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error))failure
         downloadProgressBlock:(void (^)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead))downloadProgressBlock

{
    [self sd_cancelCurrentImageLoad];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    __block long long totalBytesRead = 0;
    [manager downloadImageWithURL:urlRequest.URL
        options:0
        progress:^(NSInteger receivedSize, NSInteger expectedSize) {
          totalBytesRead = totalBytesRead + receivedSize;
          downloadProgressBlock(receivedSize, totalBytesRead, expectedSize);
        }
        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
          if (image) {
              success(nil, nil, image);
          }
        }];
}

@end
