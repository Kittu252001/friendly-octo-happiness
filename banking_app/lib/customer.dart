import 'package:banking_app/myTransactions.dart';
import 'package:banking_app/transferMoney.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class Customer extends StatefulWidget {
  final ref;
  const Customer(this.ref);

  static bool loading = true;

  @override
  _CustomerState createState() => _CustomerState();
}

class _CustomerState extends State<Customer> {
  
  List<Map> user;
  void getData() async {
    var databasesPath = await getDatabasesPath();
    String path = databasesPath + 'banking.db';

    var database = await openDatabase(
      path,
      version: 1,
    );
    user = await database.rawQuery(
        'SELECT * FROM Users WHERE Phone_no == ${widget.ref['Phone_no']}');
    print(user[0]['User_Name']);
    setState(() {
      Customer.loading = false;
    });
  }

  void refresh(){
    setState(() {
      Customer.loading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (Customer.loading) {
      getData();
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Customer Info',
          style: TextStyle(
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black87),
      ),
      body: Customer.loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 30,
                    child: Image.asset(user[0]['Gender'] == "M"
                        ? 'images/man.png'
                        : 'images/woman.png'),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        user[0]['User_Name'].split(" ")[0],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                      Text(
                        " " + user[0]['User_Name'].split(" ")[1],
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 30,
                            color: Colors.black54),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.email_outlined,
                        size: 17,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        user[0]['Email'],
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.phone,
                        size: 17,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        user[0]['Phone_no'],
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_rounded,
                        size: 17,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        user[0]['DOB'].toString(),
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    "Total balance :",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                  Text(
                    "Rs. " + user[0]['Balance'].toStringAsFixed(2),
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          elevation: 5,
                          shadowColor: Colors.white70,
                          padding: EdgeInsets.all(17),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {
                          showModalBottomSheet(
                            backgroundColor: Colors.transparent,
                            context: context,
                            builder: (builder) {
                              return MyTransactions(user[0]);
                            },
                          );
                        },
                        child: Text(
                          'My Transactions',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue,
                          elevation: 5,
                          shadowColor: Colors.blue[300],
                          padding: EdgeInsets.all(13),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (builder) {
                              return TransferMoney(user[0], refresh);
                            },
                          );
                        },
                        child: Container(
                          width: 160,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Transfer Money'),
                              SizedBox(
                                width: 20,
                              ),
                              Icon(
                                Icons.arrow_forward_rounded,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  
}
