//
//  ContentView.swift
//  AberrProj
//
//  Created by Philip Gerdes on 22.08.25.
//

import SwiftUI

struct ContentView: View {
    @State private var input = ""
    @ObservedObject var viewModel: AberrViewModel

    var body: some View {
        VStack(spacing: 20) {
            Text("🏧 Aberr Machine 🏧").font(.largeTitle)
            Text("Balance: \(viewModel.balance)").font(.title2)
            Text(viewModel.libRawVersion)
                .font(.footnote.monospaced())
                .padding(.horizontal)
            TextField("Amount", text: $input)
                .keyboardType(.numberPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            Button("Withdraw") {
                viewModel.withdraw(amount: input)
                input = ""
            }
            .buttonStyle(.borderedProminent)
            Spacer()
        }
        .padding()
    }
}

#Preview {
    ContentView(viewModel: AberrViewModel())
}
