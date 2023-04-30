//
//  CommerceView.swift
//  NoWaste
//
//  Created by Carlos Alberto Lopez Figueroa on 29/04/23.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

struct CommerceView: View {
    @State var email: String = ""
    @State var name: String = ""
    @State var address: String = ""
    @State var image: URL? = URL(string: "https://i.mbgrp.com.mx/placeholder.jpg")
    @State var role: String = ""
    @State var firebaseID: String = ""
    @State var topDonations = [Donation]()
    
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
    
    // Get recent donations from this user from firestore
    func getRecentDonations()
    {
        let user = Auth.auth().currentUser
        let docRef = db.collection("donations").whereField("commerceID", isEqualTo: user?.uid ?? "").order(by: "timestamp", descending: true).limit(to: 3)
        do {
            try docRef.getDocuments { (querySnapshot, error) in
                if let querySnapshot = querySnapshot {
                    for document in querySnapshot.documents {
                        let data = document.data()
                        let timestamp = data["timestamp"] as? Timestamp ?? Timestamp()
                        let dateOfDonation = data["dateOfDonation"] as? Timestamp ?? Timestamp()
                        let commerceID = data["commerceID"] as? String ?? ""
                        let commerceName = data["commerceName"] as? String ?? ""
                        let commerceAddress = data["commerceAddress"] as? String ?? ""
                        let commerceIMG = data["commerceIMG"] as? String ?? ""
                        let typeOfDonation = data["typeOfDonation"] as? String ?? ""
                        let status = data["status"] as? String ?? ""
                        let uuid = data["uuid"] as? String ?? ""
                        let acceptedBy = data["acceptedBy"] as? String ?? ""
                        let deliveryBy = data["deliveryBy"] as? String ?? ""
                        let donation = Donation(timestamp: timestamp.dateValue(), dateOfDonation: dateOfDonation.dateValue(), commerceID: commerceID, commerceName: commerceName, commerceAddress: commerceAddress, commerceIMG: commerceIMG, typeOfDonation: typeOfDonation, status: status, uuid: uuid, acceptedBy: acceptedBy, deliveryBy: deliveryBy)
                        self.topDonations.append(donation)
                    }
                }
            }
        } catch {
            print("Error getting recent donations")
        }
    }
    
    var body: some View {
        NavigationView{
            if isLoggedIn {
                VStack {
                    
                    HStack {
                        Text("Bienvenido, \(name)")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color(.black))
                        Spacer()
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
                        }.padding()
                    }.padding()
                    Spacer()
                    lottieView(name: "food", loopmode: .loop, contentMode: .scaleAspectFit, animationSpeed: 1).ignoresSafeArea()
                    VStack{
                        Text("Tus Donaciones Recientes")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(Color(.black))
                        ForEach(topDonations, id: \.self) { donation in
                            HStack{
                                AsyncImage(
                                    url: URL(string: donation.commerceIMG)!) { image in
                                        image.resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 50, height: 50)
                                            .clipShape(Circle())
                                    } placeholder: {
                                        ProgressView()
                                    }
                                VStack(alignment: .leading){
                                    Text(donation.status.capitalized)
                                        .font(.title3)
                                        .fontWeight(.bold)
                                        .foregroundColor(Color(.black))
                                    Text(donation.typeOfDonation)
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .foregroundColor(Color(.black))
                                }
                                Spacer()
                                Text(donation.dateOfDonation, style: .date)
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(.black))
                            }.padding()
                        }
                    }
                    
                    VStack {
                        NavigationLink(destination: ScheduleDonationView()) {
                            Text("Agendar Donación")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundStyle(LinearGradient(gradient: Gradient(colors: [.red.opacity(0.9), .orange.opacity(0.7)]), startPoint: .leading, endPoint: .trailing))
                                .padding()
                                .frame(width: 220, height: 60)
                                .background(Color.white).cornerRadius(30)
                                .shadow(radius: 8,x: 4,y:4)
                        }
                        
                    }
                }
            } else {
                Onboarding()
            }
        }.onAppear(perform: {
            getUserData()
            getRecentDonations()
        })
    }
    
}


struct CommerceView_Previews: PreviewProvider {
    static var previews: some View {
        CommerceView()
    }
}
