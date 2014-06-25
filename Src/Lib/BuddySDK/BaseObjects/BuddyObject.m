//
//  BuddyObject.m
//  BuddySDK
//
//  Created by Erik Kerber on 9/11/13.
//
//

#import "BuddyObject.h"
#import "BuddyObject+Private.h"

#import "JAGPropertyConverter.h"
#import "BPRestProvider.h"
#import "BPClient.h"
#import "BPCoordinate.h"
#import "NSDate+JSON.h"
#import "BPEnumMapping.h"
#import <objc/runtime.h>

@interface BuddyObject()

@property (nonatomic, readwrite, assign) BOOL isDirty;
@property (nonatomic, strong) NSMutableArray *keyPaths;
@property (nonatomic, assign) BOOL deleted;
@property (strong, nonatomic) NSMutableArray *dirtyKeys;

@end


@implementation BuddyObject

@synthesize location = _location;
@synthesize created = _created;
@synthesize lastModified = _lastModified;
@synthesize readPermissions = _readPermissions;
@synthesize writePermissions = _writePermissions;
@synthesize tag = _tag;
@synthesize id = _id;

#pragma mark - Initializers

- (void)dealloc
{
    for(NSString *keypath in self.keyPaths)
    {
        [self removeObserver:self forKeyPath:keypath];
    }
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self registerProperties];
    }
    return self;
}


- (instancetype)initWithId:(NSString*)id
{
    return [self initWithId:id andClient:nil];
}


- (instancetype)initWithId:(NSString*)id andClient:(id<BPRestProvider>)client
{
    if (!id) {
        return nil;
    }
    
    self = [super init];
    
    if (self) {
        [self registerProperties];
        _id = id;
        self.client = client;
    }
    
    return self;
}

- (instancetype)initBuddyWithClient:(id<BPRestProvider>)client
{
    self = [super init];
    if(self)
    {
        self.client = client;
        [self registerProperties];
    }
    return self;
}

- (instancetype)initBuddyWithResponse:(id)response andClient:(id<BPRestProvider>)client
{
    if (!response) return nil;
    
    self = [super initWithClient:client];
    if(self)
    {
        [self registerProperties];
        [[JAGPropertyConverter bp_converter] setPropertiesOf:self fromDictionary:response];
    }
    return self;
}

- (instancetype)initForCreation
{
    self = [super init];
    if(self)
    {
        [self registerProperties];
    }
    return self;
}


- (void)registerProperties
{
    if(!self.keyPaths)
    {
        self.keyPaths = [NSMutableArray array];
    }
    
    [self registerProperty:@selector(location)];
    [self registerProperty:@selector(created)];
    [self registerProperty:@selector(lastModified)];
    [self registerProperty:@selector(readPermissions)];
    [self registerProperty:@selector(writePermissions)];
    [self registerProperty:@selector(tag)];
    [self registerProperty:@selector(id)];
}

+(NSString *)requestPath
{
    [NSException raise:@"requestPathNotSpecified" format:@"Class did not specify requestPath"];
    return nil;
}

-(void)registerProperty:(SEL)property
{
    NSString *propertyName = NSStringFromSelector(property);
    
    if([self.keyPaths indexOfObject:propertyName] != NSNotFound)
    {
        return;
    }
    
    [self.keyPaths addObject:propertyName];
    
    [self addObserver:self forKeyPath:propertyName options:NSKeyValueObservingOptionNew context:NULL];
}

-(NSDictionary *)buildUpdateDictionary
{
    return [self bp_parametersFromProperties:self.dirtyKeys];
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (!self.dirtyKeys) {
        self.dirtyKeys = [NSMutableArray array];
    }
    
    if ([self.dirtyKeys indexOfObject:keyPath] == NSNotFound) {
        [self.dirtyKeys addObject:keyPath];
    }
    
    if(change)
        self.isDirty = YES;
}

#pragma mark CRUD

+(void)createFromServerWithParameters:(NSDictionary *)parameters client:(id<BPRestProvider>)client callback:(BuddyObjectCallback)callback
{
    [client POST:[[self class] requestPath] parameters:parameters callback:^(id json, NSError *error) {
        
        if (error) {
            callback ? callback(nil, error) : nil;
            return;
        }
        
        BuddyObject *newObject = [[[self class] alloc] initBuddyWithResponse:json andClient:client];

        newObject.id = json[@"id"];
        
        [newObject refresh:^(NSError *error){
            callback ? callback(newObject, error) : nil;
        }];
    }];
}

- (void)savetoServerWithClient:(id<BPRestProvider>)client callback:(BuddyCompletionCallback)callback
{
    [self savetoServerWithSupplementaryParameters:nil client:client callback:callback];
}

