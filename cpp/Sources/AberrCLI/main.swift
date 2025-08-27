import AberrPackage
import Foundation

print("🏧 Aberr CLI 🏧")
var Aberr = AberrWrapper(initialBalance: 1000)
print("Current balance: \(Aberr.getBalance())")
print("Enter amount to withdraw:", terminator: " ")
if let input = readLine(), let amount: Int32 = Int32(input) {
  if Aberr.withdraw(amount: amount) {
    print("✅ Withdrawn \(amount). New balance: \(Aberr.getBalance())")
  } else {
    print("❌ Insufficient funds.")
  }
} else {
  print("Invalid input.")
}
