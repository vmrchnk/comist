//
//  ImageExtension.swift
//  Comist
//
//  Created by dewill on 23.11.2019.
//  Copyright © 2019 lilcappucc. All rights reserved.
//

import UIKit


extension UIImage {
    func image(alpha: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: .zero, blendMode: .normal, alpha: alpha)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
