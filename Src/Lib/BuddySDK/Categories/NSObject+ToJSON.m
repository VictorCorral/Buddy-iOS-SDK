//
//  NSObject+ToJSON.m
//  BuddySDK
//
//  Created by Erik Kerber on 2/6/14.
//
//

#import "NSObject+ToJSON.h"
#import "BPEnumMapping.h"
#import "NSDate+JSON.h"
#import <objc/runtime.h>

@implementation NSObject (ToJSON)

- (NSMutableDictionary *)bp_parametersFromProperties
{
    return  [self parametersFromPropertiesForClass:[self class]];
}

- (NSDictionary *)bp_parametersFromProperties:(NSArray *)keys
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];

    for (NSString *name in keys) {
        id val = [self valueForKey:name];
        
        if([[self class] conformsToProtocol:@protocol(BPEnumMapping)]
           && [[self class] mapForProperty:name]) {
            id map = [[self class] mapForProperty:name];
            val = map[val];
            if (!val) {
                continue;
            }
        }
        else if ([val isKindOfClass:[NSNumber class]]) {
            // Don't convert
        } else if ([val respondsToSelector:@selector(stringValue)]) {
            val = [val stringValue];
        } else if([[val class] isSubclassOfClass:[NSDate class]]){
            val = [val serializeDateToJson];
        }
        
        if (val) {
            parameters[name] = val;
        }
    }
    
    return parameters;
}

- (NSMutableDictionary *)parametersFromPropertiesForClass:(Class)class
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    @autoreleasepool {
        unsigned int numberOfProperties = 0;
        objc_property_t *propertyArray = class_copyPropertyList(class, &numberOfProperties);
        
        NSMutableArray *keys = [NSMutableArray array];
        
        for (NSUInteger i = 0; i < numberOfProperties; i++)
        {
            objc_property_t property = propertyArray[i];
            NSString *name = [[NSString alloc] initWithUTF8String:property_getName(property)];
            
            [keys addObject:name];
        }
        
        [parameters addEntriesFromDictionary:[self bp_parametersFromProperties:keys]];
        
        if (([class isSubclassOfClass:[BuddyObject class]] && class != [BuddyObject class]) ||
            ([class isSubclassOfClass:[BPObjectSearch class]] && class != [BPObjectSearch class])) {
            [parameters addEntriesFromDictionary:[self parametersFromPropertiesForClass:[class superclass]]];
        }
        
        free(propertyArray);
    }
    return parameters;
}

- (NSMutableDictionary *)bp_parametersFromProtocol:(Protocol *)protocol
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    @autoreleasepool {
        unsigned int numberOfProtocols = 0;
        unsigned int numberOfProperties = 0;
        Protocol * __unsafe_unretained *protocolArray = protocol_copyProtocolList(protocol, &numberOfProtocols);
        objc_property_t *propertyArray = protocol_copyPropertyList(protocol, &numberOfProperties);
        for (NSUInteger i = 0; i < numberOfProperties; i++)
        {
            objc_property_t property = propertyArray[i];
            NSString *name = [[NSString alloc] initWithUTF8String:property_getName(property)];
            id val = [self valueForKey:name];
            
            if([[self class] conformsToProtocol:@protocol(BPEnumMapping)]
               && [[self class] mapForProperty:name]) {
                id map = [[self class] mapForProperty:name];
                val = map[val];
                if (!val) {
                    continue;
                }
            }
            else if ([val isKindOfClass:[NSNumber class]]) {
                // Don't convert
            } else if ([val respondsToSelector:@selector(stringValue)]) {
                val = [val stringValue];
            } else if([[val class] isSubclassOfClass:[NSDate class]]){
                val = [val serializeDateToJson];
            }
            
            if (val) {
                parameters[name] = val;
            }
        }
        
        // Recurse derived protocols.
        for (NSInteger i = 0; i < numberOfProtocols; i++) {
            [parameters addEntriesFromDictionary:[self bp_parametersFromProtocol:protocolArray[i]]];
        }
        
        free(propertyArray);
    }
    return parameters;
}


@end
