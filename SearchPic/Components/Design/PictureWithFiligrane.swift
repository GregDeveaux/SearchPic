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
    @Binding var retrieveImage: Image

    var pictureUrl: String

    var body: some View {
        AsyncImage(url: URL(string: pictureUrl)) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width - 30, height: 500, alignment: .center)
                    .cornerRadius(10)
                    .overlay {
                        LogoSearchPic(size: 50, trackingFont: $trackingFont)
                            .scaleEffect(0.30)
                            .offset(x: 120, y: 220)
                            .blendMode(colorScheme == .light ? .colorBurn : .colorDodge)
                    }
                    .onAppear {
                        retrieveImage = image
                        print("✅ the image is save \(retrieveImage)")
                    }

            } else if phase.error != nil {

            } else {
                ProgressView()
                    .background(Color.backgroundSecondary)
                    .tint(Color.backgroundPrimary)
                    .cornerRadius(10)
            }
        }
    }
}

struct PictureFiligraneView_Previews: PreviewProvider {
    static var previews: some View {
        PictureWithFiligrane(retrieveImage: .constant(Image(systemName: "photo")), pictureUrl: Picture.examples[1].urls.largeSize)
    }
}
