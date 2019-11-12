//
//  DateExtension.swift
//  Comist
//
//  Created by dewill on 11.11.2019.
//  Copyright © 2019 lilcappucc. All rights reserved.
//

import Foundation

extension Date {
    func toMillis() -> Int64! {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}
