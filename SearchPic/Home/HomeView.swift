//
//  HomeView.swift
//  SearchPic
//
//  Created by Greg Deveaux on 17/06/2023.
//

import SwiftUI

struct HomeView: View {

    @StateObject var viewModel = HomeViewModel()
    @State var logoSize: CGFloat = 50

    let columns: [GridItem] = [
//        GridItem(.flexible(),
//                 spacing: 20),
//        GridItem(.flexible(),
//                 spacing: 20),
        GridItem(.flexible(),
                 spacing: 20)
    ]

    var body: some View {
         // allow to know the screenSize of the iPhone
        GeometryReader { proxy in

            let screenSize = proxy.size

            NavigationView {
                ZStack{
                    Color.backgroundPrimary
                        .ignoresSafeArea()

                    VStack {
                        LogoSearchPic(size: logoSize, trackingFont: 1)
                        HStack {
                            SearchBar()
                                .environmentObject(viewModel)
                            Button {
                                print("change")
                            } label: {
                                Image(systemName: "rectangle.grid.2x2.fill")
                                    .resizable()
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(.black)
                            }

                        }
                        Text(viewModel.searchText)

                        ScrollView {
                            LazyVGrid(columns: columns, spacing: 15) {
                                ForEach(Picture.examples.enumerated().map({ $0}), id: \.element.id) { index, picture in
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
                                }
                            }
                        }
                        .mask(LinearGradient(gradient: Gradient(colors: [.clear,.black,.black,.black,.black,.black,.black,.black,.black,.black, .black, .clear]), startPoint: .top, endPoint: .bottom))
                        .padding(.top, -25)
                        .padding(.bottom, -10)
                    }
                    .padding()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(HomeViewModel())
    }
}


