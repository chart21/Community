import 'package:flutter/material.dart';
import 'package:maptest/secondaryPages/verifierSelection.dart';
import 'package:maptest/state.dart';

//Payment Page to let users withdrawl or add balance
class PaymentPage extends StatefulWidget {
  //***Blockchain read to load balance, blockchain write deduct balance, third party integration to add payment methods */
  final AppState appState;
  PaymentPage({Key key, @required this.appState}) : super(key: key);

  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  @override
  Widget build(BuildContext context) {
    int euPrice = widget.appState.balance.floor();
    int cePrice = (widget.appState.balance * 100).floor() - euPrice * 100;
    // String priceText = widget.price.toString() + '/min';
    String balanceText = euPrice.toString().padLeft(1, '0') +
        '.' +
        cePrice.toString().padLeft(2, '0') +
        '€';
    return Theme(
      data: ThemeData(primaryColor: Colors.black, canvasColor: Colors.white),
      child: Scaffold(
        appBar: AppBar(title: Text('Payment')),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(children: [
            Container(
              decoration: new BoxDecoration(
                  color: Colors.black,
                  borderRadius:
                      new BorderRadius.all(const Radius.circular(15))),
              padding: EdgeInsets.all(10),
              width: double.maxFinite,
              child: Text(
                'Balance ' + balanceText,
                style: TextStyle(fontSize: 25, color: Colors.green),
                textAlign: TextAlign.center,
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 50, bottom: 10),
                child: Text(
                  'Add Balance or Debit Authorization',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            ListTile(
                leading: Text('Amount'),
                title: TextFormField(
                  keyboardType: TextInputType.number,
                ),
                trailing: Container(width: 70, child: Text('€'))),
            Container(
                padding: const EdgeInsets.only(top: 10),
                width: double.maxFinite,
                height: 50,
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.black,
                          style: BorderStyle.solid,
                          width: 1),
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: // child: ImageIcon(
                            //  AssetImage('assets/marcericons/DriveNow.png'),
                            Image.asset('assets/brandIcons/paypal.png'),
                      ),
                      SizedBox(width: 10),
                      Center(
                        child: Text(
                          'Add via Paypal',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat'),
                        ),
                      )
                    ],
                  ),
                )),
            Container(
                padding: const EdgeInsets.only(top: 10),
                width: double.maxFinite,
                height: 50,
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.black,
                          style: BorderStyle.solid,
                          width: 1),
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: // child: ImageIcon(
                            //  AssetImage('assets/marcericons/DriveNow.png'),
                            Image.asset('assets/brandIcons/bank.png'),
                      ),
                      SizedBox(width: 10),
                      Center(
                        child: Text(
                          'Add via Bank Transfer',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat'),
                        ),
                      )
                    ],
                  ),
                )),
            Container(
                padding: const EdgeInsets.only(top: 10),
                width: double.maxFinite,
                height: 50,
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.black,
                          style: BorderStyle.solid,
                          width: 1),
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: // child: ImageIcon(
                            //  AssetImage('assets/marcericons/DriveNow.png'),
                            Image.asset('assets/brandIcons/creditcard.png'),
                      ),
                      SizedBox(width: 10),
                      Center(
                        child: Text(
                          'Add via Credit Card',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat'),
                        ),
                      )
                    ],
                  ),
                )),
            Container(
                padding: const EdgeInsets.only(top: 10),
                width: double.maxFinite,
                height: 50,
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.black,
                          style: BorderStyle.solid,
                          width: 1),
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: // child: ImageIcon(
                            //  AssetImage('assets/marcericons/DriveNow.png'),
                            Icon(Icons.receipt),
                      ),
                      SizedBox(width: 10),
                      Center(
                        child: Text(
                          'Add via Voucher Code',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat'),
                        ),
                      )
                    ],
                  ),
                )),
            VerifierSelection(
              objectTypes: [
                'Automatically',
                'BMW',
                'Emmy',
                'Donkey',
                'Authority1',
                'Authority2'
              ],
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 25, bottom: 10),
                child: Text(
                  'Withdrawl Balance',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            ListTile(
                leading: Text('Amount'),
                title: TextFormField(
                  keyboardType: TextInputType.number,
                ),
                trailing: Container(width: 70, child: Text('€'))),
            Container(
                padding: const EdgeInsets.only(top: 10),
                width: double.maxFinite,
                height: 50,
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.black,
                          style: BorderStyle.solid,
                          width: 1),
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: // child: ImageIcon(
                            //  AssetImage('assets/marcericons/DriveNow.png'),
                            Image.asset('assets/brandIcons/bank.png'),
                      ),
                      SizedBox(width: 10),
                      Center(
                        child: Text(
                          'Add to your Bank Account',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat'),
                        ),
                      )
                    ],
                  ),
                )),
            Container(
                padding: const EdgeInsets.only(top: 10),
                width: double.maxFinite,
                height: 50,
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.black,
                          style: BorderStyle.solid,
                          width: 1),
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: // child: ImageIcon(
                            //  AssetImage('assets/marcericons/DriveNow.png'),
                            Icon(Icons.people),
                      ),
                      SizedBox(width: 10),
                      Center(
                        child: Text(
                          'Transfer to your friend',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat'),
                        ),
                      )
                    ],
                  ),
                )),
            Container(
                padding: const EdgeInsets.only(top: 10),
                width: double.maxFinite,
                height: 50,
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.black,
                          style: BorderStyle.solid,
                          width: 1),
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: // child: ImageIcon(
                            //  AssetImage('assets/marcericons/DriveNow.png'),
                            Image.asset('assets/brandIcons/paypal.png'),
                      ),
                      SizedBox(width: 10),
                      Center(
                        child: Text(
                          'Add to your Paypal',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat'),
                        ),
                      )
                    ],
                  ),
                )),
          ]),
        ),
      ),
    );
  }
}
