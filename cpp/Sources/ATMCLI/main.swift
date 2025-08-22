import ATMPackage
import Foundation

print("🏧 ATM CLI 🏧")
var atm = ATMWrapper(initialBalance: 1000)
print("Current balance: \(atm.getBalance())")
print("Enter amount to withdraw:", terminator: " ")
if let input = readLine(), let amount: Int32 = Int32(input) {
    if atm.withdraw(amount: amount) {
        print("✅ Withdrawn \(amount). New balance: \(atm.getBalance())")
    } else {
        print("❌ Insufficient funds.")
    }
} else {
    print("Invalid input.")
}
