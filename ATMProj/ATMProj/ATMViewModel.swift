//
//  ATMViewModel.swift
//  ATMProj
//
//  Created by Philip Gerdes on 22.08.25.
//

import ATMPackage
import Foundation

class ATMViewModel: ObservableObject {
    @Published var balance: Int32
    private var atm: ATMWrapper
    @Published var libRawVersion: String = ""

    init(atm: ATMWrapper = ATMWrapper(initialBalance: 1000)) {
        self.atm = atm
        self.balance = atm.getBalance()
        self.libRawVersion = atm.libRawVersionInfo()
    }

    func withdraw(amount: String) {
        guard let value = Int32(amount), atm.withdraw(amount: value) else { return }
        balance = atm.getBalance()
    }
}
