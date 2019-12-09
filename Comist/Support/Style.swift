//
//  Style.swift
//  Comist
//
//  Created by dewill on 28.11.2019.
//  Copyright © 2019 lilcappucc. All rights reserved.
//

import UIKit

class Style {
    
    enum Color {
        case voiletBackground, greenBackground, redBackground, redBorder, greenBorder
        
        func get() -> UIColor{
            switch self {
            case .voiletBackground: return #colorLiteral(red: 0.4901960784, green: 0.2941176471, blue: 1, alpha: 1)
            case .greenBackground: return #colorLiteral(red: 0.8509803922, green: 0.9254901961, blue: 0.862745098, alpha: 1)
            case .redBackground: return #colorLiteral(red: 0.9294117647, green: 0.8549019608, blue: 0.8549019608, alpha: 1)
            case .redBorder: return #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
            case . greenBorder: return #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
            }
        }
    }

    
    static var fontSizeMedium = 0
    static var fontSizeRegular = 0
    static var fontSizeLight = 0
    static var fontSizeBold = 0
    static var fontSizeTitle = 0
}
