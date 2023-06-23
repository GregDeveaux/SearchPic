//
//  PictureGrid.swift
//  SearchPic
//
//  Created by Greg Deveaux on 21/06/2023.
//

import SwiftUI

struct PictureGrid: View {
    @EnvironmentObject var viewModel: HomeViewModel
    
    var columns: [GridItem]
    
    var pictures: [Picture]
    
    var body: some View {
        
        Group {

                // allows to know the screenSize of the iPhone
            GeometryReader { screen in

                let screenSize = screen.size

                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(pictures.enumerated().map({ $0}), id: \.element.id) { index, picture in
                            NavigationLink {
                                PictureDetailsView(picture: picture)
                            } label: {
                                AsyncImage(url: URL(string: picture.urls.largeSize)) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        /// the CGFloat(columns.count) allows to generate the good image size by columns number
                                        .frame(width: screenSize.width / CGFloat(columns.count),
                                               height: screenSize.height / (CGFloat(columns.count) * 2),
                                               alignment: .center)
                                        .cornerRadius(10)
                                        .offset(y: 35)
                                        .padding([.leading, .trailing], 20)


                                } placeholder: {
                                    ProgressView()
                                        .frame(width: screenSize.width / CGFloat(columns.count),
                                               height: screenSize.height / (CGFloat(columns.count) * 2),
                                               alignment: .center)
                                        .background(Color.backgroundSecondary)
                                        .tint(Color.backgroundPrimary)
                                        .cornerRadius(10)
                                }
                            }
                            .onAppear {
                                Task {
                                    try await viewModel.getOtherPicturesPages(currentIndexPictureDisplayed: index)
                                }
                            }
                        }
                    }
                }
                .mask(LinearGradient(gradient: Gradient(colors: [.clear,.black,.black,.black,.black,.black,.black,.black,.black,.black, .black, .clear]),
                                     startPoint: .top,
                                     endPoint: .bottom))
                .padding(.top, -25)
                .padding(.bottom, -10)
            }
        }
    }
}


struct PictureGrid_Previews: PreviewProvider {

    static let gridItem = GridItem(.flexible(),spacing: 20)

    static var previews: some View {
        PictureGrid(columns: [gridItem, gridItem, gridItem],
                    pictures: Picture.examples)
            .environmentObject(HomeViewModel())
    }
}
