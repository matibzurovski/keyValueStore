//
//  Array+Helpers.swift
//  
//
//  Created by Matias Bzurovski on 07/09/2022.
//

import Foundation

extension Array where Element == String.SubSequence {
    /// Returns a String with the second element of the Array, if the array has two elements. Otherwise, returns nil.
    var secondIfLast: String? {
        guard count == 2 else {
            return nil
        }
        return String(self[1])
    }
}
