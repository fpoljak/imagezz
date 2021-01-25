//
//  ImageApiService.swift
//  Imagezz
//
//  Created by Frane Poljak on 25/01/2021.
//  Copyright © 2021 fpoljak. All rights reserved.
//

import Foundation
import Alamofire

public class ImageApiService {
    @discardableResult
    static func getImagesList(page: Int = 1, limit: Int = 25, completion: @escaping ([ImageItem]?) -> Void) -> DataRequest {
        let params = ["page": page, "limit": limit]
        return ApiService.genericRequest(method: .get, endpoint: "list", params: params, completion: completion)
    }
}
