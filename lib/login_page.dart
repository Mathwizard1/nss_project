import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nss_project/signup_page.dart';

final enableborder=OutlineInputBorder(
  borderSide:const BorderSide(width:3,color:Color.fromARGB(255, 175, 178, 175)),
  borderRadius:BorderRadius.circular(12)
);

final focusborder=OutlineInputBorder(
  borderSide:const BorderSide(width:3,color:Colors.blue),
  borderRadius:BorderRadius.circular(12)
);

class LoginPage extends StatefulWidget
{
  const LoginPage({super.key});

  @override
    State createState()
    {
      return LoginPageState();
    }
}

class LoginPageState extends State<LoginPage>
{
  TextEditingController emailinput=TextEditingController();
  TextEditingController passwordinput=TextEditingController();


  bool _encryptionState=false;
  var passwordicon=Icons.enhanced_encryption;

  Future signIn() async
  {
    await FirebaseAuth.instance.signInWithEmailAndPassword(email:emailinput.text.trim() , password: passwordinput.text.trim());
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }


  @override
  void dispose()
  {
    super.dispose();
    emailinput.dispose();
    passwordinput.dispose();
  }

  @override
  Widget build(BuildContext context)
  {

    double width=MediaQuery.sizeOf(context).width;
    double height=MediaQuery.sizeOf(context).height;


    return Scaffold(
      //resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body:SingleChildScrollView(
          padding:EdgeInsets.fromLTRB(0, height/10, 0, 0),
          child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
          SizedBox(
            width:400,
            height:300,
            child:Image.asset("assets/images/nss_logo.png")
          ),

          Padding( padding:EdgeInsets.fromLTRB(0,20,width*0.45,20),
          child:const Text("Welcome!",style:TextStyle(fontSize:30,fontWeight:FontWeight.w900))
          ),

          Padding( 
            padding:EdgeInsets.fromLTRB(width/10,0,width/10,0),
            child:TextField(
              controller:emailinput,
              decoration: InputDecoration(
              enabledBorder: enableborder,
              focusedBorder: focusborder,
              labelText:"Enter Email",
            ),
          )
          ),

           Padding( 
            padding:EdgeInsets.fromLTRB(width/10,20,width/10,0),
            child:TextField(
              obscuringCharacter: '*',
              obscureText: _encryptionState,
              controller:passwordinput,
              decoration: InputDecoration(
              suffixIcon:IconButton(
                icon:Icon(passwordicon),
                onPressed:()=>{setState((){
                  if(_encryptionState==false)
                   {
                  _encryptionState=true;
                  passwordicon=Icons.no_encryption;
                   }
                  else
                  {
                    _encryptionState=false;
                    passwordicon=Icons.enhanced_encryption;
                  }
                  }
                 )
               },

              ),
              enabledBorder: enableborder,
              focusedBorder: focusborder,
              labelText:"Enter Password",
            ),
          )
          ),

          

          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: SizedBox(
              width:width/3,
              height:50,
              child:TextButton(
                onPressed: (){
                  signIn();
                },
                style:const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.blue),
                  foregroundColor:WidgetStatePropertyAll(Colors.white),
                ),
                child:const Text("Submit"),
              )
              ),
          ),

           Padding(
             padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
             child: Row(mainAxisAlignment: MainAxisAlignment.center,
             children: [const Text("Dont have an account? "),GestureDetector(onTap:(){Navigator.push(context,MaterialPageRoute(builder: (context)=>const SignUpPage()));},child: const Text("Sign Up",style:TextStyle(color:Colors.blue)))],),
           )
          ]
        )
      ),
     )
;
  }

}