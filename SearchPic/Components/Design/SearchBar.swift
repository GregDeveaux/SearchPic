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
    @State var searchWord: String

    var placeHolder = Text("Que cherches-tu ?").foregroundColor(.placeHolder)

    var body: some View {
        HStack{
            Image(systemName: "magnifyingglass")
                .padding(.leading, 20)
                .padding(.trailing, -5)
                .foregroundColor(.backgroundPrimary)

            TextField("\(placeHolder)", text: $searchWord)
                .font(.system(size: 15, weight: .medium))
                .padding(10)
                .foregroundColor(.backgroundPrimary)
                .frame(height: 50)
                .overlay(alignment: .trailing) {
                        // allows to reset the search word
                    if !searchWord.isEmpty {
                        Button {
                            searchWord = ""
                        } label: {
                            Image(systemName: "multiply.circle.fill")
                                .foregroundColor(.backgroundPrimary)
                                .padding()
                        }
                    }
                }
        }
            // modify action button on the keyboard
        .submitLabel(.search)
            // check the textfield is empty
        .submitScope(searchWord.isEmpty)
            // if check is validate, activate method
        .onSubmit {
            viewModel.searchWord = searchWord
            Task {
                    // reset the search pictures
                viewModel.resetSearchPicture()
                try await viewModel.searchPictures(with: searchWord)
            }
            print("✅ SEARCH_BAR/ON_SUBMIT: change the seach word \(searchWord) ")
        }
        .background(colorScheme == .light ? Color.black : Color.fluo)
        .cornerRadius(15)
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(searchWord: "plage")
            .environmentObject(HomeViewModel())
    }
}
