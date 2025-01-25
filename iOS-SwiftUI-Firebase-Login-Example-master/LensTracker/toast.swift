//import SwiftUI
//
//struct ToastModifier: ViewModifier {
//    let message: String
//    let isShowing: Bool
//
//    func body(content: Content) -> some View {
//        ZStack {
//            content
//            if isShowing {
//                VStack {
//                    Spacer()
//                    Text(message)
//                        .padding()
//                        .background(Color.black.opacity(0.7))
//                        .foregroundColor(.white)
//                        .cornerRadius(8)
//                        .padding(.bottom, 50)
//                        .transition(.opacity)
//                        .animation(.easeInOut)
//                }
//                .frame(maxWidth: .infinity)
//                .padding()
//            }
//        }
//    }
//}
//
//extension View {
//    func toast(message: String, isShowing: Bool) -> some View {
//        self.modifier(ToastModifier(message: message, isShowing: isShowing))
//    }
//}
