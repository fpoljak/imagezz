//
//  ImageItem.swift
//  Imagezz
//
//  Created by Frane Poljak on 25/01/2021.
//  Copyright © 2021 fpoljak. All rights reserved.
//

import Foundation

struct ImageItem: Codable {
    let id: Int
    let author: String
    let width: Int
    let height: Int
    let url: String
    let downloadUrl: String
}
