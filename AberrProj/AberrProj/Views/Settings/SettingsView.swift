import SwiftUI

struct SettingsView: View {
  @ObservedObject var viewModel: AberrViewModel

  @AppStorage("exportFormat") private var exportFormat: String = "JPEG"
  @AppStorage("separateFile") private var separateFile: Bool = false

  @State private var showingAbout: Bool = false

  init(viewModel: AberrViewModel = AberrViewModel()) {
    self.viewModel = viewModel
  }

  var body: some View {
    NavigationStack {
      Form {
        Section("Export") {
          Picker(
            "Format",
            selection:
              $exportFormat
          ) {
            Text(
              "JPEG"
            )
            .tag(
              "JPEG"
            )
            Text(
              "PNG"
            )
            .tag(
              "PNG"
            )
            Text(
              "TIFF"
            )
            .tag(
              "TIFF"
            )
          }
          Toggle(
            "Render to Separate File",
            isOn:
              $separateFile
          )
        }

        Section("About") {
          Button(
            "About Aberr"
          ) {
            showingAbout =
              true
          }

          HStack {
            Text(
              "Version"
            )
            Spacer()
            Text(
              Bundle
                .main
                .infoDictionary?[
                  "CFBundleShortVersionString"
                ]
                as? String
                ?? "Unknown"
            )
            .foregroundColor(
              .secondary
            )
          }

          HStack {
            Text(
              "Build"
            )
            Spacer()
            Text(
              Bundle
                .main
                .infoDictionary?[
                  "CFBundleVersion"
                ]
                as? String
                ?? "Unknown"
            )
            .foregroundColor(
              .secondary
            )
          }
        }

        Section("Acknowledgements") {
          VStack(
            alignment:
              .leading,
            spacing:
              8
          ) {
            Text(
              "This project makes use of LibRaw for RAW file decoding."
            )
            .font(
              .body
            )
            Text(
              "LibRaw is licensed under the Common Development and Distribution License (CDDL)."
            )
            .font(
              .caption
            )
            .foregroundColor(
              .secondary
            )
            Text(
              "Copyright © 2008–\(String(Calendar.current.component(.year, from: Date()))) LibRaw LLC."
            )
            .font(
              .caption
            )
            .foregroundColor(
              .secondary
            )
          }
          .padding(
            .vertical,
            4)
        }
      }
      .navigationTitle("Settings")
      .navigationBarTitleDisplayMode(.large)
    }
    .sheet(isPresented: $showingAbout) {
      AboutView()
    }
  }
}

#Preview {
  SettingsView()
}
