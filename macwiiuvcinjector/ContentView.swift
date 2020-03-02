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
                    NavigationLink(destination: snesView(injectorProgress: $injectorProgress)) {
                        Text("Super Nintendo Entertainment System").frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    }
                    //NavigationLink(destination: snesView()){
                       // Text("Nintendo Entertainment System")
                    //}
                    NavigationLink(destination: SettingsView()){
                        Text("Settings").frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    }
                }
                
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
            }.padding()
    }
    func updateProgres(progress: CGFloat) {
        self.injectorProgress = progress
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
