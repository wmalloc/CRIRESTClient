//
//  CRIRestHTTPClient.h
//
//  Created by Waqar Malik on 7/22/12.
//  Copyright (c) 2012 Waqar Malik. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^CRIRESTTTPClientCompletionHandler)(id responseData, NSHTTPURLResponse *response, NSError *error);

enum : int32_t
{
    CRIRESTClientErrorTriesExceeded = -1,
    CRIRESTClientErrorBadContentType = -2,
    CRIRESTClientErrorResponseTooLarge = -3
};

@interface CRIRESTClient : NSObject

@property (assign) NSTimeInterval timeout;
@property (assign) NSURLRequestCachePolicy cachePolicy;
@property (assign) NSUInteger maxAllowedTries;
@property (copy) NSIndexSet *acceptableStatusCodes;   // default is nil, implying 200..299
@property (copy) NSSet *acceptableContentTypes;       // default is nil, implying anything is acceptable
@property (assign) NSUInteger defaultResponseSize;    // default is 1 MB, ignored if responseOutputStream is set
@property (assign) NSUInteger maximumResponseSize;    // default is 4 MB, ignored if responseOutputStream is set
                                                      // defaults are 1/4 of the above on embedded

+ (CRIRESTClient *)sharedRESTClient;

+ (NSData *)GET:(in id)inURL error:(out NSError *__autoreleasing *)error;
+ (NSData *)GET:(in id)inURL parameters:(in NSDictionary *)parameters headers:(in NSDictionary *)headers error:(out NSError *__autoreleasing * )error;

+ (void)GET:(in id)inURL completionHandler:(CRIRESTTTPClientCompletionHandler)completionHandler;
+ (void)GET:(in id)inURL parameters:(in NSDictionary *)parameters headers:(in NSDictionary *)headers completionHandler:(CRIRESTTTPClientCompletionHandler)completionHandler;

+ (NSData *)POST:(in id)inURL payload:(in id)payload error:(NSError *__autoreleasing *)error;
+ (NSData *)POST:(in id)inURL payload:(in id)payload headers:(NSDictionary *)headers error:(out NSError *__autoreleasing *)error;

+ (void)POST:(in id)inURL payload:(in id)payload completionHandler:(CRIRESTTTPClientCompletionHandler)completionHandler;
+ (void)POST:(in id)inURL payload:(in id)payload headers:(in NSDictionary *)headers completionHandler:(CRIRESTTTPClientCompletionHandler)completionHandler;

+ (NSData *)PUT:(in id)inURL payload:(in id)payload error:(out NSError *__autoreleasing *)error;
+ (NSData *)PUT:(in id)inURL payload:(in id)payload headers:(in NSDictionary *)headers error:(out NSError *__autoreleasing *)error;

+ (void)PUT:(in id)inURL payload:(in id)payload completionHandler:(CRIRESTTTPClientCompletionHandler)completionHandler;
+ (void)PUT:(in id)inURL payload:(in id)payload headers:(in NSDictionary *)headers completionHandler:(CRIRESTTTPClientCompletionHandler)completionHandler;

+ (NSData *)DELETE:(in id)inURL error:(out NSError *__autoreleasing *)error;
+ (NSData *)DELETE:(in id)inURL headers:(in NSDictionary *)headers error:(out NSError *__autoreleasing *)error;

+ (void)DELETE:(in id)inURL completionHandler:(CRIRESTTTPClientCompletionHandler)completionHandler;
+ (void)DELETE:(in id)inURL headers:(in NSDictionary *)headers completionHandler:(CRIRESTTTPClientCompletionHandler)completionHandler;

- (void)performRequest:(in NSURLRequest *)request completionHandler:(CRIRESTTTPClientCompletionHandler)completionHandler;
- (NSData *)syncPerformRequest:(in NSURLRequest *)request error:(out NSError *__autoreleasing *)error;
@end
