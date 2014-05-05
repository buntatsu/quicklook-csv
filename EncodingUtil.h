//
//  EncodingUtil.h
//  QuickLookCSV
//
//  Created by buntatsu on 2014/05/04.
//
//

#import <Foundation/Foundation.h>

@interface EncodingUtil : NSObject

+ (NSString *)stringWithContentsOfURL:(NSURL *)url usedEncoding:(NSStringEncoding *) enc;
+ (NSString *)htmlReadableEncoding:(NSStringEncoding) stringEncoding;
+ (NSString *)humanReadableEncoding:(NSStringEncoding) stringEncoding;

@end
