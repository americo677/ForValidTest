//
//  FileSystem.swift
//  PokedexApp
//
//  Created by Américo José Cantillo Gutiérrez on 8/05/20.
//  Copyright © 2020 Américo José Cantillo Gutiérrez. All rights reserved.
//

import UIKit

// MARK: - Rertorna la ruta absoluta del archivo enviado como argumento.
func getPath(_ fileName: String) -> String {
    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let fileURL = documentsURL.appendingPathComponent(fileName)
    return fileURL.path
}

func getDocumentsURL() -> NSURL {
    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    return documentsURL as NSURL
}

func fileInDocumentsDirectory(filename: String) -> String {
    let fileURL = getDocumentsURL().appendingPathComponent(filename)
    return fileURL!.path
    
}

func copyFileFromBundleToDirectory(directory directoryName: String, file filename: String) -> Bool {
    
    var isFileCopied: Bool = false
    
    if isAValidDirectory(directory: directoryName) {
        let manager = FileManager.default
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let path = paths.appendingPathComponent(directoryName)
        //let fullPath = "\(path.appendingPathComponent(filename))"
        let fullPath = path.appendingPathComponent(filename)

        var isDir: ObjCBool = false
        
        let ext = fullPath.relativePath.getFileExtension()
        let name = fullPath.relativePath.getFilenameWithoutExtension()
    
        //print("full path: \(fullPath)")
        if !manager.fileExists(atPath: fullPath.relativePath, isDirectory: &isDir) {
            
            let fileFromBundle = Bundle.main.path(forResource: name, ofType: ext)
            
            do {
                try manager.copyItem(atPath: fileFromBundle!, toPath: fullPath.relativePath)
                isFileCopied = true
                //print("El archivo fue copiado con éxito.")
            } catch {
                print("Error al intentar copiar el archivo \(fileFromBundle!) en la ruta \(fullPath.relativePath)")
            }
        }
    }
    return isFileCopied
}

func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let documentsDirectory = paths[0]
    return documentsDirectory
}

func genRandomFileName(formato sufix: String) -> String {
    var fileName = UUID().uuidString
    fileName += "." + sufix
    return fileName
}

func genFileNameFromDateTime(sufix formato: String) -> String {
    let date = NSDate()
    let calendar = NSCalendar.current
    let hour = calendar.component(.hour, from: date as Date)
    let minutes = calendar.component(.minute, from: date as Date)
    let seconds = calendar.component(.second, from: date as Date)
    let day = calendar.component(.day, from: date as Date)
    let month = calendar.component(.month, from: date as Date)
    let year = calendar.component(.year, from: date as Date)
    
    let fileName = String(format: "%04d%02d%02d%02d%02d%02d.%@", year, month, day, hour, minutes, seconds, formato)
    
    return fileName
}

// conseguido en internet
// https://iosdevcenters.blogspot.com/2016/04/save-and-get-image-from-document.html

// Save image at document directory

func isAValidDirectory(directory directoryName: String) -> Bool {
    //let fileManager = FileManager.default
    
    let manager = FileManager.default
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    //let path = "\(paths.appendingPathComponent(directoryName))"
    let path = paths.appendingPathComponent(directoryName)
    //let fileManager = FileManager.default
    
    var isDir: ObjCBool = false
    var isValidDir: Bool = false
    
    //print("path on isAValidDirectory: \(path.relativePath)")
    
    if manager.fileExists(atPath: path.relativePath, isDirectory: &isDir) {
        if isDir.boolValue {
            // file exists and is a directory
            //print("El directorio \(directoryName) es válido")
            isValidDir = true
        } else {
            // file exists and is not a directory
            //print("Error, el componente Images no es un directorio")
            isValidDir = createDirectory(directory: directoryName)
        }
    } else {
        // file does not exist
        //print("Error, no existe el directorio para Mis Regalos App")
        isValidDir = createDirectory(directory: directoryName)
    }
    
    return isValidDir
}

