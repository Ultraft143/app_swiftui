import SwiftUI

struct perfil: View {
    
    @State private var username: String = "";
    @State private var password: String = "";
    @State private var email: String = "";
    @State private var checkM: Bool = false
    @State private var checkF: Bool = false
    @State private var isPasswordVisible: Bool = false
    
    let URL_GETUSERBYID = "\(API)/getUserbyID.php"
    
    var body: some View {
        NavigationView{
            
            ZStack {
                Color(.lightGray).ignoresSafeArea();
                
                Circle()
                    .scale(1.7)
                    .foregroundColor(.white.opacity(0.15))
                Circle()
                    .scale(1.3)
                    .foregroundColor(.white)
                
                ZStack
                {
                    
                    ZStack
                    {
                        
                        Image(systemName:"person.crop.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 130, height: 700)
                            .offset(x: 0, y: -300)
                            .padding(22)
                        
                    }
                    
                    
                    ZStack
                    {
                        
                        Text("Perfil")
                            .bold()
                            .foregroundColor(.black)
                            .font(.system(size: 45))
                            .offset(x: 0, y: -200)
                        
                    }
                    
                    TextField ("username", text: $username)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                        .disabled(true)
                        .offset(x: 0 ,y: -70)
                    
                    
                    TextField ("email", text: $email)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                        .disabled(true)
                        .offset(x: 0, y: 15)
                    
                    
                    ZStack {
                        
                        
                        
                        ZStack {
                            
                            
                            
                            if isPasswordVisible {
                                
                                TextField("Password", text: $password)
                                
                                    .padding()
                                
                                    .frame(width: 300, height: 50)
                                
                                    .background(Color.black.opacity(0.05))
                                
                                    .cornerRadius(10)
                                
                                    .offset(x: 0, y: 100)
                                
                                    .disabled(true)
                                
                                
                                
                            } else {
                                
                                SecureField("Password", text: $password)
                                
                                    .padding()
                                
                                    .frame(width: 300, height: 50)
                                
                                    .background(Color.black.opacity(0.05))
                                
                                    .cornerRadius(10)
                                
                                    .offset(x: 0, y: 100)
                                
                                    .disabled(true)
                                
                            }
                            
                            
                            
                            ZStack{ Button(action: {
                                
                                isPasswordVisible.toggle()
                                
                                
                                
                            }) {
                                
                                Text(isPasswordVisible ? "🔓" : "🔐")
                                
                                
                                
                                
                            }
                                
                                
                                
                            }.offset(x: 170, y: 100)
                            
                            NavigationLink(destination: perfiledit())
                            {
                                Image(systemName: "gear")
                                    .resizable()
                                    .frame(width:40, height: 40)
                                    .foregroundColor(.black)
                                
                            }
                            //.background(Color.red)
                            .offset(x:150,y:-350)
                            
                        }
                    }
                }
            }
            
        }
        .onAppear(perform: {
            
            //created NSURL
            let requestURL = URL(string: URL_GETUSERBYID)
            
            //creating NSMutableURLRequest
            let request = NSMutableURLRequest(url: requestURL! as URL)
            
            //setting the method to post
            request.httpMethod = "POST"
            
            //creating the post parameter by concatenating the keys and values from text field
            let postParameters = "user_id=\(UserID)"
            
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
                                //print(UserID)
                                if(UserID == "0"){
                                    username = "Erro!"
                                    email = "Nao foi possivel encontrar o utilizador"
                                    password = ""
                                }else if(jsonResponse["user_name"] as! String != ""){
                                    username = jsonResponse["user_name"] as! String
                                    email = jsonResponse["user_email"] as! String
                                    password = jsonResponse["user_password"] as! String
                                    
                                }
                                
                            } else {
                                print("Error: JSON parsing failed.")
                            }
                        } catch {
                            print("Error: JSON serialization failed.")
                        }
                        
                    })
                    
                })
            
            
            
            task.resume()
            
        })
        
    }
}
#Preview {
    perfil()
}
