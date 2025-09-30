import AberrPackage
import Foundation

print("Aberr CLI")
var Aberr = AberrWrapper()
print("Aberr instance created.")
print("Please enter a filepath:")
if let filepath = readLine() {
  print("Filepath: \(filepath)")
} else {
  print("Invalid filepath input.")
}
