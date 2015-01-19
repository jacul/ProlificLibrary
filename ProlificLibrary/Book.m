//
//  Book.m
//  ProlificLibrary
//
//  Created by zxd on 15/1/15.
//
//

#import "Book.h"
#define nilOrJSONObjectForKey(JSON_, KEY_) [[JSON_ objectForKey:KEY_] isKindOfClass:[NSNull class]] ? nil : [JSON_ objectForKey:KEY_]

@implementation Book

-(NSString*)description{
    
    return [self URLEncodedString];
}

-(void)setBookInfoWithDict:(NSDictionary *)dict{
    self.author             = nilOrJSONObjectForKey(dict, @"author");
    self.categories         = nilOrJSONObjectForKey(dict, @"categories");
    self.lastCheckedOut     = nilOrJSONObjectForKey(dict, @"lastCheckedOut");
    self.lastCheckedOutBy   = nilOrJSONObjectForKey(dict, @"lastCheckedOutBy");
    self.publisher          = nilOrJSONObjectForKey(dict, @"publisher");
    self.title              = nilOrJSONObjectForKey(dict, @"title");
    self.url                = nilOrJSONObjectForKey(dict, @"url");
}

-(NSString *)URLEncodedString{
    NSMutableString* urlencodedstr = [NSMutableString new];
    if (self.title) {
        [urlencodedstr appendFormat:@"title=%@&", [self urlencode:self.title]];
    }
    if (self.author) {
        [urlencodedstr appendFormat:@"author=%@&", [self urlencode:self.author]];
    }
    if (self.categories) {
        [urlencodedstr appendFormat:@"categories=%@&", [self urlencode:self.categories]];
    }
    if (self.publisher) {
        [urlencodedstr appendFormat:@"publisher=%@&", [self urlencode:self.publisher]];    }
    if (self.lastCheckedOutBy) {
        [urlencodedstr appendFormat:@"lastCheckedOutBy=%@&", [self urlencode:self.lastCheckedOutBy]];
    }
    if (self.lastCheckedOut) {
        [urlencodedstr appendFormat:@"lastCheckedOut=%@&", [self urlencode:self.lastCheckedOut]];
    }
    if (urlencodedstr.length>0) {
        //Remove the last & symbol
        [urlencodedstr deleteCharactersInRange:NSMakeRange(urlencodedstr.length-1, 1)];
    }
    return [NSString stringWithString:urlencodedstr];
}

/**
 * Helper function to url encode a string
 */
- (NSString *)urlencode:(NSString*)str {
    if (str==nil) {
        return @"";
    }
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                    NULL,
                                                                                                    (CFStringRef)str,
                                                                                                    NULL,
                                                                                                    (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                                    kCFStringEncodingUTF8 ));
    return encodedString;
}
@end