- (void)savetoServerWithSupplementaryParameters:(NSDictionary *)extraParams client:(id<BPRestProvider>)client callback:(BuddyCompletionCallback)callback
{
    // Dictionary of property names/values
    NSDictionary *parameters = [self buildUpdateDictionary];
    parameters = [NSDictionary dictionaryByMerging:parameters with:extraParams];
    
    self.client = client;
    
    [self.client POST:[[self class] requestPath] parameters:parameters callback:^(id json, NSError *error) {
        [[JAGPropertyConverter bp_converter] setPropertiesOf:self fromDictionary:json];
        if (!error) {
            self.isDirty = NO;
        }
        callback ? callback(error) : nil;
    }];
}

- (void)destroy
{
    [self destroy:nil];
}

-(void)destroy:(BuddyCompletionCallback)callback
{
    if (!self.id) {
        callback([NSError invalidObjectOperationError]);
        return;
    }
    
    NSString *resource = [NSString stringWithFormat:@"%@/%@",
                          [[self class] requestPath],
                          _id];
    
    [self.client DELETE:resource parameters:nil callback:^(id json, NSError *error) {
        if (!error) {
            self.deleted = YES;
        }
        callback ? callback(error) : nil;
    }];
}

-(void)refresh
{
    [self refresh:nil];
}

-(void)refresh:(BuddyCompletionCallback)callback
{
    if (!self.id) {
        callback([NSError invalidObjectOperationError]);
        return;
    }
    
    NSString *resource = [NSString stringWithFormat:@"%@/%@",
                          [[self class] requestPath],
                          self.id];
    
    [self.client GET:resource parameters:nil callback:^(id json, NSError *error) {
        [[JAGPropertyConverter bp_converter] setPropertiesOf:self fromDictionary:json];
        
        if (!error) {
            self.isDirty = NO;
        }
        
        callback ? callback(error) : nil;
    }];
}

- (void)save:(BuddyCompletionCallback)callback
{
    if (!self.id) {
        callback([NSError invalidObjectOperationError]);
        return;
    }
    
    NSString *resource = [NSString stringWithFormat:@"%@/%@",
                          [[self class] requestPath],
                          self.id];
    
    // Dictionary of property names/values
    NSDictionary *parameters = [self buildUpdateDictionary];

    [self.client PATCH:resource parameters:parameters callback:^(id json, NSError *error) {
        if (!error) {
            self.isDirty = NO;
        }
        callback ? callback(error) : nil;
    }];
}

#pragma mark - Metadata

static NSString *metadataRoute = @"metadata";
- (NSString *) metadataPath:(NSString *)key
{
    if(key==nil)
    {
        return [NSString stringWithFormat:@"%@/%@",metadataRoute, self.id];
    }
    return [NSString stringWithFormat:@"%@/%@/%@",metadataRoute, self.id, key];
}

@end

@interface BPObjectSearch()

@property (strong, nonatomic) NSMutableArray *dirtyKeys;

@end

@implementation BPObjectSearch

@synthesize location, created, lastModified, readPermissions, writePermissions, tag, id;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.dirtyKeys = [NSMutableArray array];
        NSArray *keysForSearchClass = [self propertiesForClass:[self class]];
        for (NSString *key in keysForSearchClass) {
            [self addObserver:self forKeyPath:key options:NSKeyValueObservingOptionNew context:nil];
        }
    }
    return self;
}

- (void)dealloc
{
    NSArray *keysForSearchClass = [self propertiesForClass:[self class]];
    for(NSString *keypath in keysForSearchClass)
    {
        [self removeObserver:self forKeyPath:keypath];
    }
}

- (NSArray *)propertiesForClass:(Class)class
{
    NSMutableArray *array = [NSMutableArray array];
    
    unsigned int count;
    objc_property_t *props = class_copyPropertyList(class, &count);
    
    for (int i = 0; i < count; ++i){
        NSString *propName = [NSString stringWithUTF8String:property_getName(props[i])];
        [array addObject:propName];
    }
    
    if (([class isSubclassOfClass:[BuddyObject class]] && class != [BuddyObject class]) ||
        ([class isSubclassOfClass:[BPObjectSearch class]] && class != [BPObjectSearch class])) {
        [array addObjectsFromArray:[self propertiesForClass:[class superclass]]];
    }
    
    free(props);
    
    return array;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self.dirtyKeys addObject:keyPath];
}

+(NSString*)pagingTokenFromPageSize:(unsigned long)pageSize
{
    return [NSString stringWithFormat:@"%lu;0",pageSize];
}

+(NSString*)pagingTokenFromPageSize:(unsigned long)pageSize withSkip:(unsigned long)skipCount
{
    return [NSString stringWithFormat:@"%lu;%lu",pageSize,skipCount];
}

- (NSDictionary *)parametersFromDirtyProperties
{
    NSDictionary *parameters = [self bp_parametersFromProperties];
    NSMutableDictionary *dirtyParameters = [NSMutableDictionary dictionary];
    
    for (id key in parameters) {
        if ([self.dirtyKeys indexOfObject:key] != NSNotFound) {
            [dirtyParameters setObject:parameters[key] forKey:key];
        }
    }
    
    return dirtyParameters;
}
@end
