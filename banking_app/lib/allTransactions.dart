import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class AllTransactions extends StatefulWidget {
  @override
  _AllTransactionsState createState() => _AllTransactionsState();
}

class _AllTransactionsState extends State<AllTransactions> {
  List<Map> transactions;
  bool loading = true;

  void getTransactions() async {
    var databasesPath = await getDatabasesPath();
    String path = databasesPath + 'banking.db';
    var database = await openDatabase(
      path,
      version: 1,
    );

    transactions = await database.rawQuery('SELECT * FROM Transactions');
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    getTransactions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'All Transactions',
          style: TextStyle(
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black87),
      ),
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              child: transactions.length == 0
                  ? Center(
                      child: Text(
                        "No transactions",
                        style: TextStyle(
                          color: Colors.black54,
                        ),
                      ),
                    )
                  : ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: transactions.length,
                      itemBuilder: (builder, index) {
                        var tr = transactions[transactions.length - index - 1];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            shadowColor: Colors.white70,
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'From',
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 13,
                                      ),
                                    ),
                                    Text(
                                      tr['Sender'],
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 8),
                                          height: 50,
                                          width: 1,
                                          color: Colors.black12,
                                        ),
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Rs. " +
                                                    tr['Amount']
                                                        .toStringAsFixed(2),
                                                style: TextStyle(
                                                    color: Colors.green,
                                                    fontSize: 30,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'To',
                                              style: TextStyle(
                                                color: Colors.black54,
                                                fontSize: 13,
                                              ),
                                            ),
                                            Text(
                                              tr['Recipient'],
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        Spacer(),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              tr['Date2'],
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              tr['Date1'],
                                              style: TextStyle(
                                                color: Colors.black54,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ]),
                            ),
                          ),
                        );
                      },
                    ),
            ),
    );
  }
}
