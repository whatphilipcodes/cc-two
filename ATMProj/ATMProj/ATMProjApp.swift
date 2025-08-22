//
//  ATMProjApp.swift
//  ATMProj
//
//  Created by Philip Gerdes on 22.08.25.
//

import SwiftUI

@main
struct ATMProjApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: ATMViewModel())
        }
    }
}
