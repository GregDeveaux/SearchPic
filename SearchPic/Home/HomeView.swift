//
//  HomeView.swift
//  SearchPic
//
//  Created by Greg Deveaux on 17/06/2023.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.colorScheme) var colorScheme

    @StateObject var viewModel = HomeViewModel()
    @State private var logoSize: CGFloat = 50

    @State private var trackingFont: CGFloat = 1
    @State private var isValidateKeyword: Bool = false

    var body: some View {

        NavigationView {

            ZStack{
                Color.backgroundPrimary
                    .ignoresSafeArea()

                    VStack {
                        LogoSearchPic(size: logoSize,
                                      trackingFont: $trackingFont)
                        .padding(.top, 40)
                        .padding(.bottom, 5)
                        .animation(.easeInOut(duration: 2), value: isValidateKeyword)

                        HStack {
                            SearchBar(searchWord: viewModel.searchWord)
                                .environmentObject(viewModel)
                            ButtonNumberColumns()
                                .environmentObject(viewModel)
                        }
                        .padding()

                        PictureGrid(columns: viewModel.columns,
                                    pictures: viewModel.pictures)
                        .padding([.leading, .trailing])
                        .environmentObject(viewModel)
                    }
            }
            .onAppear{
                viewModel.numberOfColumns(1)
                Task {
                    if let searchWord = viewModel.randomSearchAtLaunchApp.randomElement() {
                        try await viewModel.searchPictures(with: searchWord)
                        viewModel.searchWord = searchWord
                        isValidateKeyword.toggle()
                    }
                }
                print("✅ HOME_VIEW/ON_APPEAR: that's first random pictures")
            }
        }
        .accentColor(colorScheme == .light ? .black : .fluo)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(HomeViewModel())
    }
}
