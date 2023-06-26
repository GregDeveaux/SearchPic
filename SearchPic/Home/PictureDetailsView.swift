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

    @State private var retrieveImage: Image = Image(systemName: "photo")
    @State private var isSaved: Bool = false

    var picture: Picture

    var body: some View {

        let pictureWithFiligrane = PictureWithFiligrane(retrieveImage: $retrieveImage, pictureUrl: picture.urls.largeSize)

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
                        if !isSaved {
                                // allows to reate a snapshot of image and save it
                            let renderer = ImageRenderer(content: retrieveImage)
                            let _ = DispatchQueue.main.async {
                                guard let image = renderer.uiImage else { return }
                                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                            }
                            isSaved.toggle()
                            print("✅ PICTURE_DETAILS_VIEW/SAVE_PICTURE: the image is saved")
                        }
                    }  label: {
                        Label(isSaved ? "" : "Enregistrer", systemImage: isSaved ?  "checkmark.circle.fill" : "photo")
                            .font(.system(size: isSaved ? 25 : 15))
                            .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                    }
                    .alert(isPresented: $isSaved) {
                        Alert(title: Text("Tu as bien enregistré la photo"))
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
