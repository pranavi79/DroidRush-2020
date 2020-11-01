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

  void openCheckout(String a, String e) {
    var options = {
      "key": "rzp_test_CQOkWq0PGhpm3g",
      "amount": num.parse(a) * 100,
      "prefill": {
        "email": e,
      },
      "external": {
        "wallets": ["paytm"]
      }
    };
    try {
      razorpay.open(options);
      Navigator.pop(context);
    } catch (e) {
      print(e.toString());
      Navigator.pop(context);
    }
  }

  void handlerPaymentSuccess() {
    print("Payment success");
    Toast.show("Payment success", context);
    Navigator.pop(context);
  }

  void handlerErrorFailure() {
    print("Payment error");
    Toast.show("Payment error", context);
    Navigator.pop(context);
  }

  void handlerExternalWallet() {
    print("External Wallet");
    Toast.show("External Wallet", context);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('transactions')
                .where('member', arrayContains: _auth.currentUser?.email)
                .snapshots(), //FOR CARON: transaction collection hasn't been updated with member field yet so if you see a blank screen,delete where and just do snapshots()
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                );
              } else {
                return ListView.builder(
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (BuildContext context, int index) {
                      final t = snapshot.data.documents[index];
                      Map<dynamic, dynamic> sender = Map.from(t['sender']);
                      return GestureDetector(
                        onTap: () {
                          openCheckout(
                              sender[_auth.currentUser?.email].toString(),
                              t.data()['receiver']);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 15,
                          ),
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width * 0.80,
                                padding: EdgeInsets.only(
                                  left: 20,
                                ),
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          t.data()['receiver'],
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          sender[_auth.currentUser?.email]
                                              .toString(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.w300,
                                            color: Colors.grey,
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              }
            }));
  }
}
