//
//  SceneDelegate.swift
//  BoardList
//
//  Created by 이주상 on 2023/10/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        window?.backgroundColor = .white
        window?.rootViewController = UINavigationController(rootViewController: BoardVC(boardId: 28502, boardName: "2023 사업 계획 게시판"))
        window?.makeKeyAndVisible()
    }

}

