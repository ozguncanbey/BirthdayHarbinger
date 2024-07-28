import SwiftUI

struct CelebrationView: View {
    @State private var animateBalloons = false
    @State private var showEmoji = false
    
    var body: some View {
        ZStack {
            ForEach(0..<10, id: \.self) { index in
                BalloonView()
                    .offset(x: CGFloat.random(in: -.dWidth/2...UIScreen.main.bounds.width/2),
                            y: animateBalloons ? -.dHeight : .dHeight)
                    .animation(Animation.linear(duration: 6).delay(Double(index) * 0.5), value: animateBalloons)
            }
            VStack {
                Text("🎉")
                    .font(.system(size: 100))
                    .opacity(showEmoji ? 1 : 0)
                    .animation(Animation.easeInOut(duration: 5).repeatForever(autoreverses: true), value: showEmoji)
            }
            .padding()
        }
        .onAppear {
            animateBalloons = true
            showEmoji = true
            resetAnimation()
        }
    }
    
    private func resetAnimation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
            animateBalloons = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                animateBalloons = true
                resetAnimation()
            }
        }
    }
}

struct BalloonView: View {
    var body: some View {
        Circle()
            .frame(width: 50, height: 70)
            .foregroundColor(randomColor())
            .overlay(
                Circle()
                    .frame(width: 10, height: 10)
                    .foregroundColor(.white)
                    .offset(x: -10, y: -30)
            )
            .overlay(
                Rectangle()
                    .frame(width: 2, height: 20)
                    .foregroundColor(.gray)
                    .offset(y: 35)
            )
    }
    
    private func randomColor() -> Color {
        let colors: [Color] = [.red, .blue, .green, .orange, .purple]
        return colors.randomElement() ?? .red
    }
}

#Preview {
    CelebrationView()
}
