//
//  ContentView.swift
//  SwiftUIPencilKit
//
//  Created by Hakob Ghlijyan on 21.08.2024.
//

import SwiftUI
import PencilKit

struct ContentView: View {
    var body: some View {
        Home()
    }
}

#Preview {
    ContentView()
}

struct Home: View {
    @State private var canvas = PKCanvasView()
    @State private var isDraw: Bool = true
    @State private var color: Color  = .black
    @State private var type: PKInkingTool.InkType  = .pencil
    @State private var colorPicker: Bool = false
    
    var body: some View {
        NavigationStack {
            DrawingView(canvas: $canvas, isDraw: $isDraw, type: $type, color: $color)
                .navigationTitle("Drawing")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button(action: {
                            //saving image
                            saveImage()
                        }, label: {
                            Image(systemName: "square.and.arrow.down.fill")
                        })
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        HStack {
                            Button(action: {
                                isDraw = false
                            }, label: {
                                Image(systemName: "eraser.fill")
                            })
                            
                            Button(action: {
                                colorPicker.toggle()
                            }, label: {
                                Label {
                                    Text("Color")
                                } icon: {
                                    Image(systemName: "eyedropper.full")
                                }
                            })
    
                            Menu {
                                //2
                                Button(action: {
                                    isDraw = true
                                    type = .pencil
                                }, label: {
                                    Label {
                                        Text("Pencil")
                                    } icon: {
                                        Image(systemName: "pencil")
                                    }
                                })
                                //3
                                Button(action: {
                                    isDraw = true
                                    type = .pen
                                }, label: {
                                    Label {
                                        Text("Pen")
                                    } icon: {
                                        Image(systemName: "pencil.tip")
                                    }
                                })
                                //4
                                Button(action: {
                                    isDraw = true
                                    type = .marker
                                }, label: {
                                    Label {
                                        Text("Marker")
                                    } icon: {
                                        Image(systemName: "highlighter")
                                    }
                                })
                            } label: {
                                Image(systemName: "menucard.fill")
                                    .font(.title3)
                            }

                        }
                    }
                }
                .sheet(isPresented: $colorPicker) {
                    ColorPicker("Pick Color", selection: $color)
                        .padding()
                        .presentationDetents([.height(100)])
                        .presentationDragIndicator(.visible)
                }
        }
    }
    
    func saveImage() {
        //getting image frome canvas
        let image = canvas.drawing.image(from: canvas.drawing.bounds, scale: 1)
        
        //save
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
    
}

struct DrawingView: UIViewRepresentable {
    //to capture drawing foe saving into album
    @Binding var canvas: PKCanvasView
    @Binding var isDraw: Bool
    @Binding var type: PKInkingTool.InkType
    @Binding var color: Color
    
    //1 let ink = PKInkingTool(.pencil, color: .black)
    // Update ink
    var ink: PKInkingTool {
        PKInkingTool(type, color: UIColor(color))
    }
    
    let eraser = PKEraserTool(.bitmap )
    
    func makeUIView(context: Context) -> PKCanvasView {
        canvas.drawingPolicy = .anyInput
        canvas.tool = isDraw ? ink : eraser
        return canvas
    }
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        // updating tool when ever main view updates...
        uiView.tool = isDraw ? ink : eraser
    }
}
