//
//  UIColor+Extension.swift
//  XMGTV
//
//  Created by X-Liang on 2017/4/6.
//  Copyright © 2017年 coderwhy. All rights reserved.
//

import UIKit

extension UIColor {
    // 创建对象时，有参数使用便利构造器。每餐是直接使用类方法
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat = 1.0) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1.0)
    }
    
    
    /// 通过十六进制颜色值生成color(这是一个可失败的便利构造器）
    ///
    /// - Parameter hex: 十六进制颜色值
    convenience init?(hex: String, alpha: CGFloat = 1.0) {
        // 1. 判断字符串的长度是否符合规范，不符合直接返回 nil
        guard hex.characters.count > 6 else {
            return nil
        }
        // 2. 将字符串转为大小
        var upperHex = hex.uppercased()
        // 3. 判断开头是 0x/#/##
        if upperHex.hasPrefix("0x") || upperHex.hasPrefix("##") {
            upperHex = (upperHex as NSString).substring(from: 2)
        } else {
            upperHex = (upperHex as NSString).substring(from: 1)
        }
        // 4. 分别取出RGB
        // ff 00 11
        // r  g  b
        var range = NSMakeRange(0, 2)
        let redHex = (upperHex as NSString).substring(with: range)
        range.location = 2
        let greenHex = (upperHex as NSString).substring(with: range)
        range.location = 4
        let blueHex = (upperHex as NSString).substring(with: range)
        
        // 5. 将十六进制字符转为10进制
        var red: UInt32 = 0, blue: UInt32 = 0, green: UInt32 = 0
        Scanner(string: redHex).scanHexInt32(&red)
        Scanner(string: greenHex).scanHexInt32(&green)
        Scanner(string: blueHex).scanHexInt32(&blue)

        self.init(r: CGFloat(red), g: CGFloat(green), b: CGFloat(blue))
    }
    
    class func randomColor() -> UIColor {
        return UIColor(r: CGFloat(arc4random_uniform(256)), g: CGFloat(arc4random_uniform(256)), b: CGFloat(arc4random_uniform(256)))
    }
    
    class func getRGBDelta(firstColor: UIColor, secondColor: UIColor) -> (CGFloat, CGFloat, CGFloat) {
        // 获得颜色的rgba值
        guard let fisrstRGB = firstColor.cgColor.components else {
            fatalError()
        }
        
        guard let secondColor = secondColor.cgColor.components else {
            fatalError()
        }
        return ((fisrstRGB[0] - secondColor[0])*255.0,
                (fisrstRGB[1] - secondColor[1])*255.0,
                (fisrstRGB[2] - secondColor[2])*255.0)
    }
    
    func getRGB() -> (CGFloat, CGFloat, CGFloat) {
        // 获得颜色的rgba值
        guard let fisrstRGB = self.cgColor.components else {
            fatalError()
        }
        return (fisrstRGB[0] * 255.0, fisrstRGB[1] * 255.0, fisrstRGB[2] * 255.0)
    }
}
