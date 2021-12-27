//
//  AppNavigations.swift
//  ChanceUpon
//
//  Created by Dharmani Apps mini on 12/7/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import UIKit

class Navigation {
    open var pushCallBack = { (identifier:String,storyBoardName:String,class:UIViewController,storyboard:UIStoryboard,navigationVC:UINavigationController) -> () in
        let storyBoard = UIStoryboard(name: storyBoardName, bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: identifier)
        navigationVC.pushViewController(vc, animated: true)
           return
       }
}


extension UINavigationController {
    func getViewController<T: UIViewController>(of type: T.Type) -> UIViewController? {
        return self.viewControllers.first(where: { $0 is T })
    }

    func popToViewController<T: UIViewController>(of type: T.Type, animated: Bool) {
        guard let viewController = self.getViewController(of: type) else { return }
        self.popToViewController(viewController, animated: animated)
    }
}
