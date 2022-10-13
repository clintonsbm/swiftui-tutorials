//
//  Helper.swift
//  project12
//
//  Created by Clinton de Sá Barreto Maciel on 13/10/22.
//

import Foundation

class Helper {
    static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths.first!
    }
}
