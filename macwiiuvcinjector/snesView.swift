//
//  snesView.swift
//  macwiiuvcinjector
//
//  Created by Andrew Glaze on 2/10/20.
//  Copyright © 2020 Candygoblen123. All rights reserved.
//

import SwiftUI

struct snesView: View {
    let inj = SnesInjector()
    let file = GetFile()
    @State var notFilled = false
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
            Button (action: {
                if self.romFile == "Please choose a Rom File (.sfc format)" || self.romFile == "" {
                    self.notFilled = true
                }else if self.iconTexFile == "Please choose an iconTex file" || self.iconTexFile == "" {
                    self.notFilled = true
                }else if self.tvTexFile == "Please choose a bootTvTex file" || self.tvTexFile == "" {
                    self.notFilled = true
                }else if self.titleId == "" {
                    self.notFilled = true
                }else if self.titleKey == "" {
                    self.notFilled = true
                }
                
                if !self.notFilled {
                    self.inj.inject(rom: self.romFile, iconTex: self.iconTexFile, tvTex: self.tvTexFile, titleId: self.titleId, titleKey: self.titleKey)
                }
            }){
                Text("Inject")
            }.alert(isPresented: self.$notFilled) {
                Alert(title: Text("Fields Not Filled"), message: Text("Please fill in every field."), dismissButton: Alert.Button.cancel())
            }
        }.padding()
    }
}

struct snesView_Previews: PreviewProvider {
    static var previews: some View {
        snesView()
    }
}
