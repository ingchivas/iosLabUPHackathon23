//
//  DeliveryView.swift
//  NoWaste
//
//  Created by Carlos Alberto Lopez Figueroa on 30/04/23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import FirebaseFirestoreSwift


struct DeliveryView: View {
    @State var email: String = ""
    @State var name: String = ""
    @State var address: String = ""
    @State var image: URL? = URL(string: "https://i.mbgrp.com.mx/placeholder.jpg")
    @State var role: String = ""
    @State var firebaseID: String = ""
    @State var pendingDeliveryDonations = [Donation]()
    @State var isLoggedIn : Bool = true
    
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    let auth = Auth.auth()
    @State var userRole: String = ""
    
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
    
    func getPendingDeliveryDonations(){
        db.collection("donations").whereField("status", isEqualTo: "acceptedByFoodbank").getDocuments { (querySnapshot, error) in
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
                    // Append donation to array only if it is not already in the array
                    if !self.pendingDeliveryDonations.contains(donation){
                        self.pendingDeliveryDonations.append(donation)
                    }
                    
                }
            }
        }
    }

    func getAdressOfDelivery(orderUUID : String) -> String{
        var address: String = ""
        db.collection("donations").whereField("uuid", isEqualTo: orderUUID).getDocuments { (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                for document in querySnapshot.documents {
                    let data = document.data()
                    print("Data: \(data)")
                    
                    address = data["commerceAddress"] as? String ?? ""
                }
            }
        }
        print("Address: \(address)")
        
        return address
    }
    
    var body: some View {
        VStack(alignment: .leading){
            
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
                        url: image) { image in
                            image.resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                        } placeholder: {
                            ProgressView()
                        }
                }
            }.padding()
            Text("Donaciones pendientes de entrega")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(Color(.black))
                .padding()
            
            List(pendingDeliveryDonations, id: \.self){ donation in
                VStack{
                    HStack{
                        VStack(alignment: .leading){
                            Text("Donación de \(donation.commerceName)")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(Color(.black))
                            Text("Dirección: \(donation.commerceAddress)")
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundColor(Color(.black))
                            Text("Tipo de donación: \(donation.typeOfDonation)")
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundColor(Color(.black))
                            Text("Fecha de entrega: \(donation.dateOfDonation)")
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundColor(Color(.black))
                        }
                        Spacer()
                        Button(action: {
                            db.collection("donations").whereField("uuid", isEqualTo: donation.uuid).getDocuments { (querySnapshot, error) in
                                if let querySnapshot = querySnapshot {
                                    for document in querySnapshot.documents {
                                        let documentID = document.documentID
                                        db.collection("donations").document(documentID).updateData([
                                            "status": "onDelivery",
                                            "deliveryBy": self.firebaseID
                                        ]) { err in
                                            if let err = err {
                                                print("Error updating document: \(err)")
                                            } else {
                                                print("Document successfully updated")
                                            }
                                        }
                                    }
                                }
                            }
                            self.pendingDeliveryDonations.removeAll()
                            getPendingDeliveryDonations()
                        }, label: {
                            // Zstack with checkmark and circle
                            ZStack{
                                Circle()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(Color(.black))
                                Image(systemName: "checkmark")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(.white))
                            }

                        })
                    }
                    MapView(locationString: donation.commerceAddress)
                        .frame(height: 200)
                        .cornerRadius(10)
                }
            }.scrollContentBackground(.hidden)
            .listStyle(PlainListStyle())
        }.onAppear(perform: {
            getUserData()
            getPendingDeliveryDonations()
        })
    }
}


struct DeliveryView_Previews: PreviewProvider {
    static var previews: some View {
        DeliveryView()
    }
}
