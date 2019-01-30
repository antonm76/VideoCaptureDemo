//
// Created by Myshkovskiy, Anton on 2019-01-30.
//

import Foundation
import Photos

//============================================================================
public class Assets: NSObject
{
    //----------------------------------------------------------------------------
    @objc public static var tempFile: URL
    {
        let url = URL(fileURLWithPath: NSTemporaryDirectory())
        return url.appendingPathComponent(UUID().uuidString).appendingPathExtension("mov")
    }

    //----------------------------------------------------------------------------
    @objc(copyFileToPhotoLibraryFrom:)
    public static func copyFileToPhotoLibrary(from url: URL)
    {
        guard PHPhotoLibrary.authorizationStatus() == .authorized else
        {
            return
        }

        PHPhotoLibrary.shared().performChanges(
        {
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url)
        })
    }
}
