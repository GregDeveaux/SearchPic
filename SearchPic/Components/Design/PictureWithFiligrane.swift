//
//  PictureWithFiligrane.swift
//  SearchPic
//
//  Created by Greg Deveaux on 20/06/2023.
//

import SwiftUI

struct PictureWithFiligrane: View {
    @Environment(\.colorScheme) private var colorScheme

    var screenSize: CGSize
    var pictureUrl: String

    var body: some View {
        AsyncImage(url: URL(string: pictureUrl)) { image in
            image
                .resizable()
                .scaledToFill()
                .frame(width: screenSize.width / 1.2, height: screenSize.height / 1.2)
                .cornerRadius(10)
                .position(x: screenSize.width / 2, y: screenSize.height / 2)

        } placeholder: {
            ProgressView()
                .frame(width: screenSize.width / 1.2, height: screenSize.height / 1.2)
                .background(Color.backgroundSecondary)
                .tint(Color.backgroundPrimary)
                .cornerRadius(10)
                .position(x: screenSize.width / 2, y: screenSize.height / 2)


        }
        .overlay {
            LogoSearchPic(size: 60, trackingFont: 1)
                .scaleEffect(0.3)
                .offset(x: screenSize.width * 0.25, y: screenSize.height * 0.38)
                .blendMode(colorScheme == .light ? .colorBurn : .colorDodge)
        }
    }
}

struct PictureFiligraneView_Previews: PreviewProvider {
    static var previews: some View {
        PictureWithFiligrane(screenSize: CGSize(width: 415, height: 800), pictureUrl: Picture.examples[1].urls.largeSize)
    }
}
