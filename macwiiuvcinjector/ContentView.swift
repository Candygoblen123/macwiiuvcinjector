//
//  ContentView.swift
//  macwiiuvcinjector
//
//  Created by Candygoblen123 on 2/10/20.
//  Copyright © 2020 Candygoblen123. All rights reserved.
//

import SwiftUI


struct ContentView: View {
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Text("Welcome to the injector")
                    .font(.title)
                    .multilineTextAlignment(.leading)
                Text("Please select a console:")
                    .font(.subheadline)
                    .multilineTextAlignment(.leading)
            }
            NavigationView {
                List {
                    NavigationLink(destination: snesView()) {
                        Text("Super Nintendo Entertainment System")
                    }
                    //NavigationLink(destination: snesView()){
                       // Text("Nintendo Entertainment System")
                    //}
                    NavigationLink(destination: SettingsView()){
                        Text("Settings")
                    }
                }
                
            }
        }.padding()
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
