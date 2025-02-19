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
    }
    
    private func setupTabbar() {
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
    }
}
