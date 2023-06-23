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

        let pictureWithFiligrane = PictureWithFiligrane(pictureUrl: picture.urls.largeSize)

        ZStack {
            Color.backgroundPrimary
                .ignoresSafeArea()

            VStack {

                Spacer()

                pictureWithFiligrane
                    .padding()

                HStack {
                    RoundedRectangle(cornerRadius: 5)
                        .frame(width: 1, height: 100, alignment: .leading)
                        .padding(10)

                    VStack(alignment: .leading) {
                        Text(picture.description ?? "")
                            .font(.system(size: 15, weight: .medium))

                        Text("@\(picture.user.name ?? "")")
                            .font(.system(size: 13, weight: .regular))
                            .italic()
                            .padding(.top, 5)
                    }
                }

                Spacer()

                HStack(spacing: 20) {
                    Button {
                            // allows to reate a snapshot of image and save it
                        let renderer = ImageRenderer(content: pictureWithFiligrane)
                        let _ = DispatchQueue.main.async {
                            guard let image = renderer.uiImage else { return }
                            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                        }
                        print("✅ PICTURE_DETAILS_VIEW/SAVE_PICTURE: the image is saved")
                    }  label: {
                        Label("Enregistrer", systemImage: "photo")
                            .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                    }

                        // allows to share the picture link into max size
                    ShareLink(item: picture.urls.download) {
                        Label("Partager", systemImage:  "square.and.arrow.up")
                            .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                    }

                }
                .font(.system(size: 15, weight: .medium))
                .buttonStyle(.borderedProminent)
                .foregroundColor(.backgroundPrimary)
                .tint(colorScheme == .light ? Color.black : Color.fluo)
                .padding()
            }
        }
    }
}

struct PictureDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        PictureDetailsView(picture: Picture.examples[1])
    }
}
