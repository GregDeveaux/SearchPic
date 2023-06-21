//
//  PictureDetailsView.swift
//  SearchPic
//
//  Created by Greg Deveaux on 20/06/2023.
//

import SwiftUI
import UIKit

struct PictureDetailsView: View {
    @Environment(\.colorScheme) private var colorScheme

    var picture: Picture

    var body: some View {
        GeometryReader { proxy in

            let screenSize = proxy.size
            let pictureWithFiligrane = PictureWithFiligrane(screenSize: screenSize, pictureUrl: picture.urls.largeSize)

            VStack {
                Text(picture.description ?? "")
                    .font(.system(size: 15, weight: .medium))
                    .padding([.trailing, .leading], 35)

                pictureWithFiligrane

                HStack(spacing: 30) {
                    Button {
                            // allow to reate a snapshot of image and save it
                        let renderer = ImageRenderer(content: pictureWithFiligrane)
                        let _ = DispatchQueue.main.async {
                            guard let image = renderer.uiImage else { return }
                            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                        }
                        print("✅ PICTURE_DETAILS_VIEW/SAVE_PICTURE: the image is saved")
                    }  label: {
                        Label("Enregistrer", systemImage: "photo")
                            .padding(10)
                    }

                        // allow to share the picture link into max size
                    ShareLink(item: picture.urls.download) {
                        Label("Partager", systemImage:  "square.and.arrow.up")
                            .padding(10)
                    }

                }
                .font(.system(size: 15, weight: .medium))
                .buttonStyle(.borderedProminent)
                .foregroundColor(.backgroundPrimary)
                .tint(colorScheme == .light ? Color.black : Color.fluo)
            }
            .background {
                Color.backgroundPrimary
                    .ignoresSafeArea()
            }
        }
    }
}

struct PictureDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        PictureDetailsView(picture: Picture.examples[1])
    }
}
