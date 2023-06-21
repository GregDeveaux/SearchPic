//
//  LogoSearchPic.swift
//  SearchPic
//
//  Created by Greg-Mini on 19/06/2023.
//

import SwiftUI

struct LogoSearchPic: View {
    @Environment(\.colorScheme) private var colorScheme

    var size: CGFloat
        // modify tracking for animation
    var trackingFont: CGFloat

    var body: some View {
        HStack(spacing: 20){
            Text
                .fontLogo(text: "SEARCH", rotationAxisY: -1, size: size)
                .tracking(trackingFont)

            Text
                .fontLogo(text: "PIC", rotationAxisY: 1, size: size)
                .foregroundColor(.backgroundSecondary)
                .overlay {
                    Circle()
                        .stroke(Color.backgroundSecondary, lineWidth: colorScheme == .light ? 9 : 7)
                        .background(Circle().fill(Color.backgroundPrimary))
                        .frame(width: 50)
                        .offset(x: -1.5, y: -48)
                }
        }
        .offset(x: -15)
    }
}

struct LogoSearchPic_Previews: PreviewProvider {
    static var previews: some View {
        LogoSearchPic(size: 50, trackingFont: 10)
    }
}