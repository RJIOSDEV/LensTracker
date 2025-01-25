//
//  Toast.swift
//  LensTracker
//
//  Created by Raj on 08/10/24.
//  Copyright © 2024 Bala. All rights reserved.
//

import Foundation
import SwiftUI

struct Toast: Equatable {
    var message: String
    var duration: Double = 3.5
    var width: Double = .infinity
    
}

struct ToastView: View {
    var message: String
    var width = CGFloat.infinity

    var body: some View {
        HStack {
            Text(message)
                .font(Font.subheadline)
                .foregroundColor(Color("darkBlue"))
            
            Spacer()
        }
        .padding()
        .frame(minWidth: 0, maxWidth: width) // Ensure 'width' is valid
        .background(Color(.systemGray3))
        .cornerRadius(8)
        .padding(.horizontal, 16)
    }
}


struct ToastModifier: ViewModifier {
    @Binding var toast : Toast?
    @State private var workItem: DispatchWorkItem?
    
    func body(content: Content) -> some View {
        if #available(iOS 17.0, *) {
            content
                .frame(minWidth: .infinity,maxWidth: .infinity)
                .overlay(
                    ZStack{
                        mainToastView()
                            .offset(y : 32)
                    }.animation(.spring(), value: toast)
                    
                )
                .onChange(of: toast) {
                    showToast()
                }
        } else {
            // Fallback on earlier versions
        }
    }
    @ViewBuilder func mainToastView() -> some View {
        if let toast = toast {
            VStack {
                ToastView(message: toast.message,
                          width: toast.width)
                Spacer()
            }
        }
    }
    private func showToast() {
        guard let toast = toast else {return}
        UIImpactFeedbackGenerator(style: .light)
            .impactOccurred()
        
        if toast.duration > 0 {
            workItem?.cancel()
            
            let task = DispatchWorkItem {
                dismissToast()
            }
            workItem = task
            DispatchQueue.main.asyncAfter(deadline: .now() + toast.duration, execute: task)
        }
        
    }
    private func dismissToast() {
        withAnimation{
            toast = nil
        }
        workItem?.cancel()
        workItem = nil
    }
}

extension View {
    func toastView(toast: Binding<Toast?> ) -> some View {
        self.modifier(ToastModifier(toast: toast))
    }
}
