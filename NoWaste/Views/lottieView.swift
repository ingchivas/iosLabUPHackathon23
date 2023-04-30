//
//  lottieView.swift
//  loginAuth
//
//  Created by iOS Lab on 29/04/23.
//

import SwiftUI
import Lottie

struct lottieView: UIViewRepresentable{
    
    let name: String
    let loopMode: LottieLoopMode
    let animationSpeed: CGFloat
    
    let animationView:LottieAnimationView
    
    init(name:String,
         loopmode:LottieLoopMode = .loop,contentMode:UIView.ContentMode = .scaleAspectFit,
         animationSpeed: CGFloat = 1){
        self.name = name
        self.animationView = LottieAnimationView(name: name)
        self.loopMode = loopmode
        self.animationSpeed = animationSpeed
    }
        
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        view.addSubview(animationView)
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        animationView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        animationView.loopMode = loopMode
        animationView.animationSpeed = animationSpeed
        animationView.play()
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }

}
