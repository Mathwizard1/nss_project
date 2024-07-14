import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


final enableborder=OutlineInputBorder(
  borderSide:const BorderSide(width:3,color:Color.fromARGB(255, 175, 178, 175)),
  borderRadius:BorderRadius.circular(12)
);

final focusborder=OutlineInputBorder(
  borderSide:const BorderSide(width:3,color:Colors.blue),
  borderRadius:BorderRadius.circular(12)
);


var _confirmpasswordbordercolor=const Color.fromARGB(255, 186, 185, 185);
bool confirmpasswordstate=false;



class SignUpPage extends StatefulWidget
{

  final VoidCallback showloginpage;
  const SignUpPage({super.key,required this.showloginpage});


  @override  
  State createState()
  {
    return SignUpPageState();
  }
}

class SignUpPageState extends State<SignUpPage>
{

  var confirmpasswordfocusborder=OutlineInputBorder(
  borderSide:BorderSide(width:3,color:_confirmpasswordbordercolor),
  borderRadius:BorderRadius.circular(12)
  );


  TextEditingController emailcontroller=TextEditingController();
  TextEditingController firstnamecontroller=TextEditingController();
  TextEditingController lastnamecontroller=TextEditingController();
  TextEditingController rollnumbercontroller=TextEditingController();
  TextEditingController passwordcontroller=TextEditingController();
  TextEditingController confirmpasswordcontroller=TextEditingController();

  bool informationcheck()
  {
    if(emailcontroller.text.trim()!=""&&rollnumbercontroller.text.trim()!=""&&firstnamecontroller.text.trim()!=""&&lastnamecontroller.text.trim()!=""&&passwordcontroller.text.trim()!="")
    {
      return true;
    }
    else
    {
      return false;
    }
  }


  Future signUp() async
  {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailcontroller.text.trim(), password: passwordcontroller.text.trim());

    await FirebaseFirestore.instance.collection('users').add({
      'email':emailcontroller.text.trim(),
      'first name':firstnamecontroller.text.trim(),
      'last name':lastnamecontroller.text.trim(),
      'roll number':rollnumbercontroller.text.trim(),
      'password':passwordcontroller.text.trim(),
    });
  }


  bool confirmpassword(String a,String b)
  {
    if(a==b)
    {
      return true;
    }
    else
    {
      return false;
    }
  }

  @override
  Widget build(BuildContext context)
  {
    var passwordicon=Icons.enhanced_encryption;
    bool encryptionState=false;

    final screenwidth=MediaQuery.sizeOf(context).width;
    final screenheight=MediaQuery.sizeOf(context).height;

    return Scaffold(
      //resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body:SingleChildScrollView(
          padding:EdgeInsets.fromLTRB(0, screenheight/20, 0, 0),
          child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
          SizedBox(
            width:200,
            height:150,
            child:Image.asset("assets/images/nss_logo.png")
          ),

          Padding( padding:EdgeInsets.fromLTRB(0,20,screenwidth*0.5,20),
          child:const Text("Sign Up",style:TextStyle(fontSize:30,fontWeight:FontWeight.w900))
          ),

          Padding( 
            padding:EdgeInsets.fromLTRB(screenwidth/10,0,screenwidth/10,0),
            child:TextField(
              controller:emailcontroller,
              decoration: InputDecoration(
              enabledBorder: enableborder,
              focusedBorder: focusborder,
              labelText:"Enter Email",
            ),
          )
          ),

          Padding( 
            padding:EdgeInsets.fromLTRB(screenwidth/10,20,screenwidth/10,0),
            child:TextField(
              controller:firstnamecontroller,
              decoration: InputDecoration(
              enabledBorder: enableborder,
              focusedBorder: focusborder,
              labelText:"Enter First Name",
            ),
          )
          ),

          Padding( 
            padding:EdgeInsets.fromLTRB(screenwidth/10,20,screenwidth/10,0),
            child:TextField(
              controller:lastnamecontroller,
              decoration: InputDecoration(
              enabledBorder: enableborder,
              focusedBorder: focusborder,
              labelText:"Enter Last Name",
            ),
          )
          ),

          Padding( 
            padding:EdgeInsets.fromLTRB(screenwidth/10,20,screenwidth/10,0),
            child:TextField(
              controller:rollnumbercontroller,
              decoration: InputDecoration(
              enabledBorder: enableborder,
              focusedBorder: focusborder,
              labelText:"Enter Roll Number",
            ),
          )
          ),
          

           Padding( 
            padding:EdgeInsets.fromLTRB(screenwidth/10,20,screenwidth/10,0),
            child:TextField(
              obscuringCharacter: '*',
              obscureText: encryptionState,
              controller:passwordcontroller,
              decoration: InputDecoration(
              suffixIcon:IconButton(
                icon:Icon(passwordicon),
                onPressed:()=>{setState((){
                  if(encryptionState==false)
                   {
                  encryptionState=true;
                  passwordicon=Icons.no_encryption;
                   }
                  else
                  {
                    encryptionState=false;
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
            padding:EdgeInsets.fromLTRB(screenwidth/10,20,screenwidth/10,0),
            child:TextField(
              controller:confirmpasswordcontroller,
              onTap: (){setState(() {
                _confirmpasswordbordercolor=Colors.red;
              });},
              onSubmitted: (value){
                if
                (confirmpassword(passwordcontroller.text.trim(),confirmpasswordcontroller.text.trim()))
                {
                  setState(() {
                  _confirmpasswordbordercolor=Colors.green;
                  confirmpasswordstate=true;
                  });
                }
                else
                {
                   setState(() {
                  
                  _confirmpasswordbordercolor=Colors.red;
                  confirmpasswordstate=false;
                  });
                }
              },
              obscuringCharacter: '*',
              obscureText: true,
              decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide:BorderSide(width:3,color:_confirmpasswordbordercolor),
                borderRadius:BorderRadius.circular(12)
                ),
              focusedBorder: focusborder,
              labelText:"Confirm Password",
            ),
          )
          ),

          

          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: SizedBox(
              width:screenwidth/3,
              height:50,
              child:TextButton(
                onPressed: (){
                  if(confirmpasswordstate==true&&informationcheck())
                  {
                  signUp();
                  }
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
             padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
             child: Row(mainAxisAlignment: MainAxisAlignment.center,
             children: [const Text("Dont have an account? "),GestureDetector(onTap:widget.showloginpage,child: const Text("Sign Up",style:TextStyle(color:Colors.blue)))],),
           )

          ]
        )
      ),
     );
  }
}