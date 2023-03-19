//
//  SettingsView.swift
//  SwiftyCrypto
//
//  Created by varunbhalla19 on 19/03/23.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            List {
                
                Section {
                    Image("logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxHeight: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                    
                    Text("This app was made by following a Swiftful Thinking course on Youtube. It uses SwiftUI, Combine, CoreData along with MVVM Architecture. \nThe Project benefits from multi threading, data persistence and reactive programming.")
                        .font(.callout)
                    
                    Link(destination: URL(string: "https://github.com/varunbhalla19/SwiftyCrypto")!) {
                        Text("Github Repo")
                    }
                } header: {
                    Text("About")
                }
                
                Section {
                    Image("coingecko")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxHeight: 100)
                        .padding(.vertical, 4)
                    
                    Link(destination: URL(string: "https://www.coingecko.com/en/api/documentation")!) {
                        Text("Free CoinGecko API")
                    }
                } header: {
                    Text("API")
                }
                
                Section {
                    Image("quickType")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 200, maxHeight: 100)
                        .padding(.vertical, 4)
                    
                    Text("Used to convert JSON into typesafe code in any language")
                        .font(.callout)
                    
                    Link(destination: URL(string: "https://app.quicktype.io/")!) {
                        Text("QuickType")
                    }
                } header: {
                    Text("Helper")
                }
                
                Section {
                    Image("github")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                        .frame(maxHeight: 100)
                    Link(destination: URL(string: "https://github.com/varunbhalla19/SwiftyCrypto")!) {
                        Text("Github Repo")
                    }
                } header: {
                    Text("Github")
                }
            }
            .font(.headline)
            .tint(.blue)
            .navigationTitle("Info")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    XMark {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .preferredColorScheme(.dark)
    }
}
