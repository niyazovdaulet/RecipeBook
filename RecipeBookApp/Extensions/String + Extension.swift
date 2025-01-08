//
//  String + Extension.swift
//  RecipeBookApp
//
//  Created by Daulet on 26/10/2023.
//

import Foundation

extension String {
    var asUrl: URL? {
        return URL(string: self)
    }
}
