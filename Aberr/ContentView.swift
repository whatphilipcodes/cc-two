//
//  ContentView.swift
//  Aberr
//
//  Created by Philip Gerdes on 16.08.25.
//

import SwiftUI

struct ContentView: View {
    @State private var firstNumber: String = ""
    @State private var secondNumber: String = ""
    @State private var result: Int = 0
    
    var body: some View {
        VStack(spacing: 20) {
            Text("C++ Math Calculator")
                .font(.title)
                .padding()
            
            VStack(spacing: 15) {
                TextField("First Number", text: $firstNumber)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                
                Text("+")
                    .font(.title2)
                
                TextField("Second Number", text: $secondNumber)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                
                Button("Calculate") {
                    calculateSum()
                }
                .buttonStyle(.borderedProminent)
                
                Text("Result: \(result)")
                    .font(.title2)
                    .foregroundColor(.blue)
            }
            .padding()
            
            Spacer()
        }
        .padding()
    }
    
    private func calculateSum() {
        guard let first = Int(firstNumber),
              let second = Int(secondNumber) else {
            result = 0
            return
        }
        
        // Call the C++ function directly using native Swift C++ interop
        result = Int(Math.add(Int32(first), Int32(second)))
    }
}

#Preview {
    ContentView()
}
