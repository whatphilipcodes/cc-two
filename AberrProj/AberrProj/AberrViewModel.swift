//
//  ATMViewModel.swift
//  ATMProj
//
//  Created by Philip Gerdes on 22.08.25.
//

import AberrPackage
import Foundation

class AberrViewModel: ObservableObject {
    @Published var balance: Int32
    private var aberr: AberrWrapper
    @Published var libRawVersion: String = ""

    init(aberr: AberrWrapper = AberrWrapper(initialBalance: 1000)) {
        self.aberr = aberr
        self.balance = aberr.getBalance()
        self.libRawVersion = aberr.libRawVersionInfo()
    }

    func withdraw(amount: String) {
        guard let value = Int32(amount), aberr.withdraw(amount: value) else { return }
        balance = aberr.getBalance()
    }
}
