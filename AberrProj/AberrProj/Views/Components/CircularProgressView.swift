import SwiftUI

struct CircularProgressView: View {
  let progress: Double

  var body: some View {
    ZStack {
      Circle()
        .stroke(
          Color.white.opacity(0.4),
          lineWidth: 4
        )
        
      Circle()
        .trim(from: 0, to: progress)
        .stroke(
          Color.white,
          style: StrokeStyle(
            lineWidth: 4,
            lineCap: .round
          )
        )
        .rotationEffect(.degrees(-90))
    }
  }
}

#Preview {
  ZStack {
    Color.black
    CircularProgressView(progress: 0.75)
      .frame(width: 100, height: 100)
  }
}
