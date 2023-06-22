//
//  PictureGrid.swift
//  SearchPic
//
//  Created by Greg Deveaux on 21/06/2023.
//

import SwiftUI

struct PictureGrid: View {
    @EnvironmentObject var viewModel: HomeViewModel

    var screenSize: CGSize

    let gridItem = GridItem(.flexible(),spacing: 20)
    var columnsNumber: Int

    var pictures: [Picture]

    var body: some View {

        let columns: [GridItem] = [
            gridItem
        ]

        ScrollView {
            LazyVGrid(columns: columns, spacing: 15) {
                ForEach(pictures.enumerated().map({ $0}), id: \.element.id) { index, picture in
                    NavigationLink {
                        PictureDetailsView(picture: picture)
                    } label: {
                        AsyncImage(url: URL(string: picture.urls.largeSize)) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: screenSize.width, height: screenSize.height / 3, alignment: .center)
                                .cornerRadius(10)
                                .offset(y: 35)

                        } placeholder: {
                            ProgressView()
                                .frame(width: screenSize.width, height: screenSize.height / 3, alignment: .center)
                                .background(Color.backgroundSecondary)
                                .tint(Color.backgroundPrimary)
                                .cornerRadius(10)
                        }
                    }
                    .onAppear {
                        Task {
                            try await viewModel.getOtherPicturesPages(currentIndexPicture: index)
                        }
                    }
                }
            }
        }
        .mask(LinearGradient(gradient: Gradient(colors: [.clear,.black,.black,.black,.black,.black,.black,.black,.black,.black, .black, .clear]), startPoint: .top, endPoint: .bottom))
        .padding(.top, -25)
        .padding(.bottom, -10)
    }
}


struct PictureGrid_Previews: PreviewProvider {
    static var previews: some View {
        PictureGrid(screenSize: CGSize(width: 400, height: 800), columnsNumber: 1, pictures: Picture.examples)
            .environmentObject(HomeViewModel())
    }
}
