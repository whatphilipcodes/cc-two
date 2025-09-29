import SwiftUI

enum EditControlType: String, CaseIterable, Identifiable {
  case exposure = "Exposure"
  case temperature = "Temperature"

  var id: String { self.rawValue }
}

struct EditControlsView: View {
  @Binding var exposure: Double
  @Binding var temperature: Double

  @State private var selectedControlType: EditControlType = .exposure

  private let defaultExposure = 0.0
  private let defaultTemperature = 6500.0

  private var sliderView: some View {
    Group {
      switch selectedControlType {
      case .exposure:
        Slider(value: $exposure, in: -2.0...2.0)
          .onTapGesture(count: 2) {
            exposure = defaultExposure
          }
      case .temperature:
        Slider(value: $temperature, in: 2000...10000)
          .onTapGesture(count: 2) {
            temperature = defaultTemperature
          }
      }
    }
  }

  private var valueLabel: String {
    switch selectedControlType {
    case .exposure:
      return String(format: "%.2f", exposure)
    case .temperature:
      return String(format: "%.0fK", temperature)
    }
  }

  var body: some View {
    VStack(spacing: 0) {
      // Tab selection
      Picker("Edit Control", selection: $selectedControlType) {
        ForEach(EditControlType.allCases) { type in
          Text(type.rawValue).tag(type)
        }
      }
      .pickerStyle(SegmentedPickerStyle())
      .padding(.horizontal)
      .padding(.bottom, 10)

      // Slider and value
      VStack {
        HStack {
          sliderView
          Text(valueLabel)
            .font(.system(.caption, design: .monospaced))
            .frame(width: 60, alignment: .trailing)
        }
        .padding()
      }
      .background(Color(.secondarySystemBackground))
      .cornerRadius(15)
      .padding(.horizontal)
    }
    .padding(.bottom)
  }
}

#Preview {
  EditControlsView(exposure: .constant(0.0), temperature: .constant(6500.0))
    .padding()
    .background(Color.black)
}
