//
//  EncodingUtil.m
//  QuickLookCSV
//
//  Created by buntatsu on 2014/05/04.
//
//

#import "EncodingUtil.h"

@implementation EncodingUtil

+ (NSString *) stringWithContentsOfURL:(NSURL *)url usedEncoding:(NSStringEncoding *) enc
{
    NSError *theErr = nil;
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    // Load document data using NSStrings house methods
    // For huge files, maybe guess file encoding using `file --brief --mime` and use NSFileHandle? Not for now...
    NSString *fileString = [NSString stringWithContentsOfURL:url usedEncoding:enc error:&theErr];

    // We could not open the file, probably unknown encoding; try ISO-8859-1
    if (!fileString) {
        NSArray *encodings = @[
                               @(NSShiftJISStringEncoding),
                               @(NSJapaneseEUCStringEncoding),
                               @(NSISO2022JPStringEncoding),
                               @(NSUTF8StringEncoding),
                               ];

        
        __block NSString *string;
        __block NSStringEncoding tmp_enc;
        
        [encodings enumerateObjectsUsingBlock:^(NSNumber *encoding, NSUInteger idx, BOOL *stop) {
            string = [[NSString alloc] initWithData:data encoding:encoding.unsignedIntegerValue];
            
            // Return the first encoding that works :)
            if (string != nil) {
                tmp_enc = encoding.unsignedIntegerValue;
                *stop = YES;
            }
        }];
        *enc = tmp_enc;
        fileString = string;
        
        if (!fileString) {
            *enc = NSISOLatin1StringEncoding;
            fileString = [NSString stringWithContentsOfURL:url encoding:*enc error:&theErr];
        
            // Still no success, give up
            if (!fileString) {
                if (nil != theErr) {
                    NSLog(@"Error opening the file: %@", theErr);
                }
            
                return nil;
            }
        }
    }
    return fileString;
}

+ (NSString *) htmlReadableEncoding:(NSStringEncoding) stringEncoding;
{
    return (NSString *) CFStringConvertEncodingToIANACharSetName(
            CFStringConvertNSStringEncodingToEncoding(stringEncoding));
}


+ (NSString *) humanReadableEncoding:(NSStringEncoding) stringEncoding;
{
    switch (stringEncoding) {
        case NSUTF8StringEncoding:
            return @"UTF-8";
        case NSASCIIStringEncoding:
            return @"ASCII-text";
        case NSShiftJISStringEncoding:
        case 0x80000A01:
            return @"Shift_JIS";
        case NSJapaneseEUCStringEncoding:
            return @"EUC-JP";
        case NSISO2022JPStringEncoding:
            return @"JIS";
        case NSUTF16StringEncoding:
            return @"UTF-16";
        case NSUTF32StringEncoding:
            return @"UTF-32";
    }
    return [NSString localizedNameOfStringEncoding:stringEncoding];
}


@end
