import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class MyTransactions extends StatefulWidget {
  final user;
  const MyTransactions(this.user);

  @override
  _MyTransactionsState createState() => _MyTransactionsState();
}

class _MyTransactionsState extends State<MyTransactions> {
  bool loading = true;
  List<Map> tr;

  void getTransactions(name) async {
    var databasesPath = await getDatabasesPath();
    String path = databasesPath + 'banking.db';
    var database = await openDatabase(
      path,
      version: 1,
    );

    tr = await database.rawQuery(
        'SELECT * FROM Transactions WHERE Sender = \"$name\" OR Recipient = \"$name\"');
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      getTransactions(widget.user['User_Name']);
    }
    return Container(
      padding: EdgeInsetsDirectional.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
      ),
      child: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15.0,
                  ),
                  child: Row(
                    children: [
                      Text(
                        'My Transactions',
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
                tr.length == 0
                    ? Expanded(
                        child: Center(
                          child: Text(
                            "No Transactions",
                            style: TextStyle(
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      )
                    : Expanded(
                        child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: tr.length,
                          itemBuilder: (builder, index) {
                            var tr1 = tr[tr.length - index - 1];
                            var flag = tr1['Sender'] == widget.user['User_Name']
                                ? true
                                : false;
                            var sent = flag ? Colors.red : Colors.green;
                            return Card(
                              elevation: 5,
                              shadowColor: Colors.white54,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          tr1[flag ? 'Recipient' : 'Sender'],
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          tr1['Date1'] + ' , ' + tr1['Date2'],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                            color: Colors.black38,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              '${flag ? '-' : '+'} ' +
                                                  tr1['Amount'].toStringAsFixed(2),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 25,
                                                color: sent,
                                              ),
                                            ),
                                            Text(
                                              ' Rs.',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                                color: sent,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 5,),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              'Balance : ',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                                color: Colors.black54,
                                              ),
                                            ),
                                            SizedBox(width: 5,),
                                            Text(
                                              tr1[flag ? 'SenderB' : 'RecipientB'].toStringAsFixed(2),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
              ],
            ),
    );
  }
}
