#import "NSString+SortExtension.h"

@implementation NSString (SortExtension)

//Thanks!
//http://stackoverflow.com/questions/13359410/sort-characters-in-nsstring-into-alphabetical-order
- (NSString *)sorted
{
    // init
    NSUInteger length = [self length];
    unichar *chars = (unichar *)malloc(sizeof(unichar) * length);
    
    // extract
    [self getCharacters:chars range:NSMakeRange(0, length)];
    
    // sort (for western alphabets only)
    qsort_b(chars, length, sizeof(unichar), ^(const void *l, const void *r) {
        unichar left = *(unichar *)l;
        unichar right = *(unichar *)r;
        return (int)(left - right);
    });
    
    // recreate
    NSString *sorted = [NSString stringWithCharacters:chars length:length];
    
    // clean-up
    free(chars);
    
    return sorted;
}

@end
