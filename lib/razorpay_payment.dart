import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';


class razorPayPage extends StatefulWidget {
  const razorPayPage({Key? key}) : super(key: key);

  @override
  State<razorPayPage> createState() => _razorPayPageState();
}

class _razorPayPageState extends State<razorPayPage> {
  late Razorpay _razorpay;
  TextEditingController amtController = TextEditingController();

  void openCheckout(amount)async{
    amount = amount *100;
    var options = {
      'key' : 'rzp_test_CeD2frLpCyJeny',
      'amount' : amount,
      'name' : 'jumpstart payment gateway',
      'prefill' :{'contact' : '1234567890' , 'email' : 'jumpstart@gmail.com'},
      'external' : {'wallets' : ['paytm']}
    };
    try{
      _razorpay.open(options);
    }catch(e){
      debugPrint('Error : e');
    }
  }


  void handlePaymentSuccess(PaymentSuccessResponse response){
    Fluttertoast.showToast(msg: "Payment Succcessful"+response.paymentId!,toastLength: Toast.LENGTH_SHORT);
  }

  void handlePaymentError(PaymentFailureResponse response){
    Fluttertoast.showToast(msg: "Payment Succcessful"+response.message!,toastLength: Toast.LENGTH_SHORT);
  }

  void handleExternalWallet(ExternalWalletResponse response){
    Fluttertoast.showToast(msg: "External wallet"+response.walletName!,toastLength: Toast.LENGTH_SHORT);
  }


  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(4, 62, 40, 0.9725490196078431),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 100,),
            Image.network('https://images.squarespace-cdn.com/content/v1/61955395f359147c2344167a/c03434ab-92ad-44b8-a2a6-8f43e861416f/Jumpstart+Social+Sharing+Image.png',
              height: 200, width: 350, fit: BoxFit.fill, ),
            SizedBox(height: 70,),
            Text("Welcome to Jumpstart's payment gateway", style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w900, fontSize: 33
            ),textAlign: TextAlign.center,),
            SizedBox(height: 30,),
            Padding(padding: EdgeInsets.all(8.0),
            child: TextFormField(
              cursorColor: Colors.white,
              autofocus: false,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Enter amount to be paid",
                labelStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 25, color: Colors.white),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                    width: 1.0,

                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                    width: 1.0,

                    ),
                  ),
                errorStyle: TextStyle(color: Colors.redAccent, fontSize: 15),

                ),

                controller: amtController,
              validator: (value) {
                if (value==null || value.isEmpty) {
                  return 'Please enter amount to be paid';
                }
                return null;
              },
              ),
            ),

            SizedBox(height: 30,),

            ElevatedButton(onPressed: () {
              if (amtController.text.toString().isNotEmpty){
                setState(() {
                  int amount = int.parse(amtController.text.toString());
                  openCheckout(amount);
                });
    }
    }, child: Padding(
    padding: EdgeInsets.all(8.0),
    child: Text('Make Payment'),
    ),
    style: ElevatedButton.styleFrom(primary: Colors.green),
    ),



          ],
        ),
      ),
    );
  }
}
