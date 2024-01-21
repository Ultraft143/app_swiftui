import SwiftUI



struct presença: View {
    @State private var nome: String = "";
    @State private var empresa: String = "";
    @State private var email: String = "";
    @State private var data = Date()
    @State private var contacto: String = "";
    @State private var isChecked: Bool = false;
    @ObservedObject public var input = NumbersOnly()
    @State private var showAlert: Bool = false;
    @State public var alertuser = false;
    
    let URL_CREATE_PRESENCA = "\(API)/createpresenca.php"

    
    class NumbersOnly: ObservableObject{
        @Published var value = "" {
            didSet{
                let filtered = value.filter{$0.isNumber}
                if value != filtered{
                    value = filtered
                }
            }
        }
    }
    
    var body: some View{
        
        
        
        
        ZStack{
            Color(.blue).ignoresSafeArea();
            
            Circle()
                .scale(1.7)
                .foregroundColor(.white.opacity(0.15))
            Circle()
                .scale(1.3)
                .foregroundColor(.white)
            
            VStack{
                
                
                
                Color("Default").ignoresSafeArea();
                
                Text ("Presença")
                
                    .foregroundColor(.black)
                    .bold()
                    .font(.system(size: 56))
                    .offset(y:-30)
                
                VStack{
                    
                    Text("Nome:")
                        .bold()
                        .offset(CGSize(width: -120.0, height: 10.0))
                        .padding(5)
                    
                    TextField ("", text: $nome)
                        .padding()
                        .font(.callout)
                        .foregroundColor(.black)
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(5)
                        .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
                    
                    
                    
                }
                .offset(x:0,y:-45)
                
                
                VStack{
                    Text("Empresa:")
                        .bold()
                        .offset(CGSize(width: -110.0, height: 10.0))
                        .padding(5)
                    
                    TextField ("", text: $empresa)
                        .padding()
                        .font(.callout)
                        .foregroundColor(.black)
                        .frame(width: 300, height: 50)
                        .cornerRadius(5)
                        .background(Color.black.opacity(0.05))
                        .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
                    
                }
                .offset(x:0,y:-25)
                VStack{
                    Text("Email:")
                        .bold()
                        .offset(CGSize(width: -123.0, height: 10.0))
                        .padding(5)
                    
                    TextField ("", text: $email)
                        .padding()
                        .font(.callout)
                        .foregroundColor(.black)
                        .frame(width: 300, height: 50)
                        .cornerRadius(5)
                        .background(Color.black.opacity(0.05))
                        .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
                    
                }
                .offset(x:0,y:-10)
                VStack{
                    Text("Contacto:")
                        .bold()
                        .offset(CGSize(width: -110.0, height: 10.0))
                        .padding(5)
                    
                    TextField ("", text: $contacto)
                        .padding()
                    //erro desta versao.keyboardType(.decimalPad)
                        .foregroundColor(Color.black)
                        .frame(width: 300, height: 50)
                        .cornerRadius(5)
                        .background(Color.black.opacity(0.05))
                        .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
                    
                }
                .offset(x:0,y:10)
                
                
                HStack{
                    @State var selectedDate: Date = Date()
                    Text("Hora de chegada:")
                    DatePicker("", selection: $selectedDate)
                        .labelsHidden()
                    
                }
                .offset(x:0,y:50)
                
                Button(action: {
                    
                    //created NSURL
                    let requestURL = URL(string: URL_CREATE_PRESENCA)
                    
                    //creating NSMutableURLRequest
                    let request = NSMutableURLRequest(url: requestURL! as URL)
                    
                    //setting the method to post
                    request.httpMethod = "POST"
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd/MM/YY, HH:mm:ss"

                    //creating the post parameter by concatenating the keys and values from text field
                    let postParameters = "nome=\($nome.wrappedValue)&empresa=\($empresa.wrappedValue)&email=\($email.wrappedValue)&contacto=\($contacto.wrappedValue)&data=\(dateFormatter.string(from: data))&idTrack=\(TrackPicked)"

                    
                    //adding the parameters to request body
                    request.httpBody = postParameters.data(using: String.Encoding.utf8)
                    
                    //creating a task to send the post request
                    let task = URLSession.shared.dataTask(
                        with: request as URLRequest,
                        completionHandler: { data, response, error in
                            DispatchQueue.main.async(execute:{
                                
                                do {
                                    if let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
                                        print("JSON response: \(jsonResponse)")
                                        if(jsonResponse["error"] as! Int == 0){
                                            print(data as Any)
                                            print(response as Any)
                                            print(error as Any)
                                            alertuser = true
                                        }
                                        else{
                                            print(data as Any)
                                            print(response as Any)
                                            print(error as Any)
                                            alertuser = false
                                        }
                                        showAlert = true
                                    } else {
                                        print(data as Any)
                                        print(response as Any)
                                        print(error as Any)
                                        print("Error: JSON parsing failed.")
                                        alertuser = false
                                        showAlert = true
                                    }
                                } catch {
                                    print(data as Any)
                                    print(response as Any)
                                    print(error as Any)
                                    print("Error: JSON serialization failed.")
                                    alertuser = false
                                    showAlert = true
                                }
                                
                            })
                            
                        })
                    
                    
                    
                    task.resume()
                    
                }){
                    Text("Confirmar Presença")
                        .font(.callout)
                        .foregroundColor(.white)
                        .frame(width: 200, height: 50)
                        .bold()
                        .background(Color.black)
                        .cornerRadius(30)
                    
                }
                .alert(isPresented: $showAlert, content: {
                    if(alertuser == true){
                        Alert(title: Text("Sucesso!"), message: Text("Presença confirmada com sucesso."))
                    }else{
                        Alert(title: Text("Erro!"), message: Text("Nao foi possivel confirmar a presença."))
                    }
                    
                })
                .offset(y: 80)
            }
            .offset(y: -80)
            
        }
        
    }
    
    
}



#Preview {
    presença()
}
