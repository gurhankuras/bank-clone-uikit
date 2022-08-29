//
//  NSBundle+Language.m
//  ziraat-clone
//
//  Created by Gürhan Kuraş on 8/26/22.
//

#import "NSBundle+Language.h"
#import <objc/runtime.h>

static const char kBundleKey = 0;

@interface BundleEx : NSBundle

@end

@implementation BundleEx

- (NSString *)localizedStringForKey:(NSString *)key value:(NSString *)value table:(NSString *)tableName
{
    NSBundle *bundle = objc_getAssociatedObject(self, &kBundleKey);
    if (bundle) {
        return [bundle localizedStringForKey:key value:value table:tableName];
    }
    else {
        return [super localizedStringForKey:key value:value table:tableName];
    }
}

@end

@implementation NSBundle (Language)

+ (void)setLanguage:(NSString *)language
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        object_setClass([NSBundle mainBundle],[BundleEx class]);
    });
    id value = language ? [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:language ofType:@"lproj"]] : nil;
    objc_setAssociatedObject([NSBundle mainBundle], &kBundleKey, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
