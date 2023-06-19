//
//  SearchBar.swift
//  SearchPic
//
//  Created by Greg Deveaux on 19/06/2023.
//

import SwiftUI

struct SearchBar: View {
    @Environment(\.colorScheme) private var colorScheme

    @EnvironmentObject var viewModel: HomeViewModel

    var placeHolder = Text("Que cherches-tu comme photo ?").foregroundColor(.placeHolder)

    var body: some View {
        HStack{
            Image(systemName: "magnifyingglass")
                .padding(.leading, 20)
                .padding(.trailing, -5)
                .foregroundColor(.backgroundPrimary)
            TextField("\(placeHolder)", text: $viewModel.searchText)
                .padding(10)
                .foregroundColor(.backgroundPrimary)
                .frame(height: 50)
                .overlay(alignment: .trailing) {
                    if !viewModel.searchText.isEmpty {
                        Button {
                            viewModel.searchText = ""
                        } label: {
                            Image(systemName: "multiply.circle.fill")
                                .foregroundColor(.backgroundPrimary)
                                .padding()
                        }
                    }
                }
                // modify action button on the keyboard
                .submitLabel(.search)
                // check the textfield is not empty
                .submitScope(!viewModel.searchText.isEmpty)
                // if check is validate, activate method
                .onSubmit {
                    Task {
                        do {
                            let newPictures = try await viewModel.getPictures()
                            viewModel.pictures.append(newPictures)
                        }
                        catch {
                            print("🛑 HOME_VIEW_MODEL/GET_PICTURE: Error")
                        }
                    }
                }
        }
        .background(colorScheme == .light ? Color.black : Color.fluo)
        .cornerRadius(15)
        .padding([.leading,.trailing], 30)
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar()
            .environmentObject(HomeViewModel())
    }
}
