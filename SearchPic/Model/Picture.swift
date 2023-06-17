//
//  Picture.swift
//  SearchPic
//
//  Created by Greg Deveaux on 18/06/2023.
//

import Foundation

struct Picture: Identifiable, Equatable, Codable {

    var id: UUID = UUID()

    var url: String
}
