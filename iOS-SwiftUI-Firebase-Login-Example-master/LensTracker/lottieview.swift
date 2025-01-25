import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    var animationName: String

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)

        // Load animation and check if it's nil
        guard let animation = LottieAnimation.named(animationName) else {
            print("Animation file not found: \(animationName)")
            return view
        }

        let animationView = LottieAnimationView(animation: animation)
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()

        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)

        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])

        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}
