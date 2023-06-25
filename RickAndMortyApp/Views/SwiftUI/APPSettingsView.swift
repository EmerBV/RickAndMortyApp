//
//  APPSettingsView.swift
//  RickAndMortyApp
//
//  Created by Emerson Balahan Varona on 23/6/23.
//

import SwiftUI

struct APPSettingsView: View {
    let viewModel: APPSettingsViewViewModel

    init(viewModel: APPSettingsViewViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        List(viewModel.cellViewModels) { viewModel in
            HStack {
                if let image = viewModel.image {
                    Image(uiImage: image)
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(Color.white)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                        .foregroundColor(Color.red)
                        .padding(8)
                        .background(Color(viewModel.iconContainerColor))
                        .cornerRadius(6)
                        .colorScheme(.light)
                }
                Text(viewModel.title)
                    .padding(.leading, 10)

                Spacer()
            }
            .padding(.bottom, 3)
            .onTapGesture {
                viewModel.onTapHandler(viewModel.type)
            }
        }
    }
}

struct APPSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        APPSettingsView(viewModel: .init(cellViewModels: APPSettingsOption.allCases.compactMap({
            return APPSettingsCellViewModel(type: $0) { option in

            }
        })))
    }
}
