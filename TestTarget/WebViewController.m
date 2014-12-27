//
//  WebViewController.m
//  FRY
//
//  Created by Brian King on 12/26/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import "WebViewController.h"

@implementation WebViewController

- (UIWebView *)webView
{
    return (id)self.view;
}

- (void)loadView
{
    self.view = [[UIWebView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.webView.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.raizlabs.com/"]
                                                  cachePolicy:NSURLRequestReloadIgnoringCacheData
                                              timeoutInterval:10.0];
    [self.webView loadRequest:request];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

@end
