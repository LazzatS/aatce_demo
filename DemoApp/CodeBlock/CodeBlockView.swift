//
//  CodeBlockView.swift
//  DemoApp
//
//  Created by Lazzat Seiilova on 27.05.2026.
//

import SwiftUI

struct CodeBlockView: View {
    let code: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(code)
                .font(.system(.subheadline, design: .monospaced))
                .foregroundColor(.primaryText)
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.cardBg)
                .cornerRadius(8)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(minWidth: .zero, alignment: .leading)
        .padding(.vertical, 50)
        .background(Color.cardBg)
        .cornerRadius(10)
    }
}
