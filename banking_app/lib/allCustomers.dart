import 'package:banking_app/main.dart';
import 'package:flutter/material.dart';

import 'customer.dart';

class AllCustomers extends StatefulWidget {
  @override
  _AllCustomersState createState() => _AllCustomersState();
}

class _AllCustomersState extends State<AllCustomers> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'All Cutomers',
          style: TextStyle(
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black87),
      ),
      body: ListView.builder(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.only(bottom: 70),
        itemCount: 10,
        itemBuilder: (context, index) {
          var user = MyHomePage.list[index];
          return Padding(
            padding: const EdgeInsets.all(5.0),
            child: Card(
              shadowColor: Colors.white60,
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 0,
                    ),
                    Container(
                      height: 60,
                      child: Image.asset(user['Gender'] == "M"
                          ? 'images/man.png'
                          : 'images/woman.png'),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user['User_Name'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          user['Email'],
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    Card(
                      elevation: 0,
                      color: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: IconButton(
                        onPressed: () {
                          Customer.loading = true;
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => Customer(user),
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ignore: unused_element
  void _transferMoney(user) {
    showDialog(
      context: context,
      builder: (builder) {
        // ignore: unused_local_variable
        var amount = 0.0;
        return Dialog(
          child: Column(
            children: [
              Text(
                'Tranfer money',
              ),
              Text(
                user['User_Name'],
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                onChanged: (val) {
                  setState(() {
                    amount = double.parse(val);
                  });
                },
              ),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (builder) {
                      return Dialog(
                        child: Column(
                          children: [
                            ElevatedButton(
                              child: Text("Confirm"),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.all(15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: Text('Transfer'),
              )
            ],
          ),
        );
      },
    );
  }
}
