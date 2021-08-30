//
//  FeatureCell.swift
//  POCsWidgetsExtension
//
//  Created by Lucas Alves de Oliveira on 29/08/21.
//

import SwiftUI

struct FeatureCellModel: Identifiable {
    var id: Int
    let title: String
    let iconName: String
    let url: String
}

struct FeatureCell: View {
    
    let model: FeatureCellModel

    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .foregroundColor(.white)
                    .cornerRadius(5)
                    .frame(width: 50, height: 50)
                Image(uiImage: .init(named: model.iconName)!)
                    .frame(width: 25, height: 25)
            }
            Text(model.title)
                .font(.system(size: 10))
                .fontWeight(.semibold)
                .foregroundColor(.textColor)
        }.widgetURL(.init(string: model.url))
    }
}
