//
//  HomeView.swift
//  SearchPic
//
//  Created by Greg Deveaux on 17/06/2023.
//

import SwiftUI

struct HomeView: View {

    @EnvironmentObject var viewModel: HomeViewModel

    let columns: [GridItem] = [
//        GridItem(.flexible(),
//                 spacing: 20),
//        GridItem(.flexible(),
//                 spacing: 20),
        GridItem(.flexible(),
                 spacing: 20)
    ]

    var body: some View {
        
        ZStack{
            Color.backgroundPrimary
                .ignoresSafeArea()

            VStack {
                LogoSearchPic()
                SearchBar()
                    .environmentObject(HomeViewModel())

                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(viewModel.pictures, id: \.id) { picture in
                            AsyncImage(url: URL(string: "url")) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
//                                    .frame(width: 200, height: 150, alignment: .center)
                                    .cornerRadius(10)
                            } placeholder: {
                                ProgressView()
                                    .frame(width: 200, height: 185, alignment: .center)
                                    .background(Color.backgroundSecondary)
                                    .tint(Color.backgroundPrimary)
                                    .cornerRadius(10)
                            }
                        }
                    }
                    .offset(y: 140)
                }
                .mask(LinearGradient(gradient: Gradient(colors: [.clear,.clear,.black, .black,.black,.black,.black, .black, .black, .black, .clear]), startPoint: .top, endPoint: .bottom))
                .padding(.top, -90)

            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(HomeViewModel())
    }
}