func saveImageIn(directory directoryName: String, data: Data?) -> String {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    var isSaveOk: Bool = true
    var fullPath: URL? = nil
    var fileName: String?
    if isAValidDirectory(directory: directoryName) {
        let path = paths.appendingPathComponent(directoryName)
        fileName = genRandomFileName(formato: "png")
        fullPath = path.appendingPathComponent(fileName!)
        if let imageData = data {
            do {
                try imageData.write(to: fullPath!)
            } catch {
                print("Error al escribir imagen: \(error.localizedDescription)")
                isSaveOk = false
            }
        }
        if !isSaveOk {
            print("No se pudo almacenar el archivo \(fullPath!.absoluteString)")
        }
    } else {
        isSaveOk = false
    }
    if isSaveOk {
        return fileName!
    }
    return ""
}

func saveImageIn(directory directoryName: String, image: UIImage!, fullFileName fileName: inout String) -> Bool {
    
    //let manager = FileManager.default
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    var isSaveOk: Bool = true
    
    if isAValidDirectory(directory: directoryName) {
        let path = paths.appendingPathComponent(directoryName)
        
        fileName = genFileNameFromDateTime(sufix: "jpg")
        
        let fullPath = path.appendingPathComponent(fileName)
        
        //print("File name: \(fileName)")
        //print("Full path: \(fullPath)")
        
        let imageData = image!.jpegData(compressionQuality: 0.5)

        do {
            
            try imageData?.write(to: fullPath)
            
        } catch {
            print("Error al escribir imagen: \(error.localizedDescription)")
            isSaveOk = false
        }
        
        if !isSaveOk {
            print("No se pudo almacenar el archivo \(fullPath.absoluteString)")
        }
    } else {
        isSaveOk = false
    }
    
    return isSaveOk
}

// MARK: - Carga la imagen asociada al full path suministrado.
func loadImageFrom(directory directoryName: String, fileName: String) -> UIImage {
    let iImage: UIImage?
    
    let manager = FileManager.default
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    let path = paths.appendingPathComponent(directoryName)
    
    let imagePath = path.appendingPathComponent(fileName)
    
    //print("Full image path: \(imagePath)")
    
    if manager.fileExists(atPath: imagePath.path) {
        iImage = UIImage(contentsOfFile: imagePath.path)
        //iImage = UIImage(contentsOfFile: imagePath)
    } else {
        print("No se encontró la imagen: \(imagePath.absoluteString)")
        iImage = UIImage()
    }
    
    return iImage!
}

// get image from document directory
func getImageFrom(directory directoryName: String, fileName: String) -> UIImage {
    
    let iImage: UIImage?
    
    let manager = FileManager.default
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    let path = paths.appendingPathComponent(directoryName)
    
    let imagePath = path.appendingPathComponent(fileName)
    
    //print("Full image path: \(imagePath)")
    
    if manager.fileExists(atPath: imagePath.path) {
        iImage = UIImage(contentsOfFile: imagePath.path)
    } else {
        print("Not found image \(imagePath.absoluteString)")
        iImage = UIImage()
    }
    
    return iImage!
}

func getImageFullPathFrom(directory directoryName: String, fileName: String) -> String! {
    let vacio = ""
    //let iImage: UIImage?
    
    //let manager = FileManager.default
    if !(fileName.isEmpty) {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let path = paths.appendingPathComponent(directoryName)
        
        let imagePath = path.appendingPathComponent(fileName)
        
        //print("Full image path: \(imagePath)")
        
        //if manager.fileExists(atPath: imagePath.path) {
        //    iImage = UIImage(contentsOfFile: imagePath.path)
        //} else {
        //    print("Not found image \(imagePath.absoluteString)")
        //    iImage = UIImage()
        //}
        
        return imagePath.path
    }
    
    return vacio
}

