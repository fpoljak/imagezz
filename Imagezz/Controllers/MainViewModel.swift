//
//  MainViewModel.swift
//  Imagezz
//
//  Created by Frane Poljak on 25/01/2021.
//  Copyright © 2021 fpoljak. All rights reserved.
//

import Foundation

class MainViewModel {
    
    init() { }
    
    func loadImagesList(page: Int = 1) {
        ImageApiService.getImagesList(page: page) { [weak self] (response) in
            guard let this = self else {
                return
            }
            print(response ?? [])
        }
    }
}
