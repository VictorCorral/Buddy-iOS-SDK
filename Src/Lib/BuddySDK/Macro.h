//
//  Macro.h
//  BuddySDK
//
//  Created by Tyler Vann-Campbell on 5/21/15.
//
//

#ifndef BuddySDK_Macro_h
#define BuddySDK_Macro_h

#define BOXNIL(x) x ?: [NSNull null]
#define UNBOXNIL(x) [x isKindOfClass:[NSNull class]] ? nil : x

#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

#ifndef BP_NAMESPACE
#define BP_NAMESPACE "BP"
#endif
#endif
#ifndef BP
#ifdef BP_NAMESPACE
#define JRNS_CONCAT_TOKENS(a,b) a##_##b
#define JRNS_EVALUATE(a,b) JRNS_CONCAT_TOKENS(a,b)
#define BP(original_name) JRNS_EVALUATE(NS_NAMESPACE, original_name)
#else
#define BP(original_name) original_name
#endif
#endif