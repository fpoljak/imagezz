//
//  ImageItem.swift
//  Imagezz
//
//  Created by Frane Poljak on 25/01/2021.
//  Copyright © 2021 fpoljak. All rights reserved.
//

import Foundation

struct ImageItem: Codable, Hashable {
    let id: String
    let author: String
    let width: Int
    let height: Int
    let url: URL
    let downloadUrl: URL
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: ImageItem, rhs: ImageItem) -> Bool {
        return lhs.id == rhs.id
    }
}
