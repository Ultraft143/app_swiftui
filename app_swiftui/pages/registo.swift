import SwiftUI
import UIKit


struct registo: View {
    
    
    
    @State private var email: String = "";
    
    @State private var confirmemail: String = "";
    
    @State private var password: String = "";
    
    @State private var confirmpassword: String = "";
    
    @State private var username: String = "";
    
    @State private var isPasswordVisible: Bool = false
    
    @State private var isPasswordConfirmVisible: Bool = false
    
    @State private var showAlert: Bool = false;
    
    @State public var alertuser = false;
    
    @State public var alertmessage: String = ""
    
    let URL_CREATE_USER = "\(API)/createuser.php"
    
    
    
    var body: some View {
        
        ZStack {
            
            Color(.yellow).ignoresSafeArea();
            
            Circle()
            
                .scale(1.7)
            
                .foregroundColor(.white.opacity(0.15))
            
            Circle()
            
                .scale(1.3)
            
                .foregroundColor(.white)
            
            
            
            VStack {
                
                
                
                
                
                Text("Projeto")
                
                    .foregroundColor(.black)
                
                    .bold()
                
                    .font(.system(size: 56))
                
                    .offset(x:0,y:40)
                
                
                
                VStack {
                    
                    
                    
                    VStack {
                        
                        TextField ("Insira o seu username", text: $username)
                        
                            .padding()
                        
                            .frame(width: 300, height: 50)
                        
                            .background(Color.black.opacity(0.05))
                        
                            .cornerRadius(10)
                        
                            .offset(x:0,y:30)
                        
                        Rectangle()
                        
                            .frame(width: 300, height: 1)
                        
                            .offset(x:0,y:30)
                        
                    }
                    
                    
                    
                    VStack {
                        
                        TextField ("Insira o seu email", text: $email)
                        
                            .autocapitalization(.none)
                        
                            .keyboardType(.emailAddress)
                        
                            .padding()
                        
                            .frame(width: 300, height: 50)
                        
                            .background(Color.black.opacity(0.05))
                        
                            .cornerRadius(10)
                        
                            .offset(x:0,y:40)
                        
                        
                        
                        Rectangle()
                        
                            .frame(width: 300, height: 1)
                        
                            .offset(x:0,y:40)
                        
                        
                        
                        TextField ("Confirme o seu Email", text: $confirmemail)
                        
                            .padding()
                        
                            .frame(width: 300, height: 50)
                        
                            .background(Color.black.opacity(0.05))
                        
                            .cornerRadius(10)
                        
                            .offset(x:0,y:40)
                        
                        
                        
                        Rectangle()
                        
                            .frame(width: 300, height: 1)
                        
                            .offset(x:0,y:40)
                        
                    } .padding()
                    
                    VStack {
                        
                        
                        
                        if isPasswordVisible {
                            
                            TextField("Password", text: $password)
                            
                                .padding()
                            
                                .frame(width: 300, height: 50)
                            
                                .background(Color.black.opacity(0.05))
                            
                                .cornerRadius(10)
                            
                                .offset(x:0,y:30)
                            
                            
                            
                            
                            
                        } else {
                            
                            SecureField("Password", text: $password)
                            
                                .padding()
                            
                                .frame(width: 300, height: 50)
                            
                                .background(Color.black.opacity(0.05))
                            
                                .cornerRadius(10)
                            
                                .offset(x:0,y:30)
                            
                            
                            
                        }
                        
                        
                        
                        Rectangle()
                        
                            .frame(width: 300, height: 1)
                        
                            .offset(x:0,y:30)
                        
                        Button(action: {
                            
                            isPasswordVisible.toggle()
                            
                            
                            
                        }) {
                            
                            Text(isPasswordVisible ? "🔓" : "🔐")
                            
                            
                            
                        }
                        
                        .offset(x: 170, y: -20)
                        
                        
                        
                        if isPasswordConfirmVisible {
                            
                            TextField("Confirme a sua password", text: $confirmpassword)
                            
                                .padding()
                            
                                .frame(width: 300, height: 50)
                            
                                .background(Color.black.opacity(0.05))
                            
                                .cornerRadius(10)
                            
                                .offset(x:0,y:0)
                            
                            
                            
                            
                            
                        } else {
                            
                            SecureField("Confirme a sua password", text: $confirmpassword)
                            
                                .padding()
                            
                                .frame(width: 300, height: 50)
                            
                                .background(Color.black.opacity(0.05))
                            
                                .cornerRadius(10)
                            
                                .offset(x:0,y:0)
                            
                            
                            
                        }
                        
                        
                        
                        Rectangle()
                        
                            .frame(width: 300, height: 1)
                        
                            .offset(x:0,y:0)
                        
                        Button(action: {
                            
                            isPasswordConfirmVisible.toggle()
                            
                            
                            
                        }) {
                            
                            Text(isPasswordConfirmVisible ? "🔓" : "🔐")
                            
                            
                            
                        }
                        
                        .offset(x: 170, y: -50)
                        
                    } .padding()
                    
                    Spacer ()
                    
                        .frame(width: 1, height: 10)
                    
                    
                    
                    Button (action: {
                        
                        //created NSURL
                        let requestURL = URL(string: URL_CREATE_USER)
                        
                        //creating NSMutableURLRequest
                        let request = NSMutableURLRequest(url: requestURL! as URL)
                        
                        //setting the method to post
                        request.httpMethod = "POST"
                        
                        //creating the post parameter by concatenating the keys and values from text field
                        let postParameters = "user_email=\($email.wrappedValue)&user_name=\($username.wrappedValue)&user_password=\($password.wrappedValue)"
                        
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
                                                alertuser = true
                                                alertmessage = jsonResponse["message"] as! String
                                            }
                                            else{
                                                alertuser = false
                                                alertmessage = jsonResponse["message"] as! String
                                            }
                                            showAlert = true
                                        } else {
                                            print("Error: JSON parsing failed.")
                                            alertuser = false
                                            showAlert = true
                                        }
                                    } catch {
                                        print("Error: JSON serialization failed.")
                                        alertuser = false
                                        showAlert = true
                                    }
                                    
                                })
                                
                            })
                        
                        
                        
                        task.resume()
                    }) {
                        
                        
                        
                        Text ("Finalizar")
                        
                            .font(.callout)
                        
                            .foregroundColor(.white)
                        
                            .frame(width: 200, height: 28)
                        
                            .background (Color.black.opacity(0.80))
                        
                            .cornerRadius(30)
                        
                        
                        
                    }
                    .alert(isPresented: $showAlert, content: {
                        if(alertuser == true){
                            if(alertmessage != ""){
                                Alert(title: Text("Sucesso!"), message: Text("\(alertmessage)"))
                            }
                            else{
                                Alert(title: Text("Sucesso!"), message: Text("O Registo foi finalizado com sucesso."))
                            }
                        }else{
                            if(alertmessage != ""){
                                Alert(title: Text("Erro!"), message: Text("\(alertmessage)"))
                            }
                            else{
                                Alert(title: Text("Erro!"), message: Text("Não foi possivel executar o Registo."))
                            }
                        }
                    })
                    
                }
                
            }
            
        }
        
    }
    
}



#Preview {
    
    registo()
    
}
