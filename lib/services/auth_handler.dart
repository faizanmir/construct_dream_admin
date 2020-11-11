import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';


abstract class AuthCallback
{
  void onCodeSent(String id);
  void onGoogleSignInSuccessful();
  void onGoogleLoginFailed();

}



enum OtpStatus {
  onCodeSent,
  enteringOtp,
  otpEntered,
  verificationSuccessful,
  verificationFailed,
  googleAuthSuccessful
}



class AuthHandler with ChangeNotifier{
  final googleSignIn = GoogleSignIn();
  final firebaseAuth = FirebaseAuth.instance;
  static AuthHandler authHandler;
  AuthCallback authCallback;
  OtpStatus _otpStatus  =  OtpStatus.enteringOtp;
  OtpStatus get otpStatus => _otpStatus;
  bool authState =  false;
  String smsCode;
  String verificationId;


  set otpStatus(OtpStatus value) {
    _otpStatus = value;
    notifyListeners();
  }


  setAuthCallbacks(AuthCallback authCallback){
    this.authCallback  =  authCallback;
  }






  void  doGoogleSignIn() async {
    FirebaseUser user;
    bool signedIn = await googleSignIn.isSignedIn();
    if (signedIn) {
      user = await firebaseAuth.currentUser();
    } else {
      final GoogleSignInAccount googleUser =
      await googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;
      final AuthCredential credential =
      GoogleAuthProvider.getCredential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken);
      user = (await firebaseAuth.signInWithCredential(credential)).user;
    }
    if(user.email != null)
      {
        authCallback.onGoogleSignInSuccessful();
        otpStatus =OtpStatus.googleAuthSuccessful;
        notifyListeners();
      }
    else{
      authCallback.onGoogleLoginFailed();
    }
  }


  Future<FirebaseUser> getFirebaseUser() async => await firebaseAuth.currentUser();




  Future<GoogleSignInAccount> doGoogleSignAccountSignOut() async{
    return googleSignIn.signOut();
  }


  signOutCompletely() async
  {
    await googleSignIn.signOut();
    await firebaseAuth.signOut();

  }



  void doSignInWithNumber(String phoneNumber) async{
    print("Phone number "+ phoneNumber);
   await firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: Duration(seconds: 60),
        verificationCompleted: _onPhoneNumberVerified,
        verificationFailed: _onPhoneNumberVerificationFailed,
        codeSent: _onCodeSent,
        codeAutoRetrievalTimeout: _onCodeAutoRetrievalTimeOut);

  }



 PhoneVerificationCompleted _onPhoneNumberVerified (AuthCredential auth){


  }

 PhoneVerificationFailed _onPhoneNumberVerificationFailed  (AuthException authException){
    otpStatus = OtpStatus.verificationFailed;
    notifyListeners();
  }

 PhoneCodeSent _onCodeSent   (String verificationId,[ int forceResendingToken]){
    print("Code Sent");
    authCallback.onCodeSent( verificationId);
    otpStatus = OtpStatus.enteringOtp;
    notifyListeners();

 }


PhoneCodeAutoRetrievalTimeout _onCodeAutoRetrievalTimeOut  =   (String verificationId){
   print(verificationId);
 };











 void onOtpEntered(String otp,String verificationId) async
 {

   AuthCredential authCredential  =  PhoneAuthProvider.getCredential(verificationId: verificationId, smsCode: otp);
   try {
     AuthResult result = await firebaseAuth.signInWithCredential(
         authCredential);
     FirebaseUser firebaseUser = result.user;


     if (firebaseUser != null) {
       otpStatus =OtpStatus.verificationSuccessful;
       notifyListeners();

     }
     else {
       otpStatus = OtpStatus.verificationFailed;
       notifyListeners();
     }
   }catch(e){
     otpStatus= OtpStatus.verificationFailed;
     notifyListeners();
   }

 }
 
}