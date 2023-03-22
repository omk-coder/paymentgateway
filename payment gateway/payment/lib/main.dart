import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:flutter/services.dart';

void main(){
  runApp(App());

}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
       home: Scaffold(
        body: PayMent(),
       ),
       );
  }

}

class PayMent extends StatefulWidget {
  @override
  _PayMentState createState() => _PayMentState();
}

class _PayMentState extends State<PayMent> {
  TextEditingController _controller = TextEditingController();
  
  Razorpay _razorpay;

  @override
  void initState(){
    _razorpay = Razorpay();
    super.initState();
    
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
  _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
  _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                      width: 5,
                      color: Colors.tealAccent,
                    )
                  )
                ),
              ),
              RaisedButton(
                onPressed: (){
                openCheckout();
              },
              child: Text('Click Here To Pay')
              )
                // RaisedButton(onPressed: null,
                // child: Text('Click To Pay')
                // )
            ],
          ),
        ),
    );
  }



  void openCheckout() async {
  var options = {
    'key': 'rzp_test_n8HMHy0M6YljSa',
    'amount': (double.parse(_controller.text)*1000.roundToDouble()).toString(),
    'name': 'Omkii',
    'description': 'MILLIONAIRE',
    'prefill': {'contact': '', 'email': ''},
    'external': {
      'wallets': ['paytm']
    }
  };

  try{
    _razorpay.open(options);
  } catch (e) {
    debugPrint(e);
  }
}

void _handlePaymentSuccess(PaymentSuccessResponse response){
  Scaffold.of(context).showSnackBar(SnackBar(content: Text("SUCCESS: " + response.paymentId)));
  
}
void _handlePaymentError(PaymentFailureResponse response) {
  // Do something when payment fails
  Scaffold.of(context).showSnackBar(SnackBar(content: Text("ERROR: " + response.code.toString() + " - " + response.message)));


}
void _handleExternalWallet(ExternalWalletResponse response) {
  Scaffold.of(context).showSnackBar(SnackBar(content: Text("EXTERNAL_WALLET: " + response.walletName)));

}
}