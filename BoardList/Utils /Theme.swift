//
//  Theme.swift
//  BoardList
//
//  Created by 이주상 on 2023/10/23.
//

import UIKit

struct Theme {

    static func navigationTintColor(color: UIColor) {
        UINavigationBar.appearance().tintColor = color
    }
 
    static func searchBarColors(background: UIColor, tintColor: UIColor) {
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = background
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = tintColor
    }
    
    static func changeSearchBarCancelButtonText(_ text: String) {
        UIBarButtonItem.appearance(whenContainedInInstancesOf:[UISearchBar.self]).title = text
    }
    
    static func removeNavigationBarBottomBorder() {
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
    }
    
    struct Font {
        static func regular(ofSize size: CGFloat) -> UIFont {
            return UIFont(name: "SpoqaHanSansNeo-Regular", size: size) ?? .systemFont(ofSize: size, weight: .regular)
        }
        
        static func thin(ofSize size: CGFloat) -> UIFont {
            return UIFont(name: "SpoqaHanSansNeo-Thin", size: size) ?? .systemFont(ofSize: size, weight: .thin)
        }
    }
    
    struct Color {
        static let bg = UIColor(hexString: "#F7F7F7")
        static let font = UIColor(hexString: "#757575")
        static let title = UIColor(hexString: "#241E17")
        static let subTitle = UIColor(hexString: "#9E9E9E")
        static let noticeLabel = UIColor(hexString: "#FFC744")
        static let replLabel = UIColor(hexString: "#47392B")
        static let placeholder = UIColor(hexString: "#C7C7C7")
        static let chevron = UIColor(hexString: "#424242")
    }
}
