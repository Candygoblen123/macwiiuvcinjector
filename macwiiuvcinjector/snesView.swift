//
//  snesView.swift
//  macwiiuvcinjector
//
//  Created by Andrew Glaze on 2/10/20.
//  Copyright © 2020 Candygoblen123. All rights reserved.
//

import SwiftUI

struct snesView: View {
    let file = GetFile()
    @State var romFile :String = "Please choose a Rom File (.sfc format)"
    @State var iconTexFile :String = "Please choose an iconTex file"
    @State var tvTexFile :String = "Please choose a bootTvTex file"
    @State var titleId :String = ""
    @State var titleKey :String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Please fill out every field")
            HStack {
                Text("Rom: \(self.romFile)")
                Button(action: {
                    self.romFile = self.file.browseFile()
                }){
                    Text("Select file...")
                }
            }
            HStack {
                Text("Icon: \(self.iconTexFile)")
                Button(action: {
                    self.iconTexFile = self.file.browseFile()
                }){
                    Text("Select file...")
                }
            }
            HStack {
                Text("Bootscreens: \(self.tvTexFile)")
                Button(action: {
                    self.tvTexFile = self.file.browseFile()
                }){
                    Text("Select file...")
                }
            }
            HStack {
                Text("Title Id:")
                TextField("Please enter a Title Id", text: $titleId)
            }
            HStack {
                Text("Title Key:")
                TextField("Please enter a Title Key", text: $titleKey)
            }
        }.padding()
    }
}

struct snesView_Previews: PreviewProvider {
    static var previews: some View {
        snesView()
    }
}
