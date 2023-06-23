//
//  PictureWithFiligrane.swift
//  SearchPic
//
//  Created by Greg Deveaux on 20/06/2023.
//

import SwiftUI

struct PictureWithFiligrane: View {
    @Environment(\.colorScheme) private var colorScheme

    @State private var trackingFont: CGFloat = 1

    var pictureUrl: String

    var body: some View {
        AsyncImage(url: URL(string: pictureUrl)) { image in
            image
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width - 30, height: 500, alignment: .center)
                .cornerRadius(10)

        } placeholder: {
            ProgressView()
                .background(Color.backgroundSecondary)
                .tint(Color.backgroundPrimary)
                .cornerRadius(10)
        }
        .overlay(alignment: .bottom) {
            LogoSearchPic(size: 50, trackingFont: $trackingFont)
                .scaleEffect(0.30)
                .offset(x: 120, y: 0)
                .blendMode(colorScheme == .light ? .colorBurn : .colorDodge)
        }
    }
}

struct PictureFiligraneView_Previews: PreviewProvider {
    static var previews: some View {
        PictureWithFiligrane(pictureUrl: Picture.examples[1].urls.largeSize)
    }
}
