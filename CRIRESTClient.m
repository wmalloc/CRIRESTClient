//
//  CRIRestHTTPClient.m
//
//  Created by Waqar Malik on 7/22/12.
//  Copyright (c) 2012 Waqar Malik. All rights reserved.
//

#import "CRIRESTClient.h"

NSString * const CRIRESTClientErrorDomain = @"CRIRESTClientError";

NSString * const CRIRESTClientHTTPMethodGET = @"GET";
NSString * const CRIRESTClientHTTPMethodHEAD = @"HEAD";
NSString * const CRIRESTClientHTTPMethodPOST = @"POST";
NSString * const CRIRESTClientHTTPMethodPUT = @"PUT";
NSString * const CRIRESTClientHTTPMethodDELETE = @"DELETE";

@interface CRIRESTClient()
@property (strong) NSOperationQueue *operationQueue;
@end

@interface CRIRESTClient(Private)
+ (NSURLRequest *)_requestForURL:(in id)inURL method:(in NSString *)httpMethod payload:(in id)payload headers:(in NSDictionary *)headers;
- (NSURLRequest *)_requestForURL:(in id)inURL method:(in NSString *)httpMethod payload:(in id)payload headers:(in NSDictionary *)headers;
@end


@implementation CRIRESTClient
{
    NSMutableDictionary *_numberOfTriesPerRequest;
}

+ (CRIRESTClient *)sharedRESTClient
{
    static CRIRESTClient *sSharedRESTClient = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        sSharedRESTClient = [[self alloc] init];
    });

    return sSharedRESTClient;
}