// create directory
func createDirectory(directory directoryName: String) -> Bool {
    let manager = FileManager.default
    
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    let path = paths.appendingPathComponent(directoryName)
    
    var isCreationOk: Bool = true
    
    if !manager.fileExists(atPath: path.path) {
        do {
            try manager.createDirectory(atPath: path.path, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print("Error al intentar crear el directorio \(directoryName): \(error.localizedDescription)")
            isCreationOk = false
        }
    } else {
        print("El directorio \(directoryName) ya existe!")
    }
    
    return isCreationOk
}

// delete directory
func deleteFileFrom(directory directoryName: String, fileNameToDelete fileName: String) -> Bool {
    let manager = FileManager.default
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    let path = paths.appendingPathComponent(directoryName)
    
    let imagePath = path.appendingPathComponent(fileName)
    
    var isDeletedOk: Bool = true
    
    if manager.fileExists(atPath: imagePath.path) {
        try! manager.removeItem(atPath: imagePath.path)
    } else {
        print("No se pudo elminar el archivo \(imagePath.path)")
        isDeletedOk = false
    }
    
    return isDeletedOk
}

// MARK: - Procedimientos para operar fechas

// MARK: - Retorna el primer día del mes/año suministrado.
func firstDayOf(month: Int, year: Int) -> NSDate {
    var startDate = NSDate()
    
    let strDate = ("\("01")-\(month)-\(year)")
    
    let fmtDate = DateFormatter()

    fmtDate.dateFormat = "dd-MM-yyyy"

    startDate = fmtDate.date(from: strDate)! as NSDate
    
    
    //let calendar = Calendar.currentCalendar()
    
    //let components = calendar.components([.Year, .Month, .Day, .Hour, .Minute, .Second], fromDate: date)
    
    //let lmonth = components.month
    //let lyear = components.year
    
    //let startOfMonth = ("\(year)-\(month)-01")
    
    //let components = calendar.components([.Year, .Month], fromDate: date)
    
    //let startOfMonth = calendar.dateFromComponents(components)!
    
    //print(dateFormatter.stringFromDate(startOfMonth)) // 2015-11-01
    //print("Fecha inicial: \(month)/\(year): \(startDate)")
    
    return startDate
}

func lastDayOf(month: Int, year: Int) -> NSDate {
    //let comps2 = NSDateComponents()
    
    //comps2.month = month
    //comps2.day = -1
    
    var lastDay = NSDate()
    
    let calendar = Calendar.current
    
    let startDate = firstDayOf(month: month, year: year)
    
    //let endOfMonth = calendar.dateByAddingComponents(comps2, toDate: startDate, options: [])!
    
    let nextMonth = calendar.date(byAdding: .month, value: 1, to: startDate as Date)
    
    let date = calendar.date(byAdding: .day, value: -1, to: nextMonth!)
    
    lastDay = date! as NSDate
    //let fmtDate = DateFormatter()
    
    //fmtDate.dateFormat = "dd-MM-yyyy"

    //print(dateFormatter.stringFromDate(endOfMonth)) // 2015-11-30
    //print("Fecha inicial: \(month)/\(year): \(lastDay)")
    
    return lastDay

}

func daysBetween(startDay: NSDate, lastDay: NSDate) -> Int {
    let calendar = Calendar.current
    let dias =  Set<Calendar.Component>([.day])
    
    let result = calendar.dateComponents(dias, from: startDay as Date,  to: lastDay as Date)
    
    return result.day! + 1
}

func daysLeft(startDay: NSDate) -> Int {
    let calendar = Calendar.current
    let dias =  Set<Calendar.Component>([.day])
    let periodo = Set<Calendar.Component>([.month, .year])
    
    let comp = calendar.dateComponents(periodo, from: startDay as Date)
    
    let lastDay = lastDayOf(month: comp.month!, year: comp.year!)
    
    let result = calendar.dateComponents(dias, from: startDay as Date,  to: lastDay as Date)
    
    return result.day! + 1
}

func samePeriod(reference date1: NSDate, compareTo date2: NSDate) -> Bool {
    var isEqual: Bool = false
    
    let calendar = Calendar.current
    let setPeriod = Set<Calendar.Component>([.month, .year])
    
    let refPeriod = calendar.dateComponents(setPeriod, from: date1 as Date)
    
    //dateComponents(setPeriod, from: date1 as Date)
    let compareToPeriod = calendar.dateComponents(setPeriod, from: date2 as Date)
    
    if refPeriod.year == compareToPeriod.year && refPeriod.month == compareToPeriod.month {
        isEqual = true
    }
    return isEqual
}

func valorFormateado(valor: Double, decimales: Int, estilo: NumberFormatter.Style = .none) -> String {
    let fmtNumber = NumberFormatter()
    
    fmtNumber.numberStyle = estilo
    fmtNumber.maximumFractionDigits = decimales
    return fmtNumber.string(from: NSNumber.init(value: valor))!
}

