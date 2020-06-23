//
//  ImageHandler.swift
//  macwiiuvcinjector
//
//  Created by Candygoblen123 on 2/27/20.
//  Copyright © 2020 Candygoblen123. All rights reserved.
//

import Foundation
import MagickWand

struct ImageHandler {
    // The wii u expects this data to be appended to the end of every tga file
    let truevisionFileData = Data([0, 0, 0, 0, 0, 0, 0, 0, 84, 82, 85, 69, 86, 73, 83, 73, 79, 78, 45, 88, 70, 73, 76, 69, 46, 0])
    
    func icon(iconTex: String, base :String) {
        //convert png icon to a wii u compadible tga icon
        //set up MagickWand
        MagickWandGenesis()
        let iconWand = NewMagickWand()
        
        //read the png file
        if MagickReadImage(iconWand, iconTex) == MagickFalse{
            print("could not read iconTex")
        }
        
        //do the conversion
        MagickResizeImage(iconWand, 128, 128, LanczosFilter)
        MagickSetDepth(iconWand, 32)
        MagickSetImageCompression(iconWand, NoCompression)
        MagickSetImageType(iconWand, TrueColorAlphaType)
        MagickSetImageOrientation(iconWand, BottomLeftOrientation)
        MagickFlipImage(iconWand)
        
        
        
        //write the image to file
        if MagickWriteImage(iconWand, "\(base)/meta/iconTex.tga") == MagickFalse {
            print("could not write iconTex.tga file")
        }
        
        //clean up
        DestroyMagickWand(iconWand)
        MagickWandTerminus()
        
        //append the truevision data 
        let iconFile =  FileHandle(forWritingAtPath: "\(base)/meta/iconTex.tga")
        iconFile?.seekToEndOfFile()
        iconFile?.write(truevisionFileData)
 
    }
    
    func bootTv(bootTvTex: String, base :String) {
        //convert png bootTvTex to a wii u compadible tga bootTvTex and bootDrcTex
        //set up MagickWand
        MagickWandGenesis()
        let tvWand = NewMagickWand()
        let drcWand = NewMagickWand()
        
        //read the png
        if MagickReadImage(tvWand, bootTvTex) == MagickFalse {
            print("could not read bootTv file")
        }
        if MagickReadImage(drcWand, bootTvTex) == MagickFalse {
            print("could not read bootTv file")
        }
        
        //do the conversion for tvWand
        MagickResizeImage(tvWand, 1280, 720, LanczosFilter)
        MagickSetDepth(tvWand, 24)
        MagickSetImageCompression(tvWand, NoCompression)
        MagickSetImageType(tvWand, TrueColorType)
        MagickSetImageOrientation(tvWand, BottomLeftOrientation)
        MagickFlipImage(tvWand)
        
        //do the conversion for drcWand
        MagickResizeImage(drcWand, 854, 480, LanczosFilter)
        MagickSetDepth(drcWand, 24)
        MagickSetImageCompression(drcWand, NoCompression)
        MagickSetImageType(drcWand, TrueColorType)
        MagickSetImageOrientation(drcWand, BottomLeftOrientation)
        MagickFlipImage(drcWand)
        
        //write the tgas to file
        if MagickWriteImage(tvWand, "\(base)/meta/bootTvTex.tga") == MagickFalse {
            print("could not write bootTvTex.tga file")
        }
        if MagickWriteImage(drcWand, "\(base)/meta/bootDrcTex.tga") == MagickFalse {
            print("could not write bootDrcTex.tga file")
        }
        
        //clean up
        DestroyMagickWand(tvWand)
        DestroyMagickWand(drcWand)
        MagickWandTerminus()
        
        //append the truevision data
        let bootTvFile =  FileHandle(forWritingAtPath: "\(base)/meta/bootTvTex.tga")
        bootTvFile?.seekToEndOfFile()
        bootTvFile?.write(truevisionFileData)
        
        let bootDrcFile =  FileHandle(forWritingAtPath: "\(base)/meta/bootDrcTex.tga")
        bootDrcFile?.seekToEndOfFile()
        bootDrcFile?.write(truevisionFileData)
    }
}