- (id)init
{
    self = [super init];
    if(self != nil)
    {
        _operationQueue = [[NSOperationQueue alloc] init];
        _maxAllowedTries = 3;
        _numberOfTriesPerRequest = [NSMutableDictionary dictionary];
        _acceptableStatusCodes = [[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(200, 100)];
#if TARGET_OS_EMBEDDED || TARGET_IPHONE_SIMULATOR
        static const NSUInteger sPlatformReductionFactor = 4;
#else
        static const NSUInteger sPlatformReductionFactor = 1;
#endif
        _defaultResponseSize = 1 * 1024 * 1024 / sPlatformReductionFactor;
        _maximumResponseSize = 4 * 1024 * 1024 / sPlatformReductionFactor;
        _timeout = 10.0f;
        _cachePolicy = NSURLRequestUseProtocolCachePolicy;
    }
    return self;
}

+ (NSData *)GET:(in id)inURL error:(out NSError *__autoreleasing *)error
{
    return [self GET:inURL parameters:nil headers:nil error:error];
}

+ (NSData *)GET:(in id)inURL parameters:(in NSDictionary *)parameters headers:(in NSDictionary *)headers error:(out NSError *__autoreleasing * )error
{
     NSURLRequest *request = [self _requestForURL:inURL method:CRIRESTClientHTTPMethodGET payload:nil headers:headers];
    return [[CRIRESTClient sharedRESTClient] syncPerformRequest:request error:error];
}

+ (void)GET:(in id)inURL completionHandler:(CRIRESTTTPClientCompletionHandler)completionHandler
{
    [self GET:inURL parameters:nil headers:nil completionHandler:completionHandler];
}

+ (void)GET:(in id)inURL parameters:(in NSDictionary *)parameters headers:(in NSDictionary *)headers completionHandler:(CRIRESTTTPClientCompletionHandler)completionHandler
{
    NSURLRequest *request = [self _requestForURL:inURL method:CRIRESTClientHTTPMethodGET payload:nil headers:headers];
    [[CRIRESTClient sharedRESTClient] performRequest:request completionHandler:completionHandler];
}

+ (NSData *)POST:(in id)inURL payload:(in id)payload error:(NSError *__autoreleasing *)error
{
    return [self POST:inURL payload:payload error:error];
}

+ (NSData *)POST:(in id)inURL payload:(in id)payload headers:(NSDictionary *)headers error:(out NSError *__autoreleasing *)error
{
    NSURLRequest *request = [self _requestForURL:inURL method:CRIRESTClientHTTPMethodPOST payload:nil headers:headers];
    return [[CRIRESTClient sharedRESTClient] syncPerformRequest:request error:error];
}

+ (void)POST:(in id)inURL payload:(in id)payload completionHandler:(CRIRESTTTPClientCompletionHandler)completionHandler
{
    [self POST:inURL payload:payload headers:nil completionHandler:completionHandler];
}

+ (void)POST:(in id)inURL payload:(in id)payload headers:(in NSDictionary *)headers completionHandler:(CRIRESTTTPClientCompletionHandler)completionHandler
{
    NSURLRequest *request = [self _requestForURL:inURL method:CRIRESTClientHTTPMethodPOST payload:payload headers:headers];
    [[CRIRESTClient sharedRESTClient] performRequest:request completionHandler:completionHandler];
}

+ (NSData *)PUT:(in id)inURL payload:(in id)payload error:(out NSError *__autoreleasing *)error
{
    return [self PUT:inURL payload:payload headers:nil error:error];
}

+ (NSData *)PUT:(in id)inURL payload:(in id)payload headers:(in NSDictionary *)headers error:(out NSError *__autoreleasing *)error
{
    NSURLRequest *request = [self _requestForURL:inURL method:CRIRESTClientHTTPMethodPUT payload:nil headers:headers];
    return [[CRIRESTClient sharedRESTClient] syncPerformRequest:request error:error];
}

+ (void)PUT:(in id)inURL payload:(in id)payload completionHandler:(CRIRESTTTPClientCompletionHandler)completionHandler
{
    [self PUT:inURL payload:payload headers:nil completionHandler:completionHandler];
}

+ (void)PUT:(in id)inURL payload:(in id)payload headers:(in NSDictionary *)headers completionHandler:(CRIRESTTTPClientCompletionHandler)completionHandler
{
    NSURLRequest *request = [self _requestForURL:inURL method:CRIRESTClientHTTPMethodPUT payload:payload headers:headers];
    [[CRIRESTClient sharedRESTClient] performRequest:request completionHandler:completionHandler];
}

+ (NSData *)DELETE:(in id)inURL error:(out NSError *__autoreleasing *)error
{
    return [self DELETE:inURL headers:nil error:error];
}

+ (NSData *)DELETE:(in id)inURL headers:(in NSDictionary *)headers error:(out NSError *__autoreleasing *)error
{
    NSURLRequest *request = [self _requestForURL:inURL method:CRIRESTClientHTTPMethodDELETE payload:nil headers:headers];
    return [[CRIRESTClient sharedRESTClient] syncPerformRequest:request error:error];
}

+ (void)DELETE:(in id)inURL completionHandler:(CRIRESTTTPClientCompletionHandler)completionHandler
{
    [self DELETE:inURL headers:nil completionHandler:completionHandler];
}

+ (void)DELETE:(in id)inURL headers:(in NSDictionary *)headers completionHandler:(CRIRESTTTPClientCompletionHandler)completionHandler
{
    NSURLRequest *request = [self _requestForURL:inURL method:CRIRESTClientHTTPMethodDELETE payload:nil headers:headers];
    [[CRIRESTClient sharedRESTClient] performRequest:request completionHandler:completionHandler];
}

- (void)performRequest:(in NSURLRequest *)request completionHandler:(CRIRESTTTPClientCompletionHandler)completionHandler
{
    NSParameterAssert(nil != request);
    BOOL canHandleRequest = [NSURLConnection canHandleRequest:request];
    if(NO == canHandleRequest)
    {

        return;
    }
    assert(0 < _defaultResponseSize);
    assert(0 < _maximumResponseSize);
    assert(_defaultResponseSize <= _maximumResponseSize);

    NSNumber *numberOfTries = [_numberOfTriesPerRequest objectForKey:request];
    if(nil == numberOfTries)
    {
        numberOfTries = [NSNumber numberWithInteger:0];
        [_numberOfTriesPerRequest setObject:numberOfTries forKey:request];
    }

    if(_maxAllowedTries <= numberOfTries.integerValue)
    {
        [_numberOfTriesPerRequest removeObjectForKey:request];
        if(NULL != completionHandler)
        {
            NSError *error = [NSError errorWithDomain:CRIRESTClientErrorDomain code:CRIRESTClientErrorTriesExceeded userInfo:nil];
            completionHandler(nil, nil, error);
        }
        return;
    }

    numberOfTries = [NSNumber numberWithInteger:(numberOfTries.integerValue + 1)];
    [_numberOfTriesPerRequest setObject:numberOfTries forKey:request];

    [NSURLConnection sendAsynchronousRequest:request queue:_operationQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        assert(response != nil);
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if(error != nil)
        {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                completionHandler(data, httpResponse, error);
            }];
        } else {
            NSInteger statusCode = [httpResponse statusCode];
            NSString *contentType = [httpResponse MIMEType];
            
            if(!((statusCode >= 0) && [_acceptableStatusCodes containsIndex:(NSUInteger)statusCode]))
            {
                error = [NSError errorWithDomain:CRIRESTClientErrorDomain code:statusCode userInfo:nil];
                data = nil;
            } else if(!(_acceptableContentTypes == nil || (contentType != nil && [_acceptableContentTypes containsObject:contentType]))) {
                error = [NSError errorWithDomain:CRIRESTClientErrorDomain code:CRIRESTClientErrorBadContentType userInfo:nil];
                data = nil;
            } else {
                long long length = [response expectedContentLength];

                if(NSURLResponseUnknownLength == length)
                {
                    length = _defaultResponseSize;
                }

                if(length > (long long) _maximumResponseSize)
                {
                    error = [NSError errorWithDomain:CRIRESTClientErrorDomain code:CRIRESTClientErrorResponseTooLarge userInfo:nil];
                    data = nil;
                }
            }

            [_numberOfTriesPerRequest removeObjectForKey:request];
            if(NULL != completionHandler)
            {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    completionHandler(data, httpResponse, error);
                }];
            }
        }
    }];
}

