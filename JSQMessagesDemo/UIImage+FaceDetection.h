#import <UIKit/UIKit.h>

@interface UIImage (FaceDetection)

- (NSArray *)facesWithAccuracy :(NSString *)detectorAccuracy;
- (NSDictionary *)largestFaceWithAccuracy :(NSString *)detectorAccuracy;
- (NSDictionary *)croppedAroundLargestFaceWithAccuracy :(NSString *)detectorAccuracy;

@end
