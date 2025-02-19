//
//  TabbarViewController.swift
//  prography-test
//
//  Created by 이명지 on 2/18/25.
//

import UIKit

final class TabbarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabbar()
        setupTabbarItems()
    }
    
    private func setupTabbar() {
        let customTabBar = CustomTabbar()
        setValue(customTabBar, forKey: "tabBar")
        
        let appearanceTabbar = UITabBarAppearance()
        appearanceTabbar.configureWithOpaqueBackground()
        appearanceTabbar.backgroundColor = .gray6
        appearanceTabbar.shadowColor = .clear
        
        // 탭바 텍스트 기본 색상
        appearanceTabbar.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.black
        ]
        // 탭바 텍스트 선택 색상
        appearanceTabbar.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor.highlightRed
        ]
        
        // 탭바 아이콘 색상
        appearanceTabbar.stackedLayoutAppearance.normal.iconColor = .black              // 기본 색상
        appearanceTabbar.stackedLayoutAppearance.selected.iconColor = .highlightRed     // 선택 색상
        
        tabBar.standardAppearance = appearanceTabbar
        tabBar.scrollEdgeAppearance = appearanceTabbar
    }
    
    private func setupTabbarItems() {
        let homeVC = HomeViewController()
        let homeNav = UINavigationController(rootViewController: homeVC)
        homeNav.tabBarItem = UITabBarItem(title: "HOME",
                                          image: UIImage(named: "house"),
                                          selectedImage: UIImage(named: "house"))
        
        let myVC = MyViewController()
        let myNav = UINavigationController(rootViewController: myVC)
        myNav.tabBarItem = UITabBarItem(title: "MY",
                                        image: UIImage(named: "Star"),
                                        selectedImage: UIImage(named: "Star"))
        
        self.viewControllers = [homeNav, myNav]
    }
}

class CustomTabbar: UITabBar {
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = 104
        return sizeThatFits
    }
}
