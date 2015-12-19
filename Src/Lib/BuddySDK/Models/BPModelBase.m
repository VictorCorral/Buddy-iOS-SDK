#import "NSArray+BPSugar.h"
#import "JAGPropertyConverter+BPJSONConverter.h"
#import "BPModelBase.h"

@implementation BPModelBase

+(NSArray*) convertArrayOfDict:(NSArray*)dictArr toType:(Class)clazz
{
    NSArray *results = [dictArr bp_map:^id(id object)
    {
        id obj = [[clazz alloc] init];
        [[JAGPropertyConverter bp_converter] setPropertiesOf:obj fromDictionary:object];
        return obj;
    }];
    return results;
}

@end
