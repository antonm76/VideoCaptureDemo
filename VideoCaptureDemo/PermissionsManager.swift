//
// Created by Myshkovskiy, Anton on 2019-01-30.
//

import Foundation
import AVFoundation
import UIKit
import Photos

//============================================================================
private enum Alert
{
    case microphone
    case camera
    case photo

    //----------------------------------------------------------------------------
    private var title: String
    {
        switch (self)
        {
            case .microphone:
                return "Microphone disabled"
            case .camera:
                return "Camera disabled"
            case .photo:
                return "Photo library disabled"
        }
    }

    //----------------------------------------------------------------------------
    private var message: String
    {
        switch (self)
        {
            case .microphone:
                return "To enable sound recording with your video please go to the Settings app > Privacy > Microphone and enable access."
            case .camera:
                return "This app doesn't have permission to use the camera, please go to the Settings app > Privacy > Camera and enable access."
            case .photo:
                return "This app doesn't have permission to access photo library, please go to the Settings app > Privacy > Photo library and enable access."
        }
    }

    //----------------------------------------------------------------------------
    private var alert: UIAlertController
    {
        let alert = UIAlertController(title: self.title,
            message: self.message,
            preferredStyle: .actionSheet);

        let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil);
        let settingsAction = UIAlertAction(title: "Settings", style: .default)
        {
            _ in

            let settings = URL(string: UIApplication.openSettingsURLString)!
            if #available(iOS 10, *)
            {
                UIApplication.shared.open(settings, options: [:], completionHandler: nil)
            }
            else
            {
                UIApplication.shared.openURL(settings)
            }
        }

        alert.addAction(okayAction)
        alert.addAction(settingsAction)

        return alert
    }

    //----------------------------------------------------------------------------
    func show(animated: Bool)
    {
        DispatchQueue.main.async
        {
            self.alert.show(animated: animated)
        }
    }
}

//============================================================================
public class PermissionsManager: NSObject
{
    //----------------------------------------------------------------------------
    @objc public func checkMicrophonePermission(completion: ((Bool) -> Void)?)
    {
        AVCaptureDevice.requestAccess(for: .audio)
        {
            granted in

            if (!granted)
            {
                Alert.microphone.show(animated: true)
            }

            completion?(granted)
        }
    }

    //----------------------------------------------------------------------------
    @objc public func checkCameraPermission(completion: ((Bool) -> Void)?)
    {
        AVCaptureDevice.requestAccess(for: .video)
        {
            granted in

            if (!granted)
            {
                Alert.camera.show(animated: true)
            }

            completion?(granted)
        }
    }

    //----------------------------------------------------------------------------
    @objc public func checkPhotoLibraryPermission(completion: ((Bool) -> Void)?)
    {
        PHPhotoLibrary.requestAuthorization
        {
            status in

            let granted = status == .authorized
            if (!granted)
            {
                Alert.photo.show(animated: true)
            }

            completion?(granted)
        }
    }
}
