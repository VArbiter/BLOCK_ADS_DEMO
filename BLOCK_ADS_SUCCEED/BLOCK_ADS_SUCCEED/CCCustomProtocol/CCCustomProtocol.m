//
//  CCCustomProtocol.m
//  ADBLOCK_ANDROID_MODE_INVALUED
//
//  Created by 冯明庆 on 16/07/21.
//  Copyright © 2016年 冯明庆. All rights reserved.
//

#import "CCCustomProtocol.h"

static NSString * const _CC_HANDLE_URL_PROTOCOL_KEY_ = @"CC_HANDLE_URL_PROTOCOL_KEY";

static NSArray * _arrayAds = nil;

@interface CCCustomProtocol () < NSURLConnectionDelegate >

#pragma mark - System

+ (BOOL)canInitWithRequest:(NSURLRequest *)request ;

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request ;

+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b ;

- (void)startLoading ;

- (void)stopLoading ;

#pragma mark - Private Method (s) 
@property (nonatomic , strong) NSArray *arrayAds ;

/// 目前只能用 弃用的 NSURLConnection , 新的 NSURLSession 无效 . 原因未知 .
@property (nonatomic , strong) NSURLConnection *connection;

+ (NSArray *) ccGetAdsList ;

+ (NSMutableURLRequest *) ccRedirectHostWithRequest : (NSMutableURLRequest *) request ;

@end

@implementation CCCustomProtocol

#pragma mark - System

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    NSString *scheme = [[request URL] scheme];
    if (([scheme caseInsensitiveCompare:@"http"] == NSOrderedSame
         || [scheme caseInsensitiveCompare:@"https"] == NSOrderedSame)) {
        if ([NSURLProtocol propertyForKey:_CC_HANDLE_URL_PROTOCOL_KEY_ inRequest:request]) {
            return NO;
        }
        return YES;
    }
    return NO;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    NSString *stringURL = request.URL.absoluteString;
    for (NSString *stringAds in [self ccGetAdsList]) {
        if ([stringURL containsString:stringAds]) {
            NSMutableURLRequest *mutableReqeust = [request mutableCopy];
            mutableReqeust = [self ccRedirectHostWithRequest:mutableReqeust];
            return mutableReqeust;
        }
    }
    return request;
}

+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b {
    return [super requestIsCacheEquivalent:a toRequest:b];
}

- (void)startLoading {
    NSMutableURLRequest *mutableReqeust = [[self request] mutableCopy];
    
    [NSURLProtocol setProperty:@(YES)
                        forKey:_CC_HANDLE_URL_PROTOCOL_KEY_
                     inRequest:mutableReqeust];
    self.connection = [NSURLConnection connectionWithRequest:mutableReqeust
                                                    delegate:self];
}

- (void)stopLoading {
    [self.connection cancel];
}

#pragma mark - Private Method (s)

+ (NSArray *) ccGetAdsList {
    if (!_arrayAds || !_arrayAds.count) {
        _arrayAds = nil;
        NSString *stringAdsPath = [[NSBundle mainBundle] pathForResource:@"CC_ADS_LIST"
                                                                  ofType:@"plist"];
        _arrayAds = [NSMutableArray arrayWithContentsOfFile:stringAdsPath];
    }
    return _arrayAds;
}

+ (NSMutableURLRequest *) ccRedirectHostWithRequest : (NSMutableURLRequest *) request {
    if ([request.URL host].length == 0) {
        return request;
    }
    NSString *stringOriginUrl = [request.URL absoluteString];
    NSString *stringOriginHost = [request.URL host];
    NSRange rangeHost = [stringOriginUrl rangeOfString:stringOriginHost];
    if (rangeHost.location == NSNotFound) {
        return request;
    }
    
    NSString *stringIP = @"about:blank";

    NSString *stringUrl = [stringOriginUrl stringByReplacingCharactersInRange:rangeHost
                                                                   withString:stringIP];
    NSURL *url = [NSURL URLWithString:stringUrl];
    request.URL = url;
    
    return request;
}

#pragma mark - NSURLConnectionDelegate

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [self.client URLProtocol:self
          didReceiveResponse:response
          cacheStoragePolicy:NSURLCacheStorageNotAllowed];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.client URLProtocol:self
                 didLoadData:data];
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
    [self.client URLProtocolDidFinishLoading:self];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [self.client URLProtocol:self
            didFailWithError:error];
}

@end
