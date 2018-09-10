//
// MIT License
// Copyright (c) Gathering Hall Studios
//


import UIKit

extension AppDelegate {
    /// For fast manual testing of view controllers
    func presentTestController() {
        //presentTestController(vc: MonsterDetails(id: 1))
        //presentTestController(vc: WeaponDetails(id: 328194)) // Heavy Bowgun
        //presentTestController(vc: WeaponDetails(id: 65795)) // Great Sword
    }
    
    func presentTestController(vc: UIViewController) {
        vc.navigationItem.rightBarButtonItem =
            UIBarButtonItem(barButtonSystemItem: .done, target: self,
                            action: #selector(popTestController))
        let nc = UINavigationController(rootViewController: vc)
        window?.rootViewController?.present(nc, animated: false, completion: nil)
    }
    
    @objc func popTestController() {
        window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
}
