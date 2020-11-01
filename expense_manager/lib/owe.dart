import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:toast/toast.dart';
class OweScreen extends StatefulWidget {
  final User curr;
  OweScreen({this.curr});
      @override
  _OweScreenState createState() => _OweScreenState();
}
class _OweScreenState extends State<OweScreen> {
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  User curr;
  String messageText;
  @override
  void initState() {
    super.initState();
    getCurrentUser();
        razorpay = new Razorpay();

    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlerPaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlerErrorFailure);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handlerExternalWallet);
  }

  void getCurrentUser() async {
    try {
      User hey = _auth.currentUser;
      if (hey != null) {
        curr = hey;
      }
    } catch (e) {
      print(e);
    }
  }
    Razorpay razorpay;

  @override
  void dispose() {
    super.dispose();
    razorpay.clear();
  }

  void openCheckout(){
    var options = {
      "key" : "rzp_test_CQOkWq0PGhpm3g",
      "amount" : "num.parse(textEditingController.text)*100",
      "prefill":{
        "email"
      },
      "external" : {
        "wallets" : ["paytm"]
      }
    };

    try{
      razorpay.open(options);

    }catch(e){
      print(e.toString());
    }

  }

  void handlerPaymentSuccess(){
    print("Payment success");
    Toast.show("Payment success", context);
  }

  void handlerErrorFailure(){
    print("Payment error");
    Toast.show("Payment error", context);
  }

  void handlerExternalWallet(){
    print("External Wallet");
    Toast.show("External Wallet", context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('transactions').where('sender',isEqualTo: curr?.email ).snapshots(),
    builder: (context, snapshot) {
                if (!snapshot.hasData) {
        return Center(
          child: CircularProgressIndicator(
			valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
        );
      } else {
        return ListView.builder(
        itemCount:snapshot.data.documents.length,
        itemBuilder: (BuildContext context, int index) {
        final t=snapshot.data.document[index];
        print(index);
            return Container(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 15,
              ),
              child: Row(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width*0.90,
                    padding: EdgeInsets.only(
                      left: 20,
                    ),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text(
                                  t.data()['receiver'],
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ), 
                                Padding(
                                   padding: EdgeInsets.only(right: 20.0),
                                   child: Icon(
                                      Icons.monetization_on
                                     ),
                                 ),
                                 Text(
                                   "money",
                                   style:TextStyle(
                                     fontWeight:FontWeight.w300,
                                     color:Colors.grey,
                                   ),
                                 )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
      }
        );
        }
    })
    );
  }
}