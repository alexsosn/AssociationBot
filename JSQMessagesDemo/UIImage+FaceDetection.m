#import "UIImage+FaceDetection.h"

@implementation UIImage (FaceDetection)

- (NSArray *)facesWithAccuracy :(NSString *)detectorAccuracy {
    CIImage *coreImageRepresentation = [[CIImage alloc] initWithImage:self];

    CIDetector* detector = [CIDetector detectorOfType:CIDetectorTypeFace context:nil options:@{CIDetectorAccuracy: detectorAccuracy, CIDetectorSmile: @YES}];

    NSArray *features = [detector featuresInImage:coreImageRepresentation];

    return features;
}

- (NSDictionary *)largestFaceWithAccuracy :(NSString *)detectorAccuracy {
    
    NSArray *faces = [self facesWithAccuracy:detectorAccuracy];
    
    float currentLargestWidth = 0;
    CIFaceFeature *largestFace;
    BOOL isSmiling = NO;
    for (CIFaceFeature *face in faces) {
        if (face.bounds.size.width > currentLargestWidth) {
            largestFace = face;
            currentLargestWidth = face.bounds.size.width;
            isSmiling = face.hasSmile;
        }
    }
    if (largestFace == nil) {
        return nil;
    }
        
    
    return @{@"face": largestFace,
             @"isSmiling": @(isSmiling)};
}

- (NSDictionary *)croppedAroundLargestFaceWithAccuracy :(NSString *)detectorAccuracy {
    
    NSDictionary *dict = [self largestFaceWithAccuracy:detectorAccuracy];
    if (dict == nil) {
        return nil;
    }
    
    CIFaceFeature *largestFace = dict[@"face"];
    
    NSNumber *isSmiling = dict[@"isSmiling"];
    
    CIImage *coreImage = [[CIImage alloc] initWithImage:self];
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *faceImage =
    [coreImage imageByCroppingToRect:largestFace.bounds];
    UIImage *croppedImage = [UIImage imageWithCGImage:[context createCGImage:faceImage
                                                                    fromRect:faceImage.extent]];

    return @{@"face":croppedImage, @"isSmiling": isSmiling};
}

@end