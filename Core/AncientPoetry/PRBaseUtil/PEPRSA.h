//
//  PEPRSA.h
//  PEPRead
//
//  Created by sunShine on 2021/10/29.
//  Copyright © 2021 PEP. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
//public key
//MFwwDQYJKoZIhvcNAQEBBQADSwAwSAJBAKvU/PqVsVaD4gWPn/0cH2MGeikTNCl70qEAsg21No0fB32TZ0jHIbblL+ocP8eyMH6Mp/4jKTuCIa3qZtAy8KUCAwEAAQ==
//private key
//MIIBVQIBADANBgkqhkiG9w0BAQEFAASCAT8wggE7AgEAAkEAq9T8+pWxVoPiBY+f/RwfYwZ6KRM0KXvSoQCyDbU2jR8HfZNnSMchtuUv6hw/x7Iwfoyn/iMpO4Ihrepm0DLwpQIDAQABAkAIc04JqMjy30ODUH/mu7ZTcWMamAYtsBg4sMcQ44OORw6sUU/bssnVBNx4PiGExPrOQBRReDB0tub6VdrOukJhAiEA5DkfZuCLlswfVT1Ky1dZCy7SNy6HLYQ1iPLdLunWAc0CIQDAvtrE1aJwzNo6iamuCGpWEAkHwxk/twhP4BQyX3yyOQIgHFp0akWPUga+Bcr9ldGeQGNqvmxLYv4/4Gm7zO5EJikCIQCmBH4o5p5ZLImXvDVz2nnFEWDF180qrTuymR6sWMTuOQIhALpYfZTzIwzTbAjD8Z6sBrYr16TVVGFW0HHxI8Pr2kmF
@interface PEPRSA : NSObject
// return base64 encoded string
+ (NSString *)encryptString:(NSString *)str publicKey:(NSString *)pubKey;
// return raw data
+ (NSData *)encryptData:(NSData *)data publicKey:(NSString *)pubKey;
// return base64 encoded string
+ (NSString *)encryptString:(NSString *)str privateKey:(NSString *)privKey;
// return raw data
+ (NSData *)encryptData:(NSData *)data privateKey:(NSString *)privKey;

// decrypt base64 encoded string, convert result to string(not base64 encoded)
+ (NSString *)decryptString:(NSString *)str publicKey:(NSString *)pubKey;
+ (NSData *)decryptData:(NSData *)data publicKey:(NSString *)pubKey;
+ (NSString *)decryptString:(NSString *)str privateKey:(NSString *)privKey;
+ (NSData *)decryptData:(NSData *)data privateKey:(NSString *)privKey;
@end

NS_ASSUME_NONNULL_END
