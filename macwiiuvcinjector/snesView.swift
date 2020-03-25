//
//  snesView.swift
//  macwiiuvcinjector
//
//  Created by Candygoblen123 on 2/10/20.
//  Copyright © 2020 Candygoblen123. All rights reserved.
//

import SwiftUI

struct SnesView: View {
    let inj = SnesInjector()
    let file = GetFile()
    @State var name :String = ""
    @State var romFile :String = "Please choose a Rom File (.sfc format)"
    @State var iconTexFile :String = "Please choose an iconTex file"
    @State var tvTexFile :String = "Please choose a bootTvTex file"
    @State var titleId :String = ""
    @State var titleKey :String = ""
    
    @State var injectorStatus:String = "Not started."
    @State var progressIsShowing = false
    
    @State var showError = false
    @State var errorMessage = ""
    
    @State var finishedInject = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Please fill out every field")
            HStack {
                Text("Rom: \(self.romFile)").frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                Button(action: {
                    self.romFile = self.file.browseFile(fileType: "sfc")
                }){
                    Text("Select file...")
                }
            }
            HStack {
                Text("IconTex: \(self.iconTexFile)").frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                Button(action: {
                    self.iconTexFile = self.file.browseFile(fileType: "png")
                }){
                    Text("Select file...")
                }
            }
            HStack {
                Text("bootTvTex: \(self.tvTexFile)").frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                Button(action: {
                    self.tvTexFile = self.file.browseFile(fileType: "png")
                }){
                    Text("Select file...")
                }
            }
            HStack {
                Text("Name:")
                TextField("Please enter a name for your injected game", text: $name)
            }
            HStack {
                Text("Title Id:")
                TextField("Please enter a Title Id for the base", text: $titleId)
            }
            HStack {
                Text("Title Key:")
                TextField("Please enter a Title Key for the base", text: $titleKey)
            }
            HStack {
                Button (action: {
                    self.errorMessage = "Please fill out every field."
                    
                    if self.romFile == "Please choose a Rom File (.sfc format)" || self.romFile == "" {
                        self.showError = true
                    }else if self.iconTexFile == "Please choose an iconTex file" || self.iconTexFile == "" {
                        self.showError = true
                    }else if self.tvTexFile == "Please choose a bootTvTex file" || self.tvTexFile == "" {
                        self.showError = true
                    }else if self.titleId == "" {
                        self.showError = true
                    }else if self.titleKey == "" {
                        self.showError = true
                    }else if self.name == "" {
                        self.showError = true
                    }
                    
                    let commonKeyData = filem.contents(atPath: "\(AppDelegate().applicationSupportDir)/commonKey")
                    let commonKeyString: String = String(data: commonKeyData ?? "".data(using: .utf8)!, encoding: String.Encoding.utf8) ?? ""
                    
                    if commonKeyString == "" || commonKeyString == "Wii U Common Key"{
                        self.errorMessage = "Please provide the Wii U common key on the common key page."
                        self.showError = true
                    }
                    
                    if !self.showError {
                        do {
                            self.injectorStatus = "Injecting..."
                            if try self.inj.inject(rom: self.romFile, iconTex: self.iconTexFile, bootTvTex: self.tvTexFile, titleId: self.titleId, titleKey: self.titleKey, name: self.name) {
                                self.finishedInject = true
                                self.injectorStatus = "Done!"
                            }
                        }catch InjectorError.noOutDirectory {
                            self.errorMessage = "You need to provide a directory that we can save the final injected game to."
                            self.showError = true
                        }catch InjectorError.noJnustoolDownload {
                            self.errorMessage = "We couldn't download the base game files. Your title id/key may not be correct, or you may not be connected to the internet."
                            self.showError = true
                        }catch InjectorError.noXml {
                            self.errorMessage = "We couldn't edit app.xml or meta.xml.  Please try injecting again."
                            self.showError = true
                        }catch InjectorError.noIcon {
                            self.errorMessage = "We couldn't convert your images to the correct format.  Please try again later."
                            self.showError = true
                        }catch InjectorError.noOutput {
                            self.errorMessage = "We couldn't encrypt the final output.  Please try again."
                            self.showError = true
                        }catch {
                            self.errorMessage = "An unexpected error has occurred, please open an issue on github."
                            self.showError = true
                        }
                    }
                }){
                    Text("Inject")
                }.alert(isPresented: self.$showError) {
                    Alert(title: Text("Error."), message: Text(errorMessage), dismissButton: .default(Text("Dismiss")))
                }
                .alert(isPresented: self.$finishedInject) {
                    Alert(title: Text("Finished"), message: Text("Your rom was succesfully injected."), dismissButton: .default(Text("Ok")))
                }
                
                Text(self.injectorStatus)
            }
        }.padding()
    }
    
    
}



struct SnesView_Previews: PreviewProvider {
    static var previews: some View {
        SnesView()
    }
}
