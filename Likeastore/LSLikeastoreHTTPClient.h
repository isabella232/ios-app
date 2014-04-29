//
//  LSLikeastoreHTTPClient.h
//  Likeastore
//
//  Created by Dmitri Voronianski on 29.04.14.
//  Copyright (c) 2014 Dmitri Voronianski. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

@interface LSLikeastoreHTTPClient : AFHTTPRequestOperationManager

+ (LSLikeastoreHTTPClient *) create;

- (instancetype) init;

- (AFHTTPRequestOperation *) getEmailAndAPIToken:(id)userId success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure;

- (AFHTTPRequestOperation *) loginWithCredentials:(id)credentials
            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (AFHTTPRequestOperation *) getAccessToken:(id)parameters
                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (AFHTTPRequestOperation *) logout;

- (AFHTTPRequestOperation *) logoutWithSuccessBlock:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (AFHTTPRequestOperation *) getUser:(void (^)(AFHTTPRequestOperation *operation, id user))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end