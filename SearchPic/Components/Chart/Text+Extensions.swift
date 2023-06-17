//
//  Text+Extensions.swift
//  SearchPic
//
//  Created by Greg Deveaux on 17/06/2023.
//

import Foundation
import SwiftUI

extension Text {

        // MARK: - font chart

    static func fontLogo(text: String, rotationAxisY: CGFloat) -> some View {
        Text(text)
            .font(.system(size: 60))
            .fontWeight(.black)
            .rotation3DEffect(Angle.degrees(35), axis: (x: 0, y: rotationAxisY, z: 0))
    }
}
