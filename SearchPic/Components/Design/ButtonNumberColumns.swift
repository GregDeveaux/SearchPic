//
//  ButtonNumberColumns.swift
//  SearchPic
//
//  Created by Greg-Mini on 22/06/2023.
//

import SwiftUI

struct ButtonNumberColumns: View {
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var viewModel: HomeViewModel

    var body: some View {
        Menu {
            Button {
                viewModel.ChangeNumberOfColumns(1)
            } label: {
                Label("1 colonne", systemImage: "rectangle.fill")
                    .foregroundColor(colorScheme == . light ? .black : .fluo)
            }
            Button {
                viewModel.ChangeNumberOfColumns(2)
            } label: {
                Label("2 colonnes", systemImage: "rectangle.grid.2x2.fill")
                    .foregroundColor(colorScheme == . light ? .black : .fluo)
            }
            Button {
                viewModel.ChangeNumberOfColumns(3)
            } label: {
                Label("3 colonnes", systemImage: "rectangle.grid.3x2.fill")
                    .foregroundColor(colorScheme == . light ? .black : .fluo)
            }
        } label: {
            Image(systemName: "rectangle.grid.2x2.fill")
                .resizable()
                .frame(width: 25, height: 25)
                .foregroundColor(.backgroundPrimary)
                .frame(width: 50, height: 50)
                .background(colorScheme == .light ? .black : .fluo,
                            in: RoundedRectangle(cornerRadius: 15,
                                                 style: .circular))
                .padding(.leading, 10)
        }
    }
}

struct ButtonNumberColumns_Previews: PreviewProvider {
    static var previews: some View {
        ButtonNumberColumns()
    }
}
