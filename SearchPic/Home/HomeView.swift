//
//  HomeView.swift
//  SearchPic
//
//  Created by Greg Deveaux on 17/06/2023.
//

import SwiftUI

struct HomeView: View {

    @State private var searchText = ""
    @State var viewModel = HomeViewModel()

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
            HStack(spacing: 0) {
                Color.backgroundPrimary
            }
            .ignoresSafeArea()

            VStack {
                LogoSearchPic() // 1
                SearchBar(searchText: $searchText) // 2
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(viewModel.picturesUrl, id: \.id) { picture in
                            AsyncImage(url: URL(string: picture.url)) { image in
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
    }
}

    // MARK: - 1. Logo
struct LogoSearchPic: View {
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        HStack(spacing: 20){
            Text
                .fontLogo(text: "SEARCH", rotationAxisY: -1)
            Text
                .fontLogo(text: "PIC", rotationAxisY: 1)
                .foregroundColor(.backgroundSecondary)
                .overlay {
                    Circle()
                        .stroke(Color.backgroundSecondary, lineWidth: colorScheme == .light ? 9 : 7)
                        .background(Circle().fill(Color.backgroundPrimary))
                        .frame(width: 50)
                        .offset(x: -1.5, y: -48)
                }
        }
        .offset(x: -15)
        .padding(.top, 25)
    }
}

    // MARK: - 2. SearchBar
struct SearchBar: View {
    @Environment(\.colorScheme) private var colorScheme

    @Binding var searchText: String

    var placeHolder = Text("Que cherches-tu comme photo ?").foregroundColor(.placeHolder)

    var body: some View {
        HStack{
            Image(systemName: "magnifyingglass")
                .padding(.leading, 20)
                .padding(.trailing, -5)
                .foregroundColor(.backgroundPrimary)
            TextField("\(placeHolder)", text: $searchText)
                .padding(10)
                .foregroundColor(.backgroundPrimary)
                .frame(height: 50)
                .overlay(alignment: .trailing) {
                    if !searchText.isEmpty {
                        Button {
                            self.searchText = ""
                        } label: {
                            Image(systemName: "multiply.circle.fill")
                                .foregroundColor(.backgroundPrimary)
                                .padding()
                        }
                    }
                }
        }
        .background(colorScheme == .light ? Color.black : Color.fluo)
        .cornerRadius(15)
        .padding([.leading,.trailing], 30)
    }
}
