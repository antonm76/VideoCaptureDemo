//
// Created by Myshkovskiy, Anton on 2019-01-30.
//

import Foundation
import UIKit

//============================================================================
extension UIAlertController
{
    //----------------------------------------------------------------------------
    public func show(animated: Bool)
    {
        var rootViewController = UIApplication.shared.keyWindow?.rootViewController

        if let tabBarController = rootViewController as? UITabBarController
        {
            rootViewController = tabBarController.selectedViewController
        }
        else if let navigationController = rootViewController as? UINavigationController
        {
            rootViewController = navigationController.viewControllers.first
        }

        rootViewController?.present(self, animated: animated)
    }
}