- (NSData *)syncPerformRequest:(in NSURLRequest *)request error:(out NSError *__autoreleasing *)error
{
    dispatch_semaphore_t request_sema = dispatch_semaphore_create(1);
    __block NSData *responseData = nil;

    CRIRESTTTPClientCompletionHandler completionHander = ^(id data, NSHTTPURLResponse *response, NSError *networkError) {
        if(nil == networkError)
        {
            responseData = data;
        } else {
            *error = networkError;
        }
		dispatch_semaphore_signal(request_sema);
    };

	dispatch_semaphore_wait(request_sema, DISPATCH_TIME_FOREVER);
	[self performRequest:request completionHandler:completionHander];

	if([NSThread currentThread] == [NSThread mainThread])
    {
		while(dispatch_semaphore_wait(request_sema, 0.01) != 0)
        {
			[[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantPast]];
		}
	} else {
		dispatch_semaphore_wait(request_sema, DISPATCH_TIME_FOREVER);
	}
	dispatch_semaphore_signal(request_sema);

    return responseData;
}
@end

@implementation CRIRESTClient (Private)
+ (NSURLRequest *)_requestForURL:(in id)inURL method:(in NSString *)httpMethod payload:(in id)payload headers:(in NSDictionary *)headers
{
    return [[CRIRESTClient sharedRESTClient] _requestForURL:inURL method:httpMethod payload:payload headers:headers];
}

- (NSURLRequest *)_requestForURL:(in id)inURL method:(in NSString *)httpMethod payload:(in id)payload headers:(in NSDictionary *)headers
{
    NSParameterAssert(nil != inURL);
    NSParameterAssert(nil != httpMethod);
    inURL = [inURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = ([inURL isKindOfClass:[NSString class]]) ? [NSURL URLWithString:inURL] : inURL;

    NSAssert1(YES == [url.scheme hasPrefix:@"http"], @"CRRESTClient requires a valid HTTP(S) URL, received %@", url);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:_cachePolicy timeoutInterval:_timeout];
    [request setHTTPMethod:httpMethod];
    if(nil != headers)
    {
        [request setAllHTTPHeaderFields:headers];
    }

    if(nil != payload)
    {
        [request setHTTPBody:payload];
    }

    return request;
}
@end

