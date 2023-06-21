//
//  SearchPictureError.swift
//  SearchPic
//
//  Created by Greg Deveaux on 19/06/2023.
//

import Foundation

enum SearchPictureError: LocalizedError {
    case invalidUrl
    case invalidResponse
    case invalidData

    var errorDescription: String? {
        switch self {
            case .invalidUrl:
                return "🛑 HOME_VIEW_MODEL/GET_PICTURE: invalid URL"
            case .invalidResponse:
                return "🛑 HOME_VIEW_MODEL/GET_PICTURE: invalid Response"
            case .invalidData:
                return "🛑 HOME_VIEW_MODEL/GET_PICTURE: invalid Data"
        }
    }
}
