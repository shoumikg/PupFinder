//
//  String+Extensions.swift
//  PupFinder
//
//  Created by Shoumik on 15/10/24.
//

import Foundation

extension String {
    func capitaliseFirstLetter() -> String {
        var arr = Array(self)
        arr[0] = Character(String(arr[0]).capitalized)
        return String(arr)
    }
}
