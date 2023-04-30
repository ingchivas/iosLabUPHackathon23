//
//  ScheduleDonationView.swift
//  NoWaste
//
//  Created by Carlos Alberto Lopez Figueroa on 30/04/23.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

// Define a struct for the donation
struct Donation: Codable, Identifiable, Hashable{
    @DocumentID var id: String?
    var timestamp: Date
    var dateOfDonation: Date
    var commerceID: String
    var commerceName: String
    var commerceAddress: String
    var commerceIMG: String
    var typeOfDonation: String = "Alimentos"
    var status: String = "pending"
    var uuid: String = UUID().uuidString
    var acceptedBy: String = ""
    var deliveryBy: String = ""
}


struct ScheduleDonationView: View {
    @State var email: String = ""
    @State var name: String = ""
    @State var address: String = ""
    @State var image: URL? = URL(string: "https://i.mbgrp.com.mx/placeholder.jpg")
    @State var role: String = ""
    @State var firebaseID: String = ""
    @State var date: Date = Date()
    @State var time: Date = Date()
    @State var typeOfDonation: String = "Alimentos"
    @State var hasDonated: Bool = false
    
    let db = Firestore.firestore()
    let auth = Auth.auth()
    
    @State var isLoggedIn: Bool = true
    
    func getUserData()
    {
        let user = Auth.auth().currentUser
        if let user = user {
            db.collection("users").document(user.uid).getDocument { (document, error) in
                if let document = document, document.exists {
                    let data = document.data()
                    let name = data?["name"] as? String ?? ""
                    let email = data?["email"] as? String ?? ""
                    let role = data?["role"] as? String ?? ""
                    let address = data?["address"] as? String ?? ""
                    let image = data?["userIMG"] as? String ?? ""
                    self.name = name
                    self.email = email
                    self.role = role
                    self.address = address
                    self.image = URL(string: image)
                    self.firebaseID = user.uid
                    
                } else {
                    print("Document does not exist")
                }
            }
        }
    }
    
    // On load, get user data
    
    var body: some View {
        // NavigationView that shows a date and time picker
        if (hasDonated == false){
        NavigationView {
            VStack {
                
                HStack {
                    Text("Bienvenido, \(name)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Color(.black))
                    Spacer()
                    // Profile image
                    VStack{
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                do {
                                    try auth.signOut()
                                    self.isLoggedIn = false
                                } catch {
                                    print("Error signing out")
                                }
                            }
                        }, label: {
                            HStack{
                                Text("Cerrar Sesión")
                                    .font(.caption2)
                                    .foregroundColor(Color(.black))
                                Image(systemName: "arrowshape.turn.up.left.fill")
                                    .font(.caption2)
                                    .foregroundColor(Color(.black))
                            }
                        })
                        AsyncImage(
                            url: image!) { image in
                                image.resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                            } placeholder: {
                                ProgressView()
                            }
                    }
                }.padding()
                Text("Selecciona la fecha y hora de tu donación")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(Color(.black))
                    .padding()
                DatePicker("Fecha", selection: $date, displayedComponents: .date)
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .padding()
                DatePicker("Hora", selection: $time, displayedComponents: .hourAndMinute)
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .padding()
                // Picker for the type of donation
                Text("Tipo de donación")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(Color(.black))
                    .padding()
                Picker(selection: $typeOfDonation, label: Text("Tipo de donación").font(.title).fontWeight(.bold).foregroundColor(Color(.black)).padding()) {
                    Text("Alimentos").tag("Alimentos")
                    Text("Víveres").tag("Víveres")
                }.pickerStyle(SegmentedPickerStyle())
                    .padding()
                
                Button(action: {
                    let dateofD: Date = Calendar.current.date(bySettingHour: Calendar.current.component(.hour, from: time), minute: Calendar.current.component(.minute, from: time), second: 0, of: date)!
                    
                    let timeofD: Date = dateofD
                    
                    let donation = Donation(timestamp: Date(), dateOfDonation: timeofD, commerceID: firebaseID, commerceName: name, commerceAddress: address, commerceIMG: image!.absoluteString, typeOfDonation: typeOfDonation, status: "pending", uuid: UUID().uuidString, acceptedBy: "", deliveryBy: "")
                    do {
                        let _ = try db.collection("donations").addDocument(from: donation)
                        
                        print("Donation scheduled")
                        hasDonated = true
                    } catch {
                        print(error)
                    }
                    
                }, label: {
                    Text("Agendar")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(LinearGradient(gradient: Gradient(colors: [.red.opacity(0.9), .orange.opacity(0.7)]), startPoint: .leading, endPoint: .trailing))
                        .padding()
                        .frame(width: 220, height: 60)
                        .background(Color.white).cornerRadius(30)
                        .shadow(radius: 8,x: 4,y:4)
                }).padding()
            }
        }.onAppear(perform: getUserData)
        }else{
            CommerceView()
    }
    }
}

struct ScheduleDonationView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleDonationView()
    }
}
