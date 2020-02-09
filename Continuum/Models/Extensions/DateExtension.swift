//
//  DateExtension.swift
//  Continuum
//
//  Created by Devin Singh on 2/5/20.
//  Copyright © 2020 Devin Singh. All rights reserved.
//

import Foundation

extension Date {
    func formatToString() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle  = .short
        formatter.timeStyle = .short
        
        return formatter.string(from: self)
    }
}
