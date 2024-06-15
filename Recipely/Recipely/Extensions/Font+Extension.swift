// Font+Extension.swift

import UIKit

// MARK: - Добавление методов для вызова часто используемых шрифтов

extension UIFont {
    static var fontsMap: [String: UIFont] = [:]

    class func verdana(ofSize fontSize: CGFloat) -> UIFont {
        searchFont(name: "Verdana", fontSize: fontSize)
    }

    class func verdanaBold(ofSize fontSize: CGFloat) -> UIFont {
        searchFont(name: "Verdana-Bold", fontSize: fontSize)
    }

    private class func searchFont(name: String, fontSize: CGFloat) -> UIFont {
        let key = "\(name)\(fontSize)"
        if let font = fontsMap[key] {
            return font
        }
        let font = UIFont(name: name, size: fontSize) ?? UIFont()
        fontsMap[key] = font
        return font
    }
}
