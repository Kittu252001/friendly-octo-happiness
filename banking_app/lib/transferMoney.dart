import 'package:banking_app/confirmDialog.dart';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sqflite/sqflite.dart';

import 'main.dart';

class TransferMoney extends StatefulWidget {
  final user, refresh;

  TransferMoney(this.user, this.refresh);

  @override
  _TransferMoneyState createState() => _TransferMoneyState();
}

class _TransferMoneyState extends State<TransferMoney> {
  var select = -1;
  var flag = 0;
  var amount = 0.0;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: flag == 0
          ? SizedBox(
              height: MediaQuery.of(context).size.height * .6,
              child: _selectRecipient(),
            )
          : SizedBox(
              height: 260,
              child: _makePayment(),
            ),
    );
  }

  Widget _selectRecipient() {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Row(
            children: [
              Text(
                'Select recipient',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black54),
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.close,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
        Divider(),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8),
          height: MediaQuery.of(context).size.height * .6 - 125,
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: 10,
            itemBuilder: (builder, index) {
              var temp = MyHomePage.list[index];
              if (temp['Email'] == widget.user['Email']) {
                return SizedBox();
              }
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            temp['User_Name'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                          Text(
                            temp['Email'],
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: select == index
                              ? Colors.green[400]
                              : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            select = index;
                          });
                        },
                        child: select == index
                            ? Container(
                                width: 38,
                                child: Icon(
                                  Icons.done_rounded,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                'Select',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 13,
                                ),
                              ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(
          height: 10,
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 5,
            shadowColor: Colors.blue[300],
            padding: EdgeInsets.all(13),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          onPressed: () {
            setState(() {
              if (select == -1) {
                Fluttertoast.showToast(
                  msg: "Please select recipient",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
              } else {
                flag = 1;
              }
            });
          },
          child: Container(
            width: 140,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Continue'),
                SizedBox(
                  width: 10,
                ),
                Icon(
                  Icons.arrow_forward_rounded,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  final _formKey = GlobalKey<FormState>();

  Widget _makePayment() {
    var recipient = MyHomePage.list[select];
    return Column(
      children: [
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Row(
            children: [
              Text(
                'Enter amount',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black54),
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.close,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
        Divider(),
        Row(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recipient :  ',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 13,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    recipient['User_Name'],
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
        Container(
          height: 55,
          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          padding: const EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.grey[200],
          ),
          child: Form(
            key: _formKey,
            child: TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                prefixText: 'Rs. ',
                prefixStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                hintText: 'Enter amount',
                hintStyle: TextStyle(color: Colors.black45),
                prefixIcon: Icon(
                  Icons.monetization_on,
                  color: Colors.blue,
                ),
                border: InputBorder.none,
              ),
              onChanged: (val) {
                setState(() {
                  if (val.isNotEmpty) {
                    amount = double.parse(val);
                  } else {
                    amount = 0;
                  }
                });
              },
              validator: (val) {
                setState(() {
                  amount = double.parse(val);
                });
                return null;
              },
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: () {
                setState(() {
                  flag = 0;
                });
              },
              child: Text('Back'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 5,
                shadowColor: Colors.blue[300],
                padding: EdgeInsets.all(13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {
                setState(() {
                  //_formKey.currentState.validate();
                  if (amount <= 0) {
                    Fluttertoast.showToast(
                      msg: "Invalid amount",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  } else if (amount >= (widget.user['Balance'] - 100)) {
                    Fluttertoast.showToast(
                      msg: "Insufficient balance",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  } else {
                    _transferAmount(widget.user);

                    showDialog(
                      context: context,
                      builder: (builder) {
                        return Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: SizedBox(
                            height: 80,
                            child: SpinKitFadingCircle(
                              color: Colors.black54,
                              size: 30,
                            ),
                          ),
                        );
                      },
                    );
                    Future.delayed(const Duration(milliseconds: 1000), () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      widget.refresh();
                      showDialog(
                        context: context,
                        builder: (builder) {
                          return ConfirmDialog(
                            amount: amount,
                            recipient: MyHomePage.list[select]['User_Name'],
                          );
                        },
                      );
                    });
                  }
                });
              },
              child: Container(
                width: 140,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Send money'),
                    SizedBox(
                      width: 5,
                    ),
                    Icon(
                      Icons.arrow_forward_rounded,
                    ),
                  ],
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  Future<void> _transferAmount(user) async {
    var databasesPath = await getDatabasesPath();
    String path = databasesPath + 'banking.db';
    var database = await openDatabase(
      path,
      version: 1,
    );

    var userList = await database.rawQuery('SELECT * FROM Users');

    // DATE & TIME
    var minute = DateTime.now().minute.toString();
    var hh = DateTime.now().hour >= 12
        ? DateTime.now().hour - 12
        : DateTime.now().hour;
    hh = hh == 0 ? 12 : hh;
    var gg = DateTime.now().hour >= 12 ? 'pm' : 'am';
    var date = DateTime.now().toString().split(" ")[0];
    print(date + " 000 " + hh.toString() + " : " + minute + " " + gg);

    // BALANCE
    amount = double.parse(amount.toStringAsFixed(2));
    var senderBalance = user['Balance'] - amount;
    var recipientBalance = userList[select]['Balance'] + amount;

    print(user['User_Name']);
    database.rawInsert(
      ''' 
      INSERT INTO Transactions (Sender, Recipient, Date1, Date2, Amount, SenderB, RecipientB) 
      VALUES 
      (\"${user['User_Name']}\", \"${userList[select]['User_Name']}\",\"$date\", \"${hh.toString() + " : " + minute + " " + gg}\", $amount, $senderBalance, $recipientBalance) 
      ''',
    );

    database.rawUpdate(
      ''' 
      UPDATE Users 
      SET Balance = $senderBalance 
      WHERE Email = \"${user['Email']}\" 
      ''',
    );

    database.execute(
      ''' 
      UPDATE Users 
      SET Balance = $recipientBalance 
      WHERE Email = \"${userList[select]['Email']}\" 
      ''',
    );
  }
}
