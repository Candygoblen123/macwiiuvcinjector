//
//  ContentView.swift
//  macwiiuvcinjector
//
//  Created by Candygoblen123 on 2/10/20.
//  Copyright © 2020 Candygoblen123. All rights reserved.
//

import SwiftUI


struct ContentView: View {
    @State var injectorProgress: CGFloat = 0.0
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
                    NavigationLink(destination: SnesView()) {
                        Text("Super Nintendo Entertainment System").frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    }
                    NavigationLink(destination: NdsView()){
                        Text("Nintendo DS").frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    }
                    NavigationLink(destination: WiiView()){
                        Text("Wii").frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    }
                    NavigationLink(destination: GcView()){
                        Text("GameCube").frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    }
                    NavigationLink(destination: SettingsView()){
                        Text("Common Key").frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    }
                }
                
            }
            }.padding().frame(minWidth: 250, minHeight: 268)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
