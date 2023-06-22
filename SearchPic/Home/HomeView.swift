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

    var body: some View {
         // allows to know the screenSize of the iPhone
        GeometryReader { proxy in

            let screenSize = proxy.size

            NavigationView {
                ZStack{
                    Color.backgroundPrimary
                        .ignoresSafeArea()

                    VStack {
                        LogoSearchPic(size: logoSize, trackingFont: 1)

                        HStack {
                            SearchBar(searchWord: viewModel.searchWord)
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
                        Text(viewModel.searchWord)

                        PictureGrid(screenSize: screenSize, columnsNumber: 1, pictures: viewModel.pictures)
                            .environmentObject(viewModel)
                    }
                    .padding()
                }
            }
            .onAppear{
                Task {
                    if let searchWord = viewModel.randomSearchAtLaunchApp.randomElement() {
                        try await viewModel.searchPictures(with: searchWord)
                        viewModel.searchWord = searchWord
                    }
                }
                print("✅ HOME_VIEW/ON_APPEAR: that's first random pictures")
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
