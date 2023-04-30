//
//  Onboarding.swift
//  NoWaste
//
//  Created by Carlos Alberto Lopez Figueroa on 29/04/23.
//

import SwiftUI

struct Onboarding: View {
    var body: some View {
        NavigationView(){
            ZStack{
                VStack{
                    
                    Image("NoWasteLogo")
                        .resizable()
                        .frame(width: 350, height: 100)
                    Image("Food")
                        .padding(.bottom)
                    VStack{
                        
                        
                        NavigationLink(destination: LoginView()){
                            HStack{
                                HStack{
                                    Text("Iniciar Sesión")
                                        .font(.title3)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(LinearGradient(gradient: Gradient(colors: [.red.opacity(0.9), .orange.opacity(0.7)]), startPoint: .leading, endPoint: .trailing))
                                        .padding()
                                        .frame(width: 220, height: 60)
                                        .background(Color.white).cornerRadius(30)
                                        .shadow(radius: 8,x: 4,y:4)
                                }.padding(.bottom)
                            }
                            
                        }
                        
                        NavigationLink(destination: RegisterView()){
                            HStack{
                                Text("Registrarse")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(width: 220, height: 60)
                                    .background(LinearGradient(gradient: Gradient(colors: [.red.opacity(0.9), .orange.opacity(0.6)]), startPoint: .leading, endPoint: .trailing)
                                    ).cornerRadius(30)
                                    .shadow(radius: 8,x: 4,y:4)
                            }
                            
                        }}
                    
                }
            }
            
        }
        
    }
}

struct Onboarding_Previews: PreviewProvider {
    static var previews: some View {
        Onboarding()
    }
}
