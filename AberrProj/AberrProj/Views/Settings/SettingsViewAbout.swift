import SwiftUI

struct AboutView: View {
  @Environment(\.dismiss) private var dismiss

  var body: some View {
    NavigationView {
      VStack(spacing: 24) {
        Image(systemName: "camera.aperture")
          .font(
            .system(
              size:
                80
            )
          )
          .foregroundColor(
            .blue
          )

        VStack(spacing: 8) {
          Text("Aberr")
            .font(
              .largeTitle
            )
            .fontWeight(
              .bold
            )

          Text("/ˈāˌbər/")
            .font(
              .system(
                .subheadline,
                design:
                  .monospaced
              )
            )
            .foregroundColor(
              .secondary
            )
        }

        VStack(spacing: 16) {
          Text(
            "Aberr is an experimental iOS app that is attempting to accelerate the raw development process of image files on portable edge devices."
          )
          .multilineTextAlignment(
            .center
          )
          .padding(
            .horizontal
          )

          Text(
            "© \(String(Calendar.current.component(.year, from: Date()))) Philip Gerdes"
          )
          .font(.caption)
          .foregroundColor(
            .secondary
          )
        }

        Spacer()
      }
      .padding()
      .navigationTitle("About")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(
          placement:
            .navigationBarTrailing
        ) {
          Button("Done") {
            dismiss()
          }
        }
      }
    }
  }
}
