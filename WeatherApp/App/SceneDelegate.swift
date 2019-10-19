//
//  SceneDelegate.swift
//  WeatherApp
//
//  Created by Savonevich Constantine on 10/16/19.
//  Copyright © 2019 Savonevich Konstantin. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {

        guard let _ = (scene as? UIWindowScene) else { return }
    }
}

