//
//  RxPanModalPickerTheme.swift
//  PanModal
//
//  Created by Meng Li on 2020/03/06.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

public enum RxPanModalPickerTheme {
    case dark
    case light
    case custom(Custom)
    
    public struct Custom {
        var backgroundColor: UIColor?
        var doneColor: UIColor?
        var titleColor: UIColor?
        var pickerSeperatorColor: UIColor?
        var pickerTitleAttributes: [NSAttributedString.Key: Any]
        var blurEffect: UIBlurEffect
        var blurAlpha: CGFloat
    }
}

extension RxPanModalPickerTheme {
    
    var backgroundColor: UIColor? {
        switch self {
        case .dark:
            return .clear
        case .light:
            return .clear //IColor(hexa: 0xffffff22)
        case .custom(let custom):
            return custom.backgroundColor
        }
    }
    
    var doneColor: UIColor? {
        switch self {
        case .dark:
            return UIColor(hex: 0x0091d4)
        case .light:
            return UIColor(hex: 0x367bf7)
        case .custom(let custom):
            return custom.doneColor
        }
    }
    
    var titleColor: UIColor? {
        switch self {
        case .dark:
            return .white
        case .light:
            return .darkText
        case .custom(let custom):
            return custom.titleColor
        }
    }
    
    var pickerSeperatorColor: UIColor? {
        switch self {
        case .dark:
            return UIColor(hex: 0xfcfcfc)
        case .light:
            return UIColor(hex: 0xa2a8af)
        case .custom(let custom):
            return custom.pickerSeperatorColor
        }
    }
    
    var pickerTitleAttributes: [NSAttributedString.Key: Any] {
        switch self {
        case .dark:
            return [
                .foregroundColor: UIColor.white
            ]
        case .light:
            return [
                .foregroundColor: UIColor.darkText
            ]
        case .custom(let custom):
            return custom.pickerTitleAttributes
        }
    }
    
    var blurEffect: UIBlurEffect {
        switch self {
        case .dark:
            return UIBlurEffect(style: .dark)
        case .light:
            return UIBlurEffect(style: .extraLight)
        case .custom(let custom):
            return custom.blurEffect
        }
    }
    
    var blurAlpha: CGFloat {
        switch self {
        case .dark, .light:
            return 0.95
        case .custom(let custom):
            return custom.blurAlpha
        }
    }
    
}
