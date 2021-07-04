import 'package:banking_app/allCustomers.dart';
import 'package:banking_app/allTransactions.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Banking App',
      theme: ThemeData(
        primarySwatch: Colors.red
      ),
      home: MyHomePage(title: 'Online Banking App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({this.title});
  static List<Map> list;
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void dbase() async {
    var databasesPath = await getDatabasesPath();
    String path = databasesPath + 'banking.db';

    // await deleteDatabase(path);

    var database = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        db.execute(
          '''
          CREATE TABLE Users(          
            User_Name varchar(24),
            Email varchar(24),
            Phone_no character(13),
            Gender character(1),
            DOB varchar(24),
            Balance double
          );

          ''',
        );

        db.execute(
          '''
          CREATE TABLE Transactions(  
            Tr_id int auto_increment,        
            Sender varchar(24),
            Recipient varchar(24),
            Date1 varchar(24),
            Date2 varchar(24),
            Amount double,
            SenderB double,
            RecipientB double,
            PRIMARY KEY (Tr_id)
          );

          ''',
        );

        db.execute(''' 
          INSERT INTO Users(User_Name, Email, Gender, DOB, Phone_no, Balance) 
          VALUES 
          ("Lionel Messi", "lionelmessi@gmail.com", 'M', "24-08-1987",9187498372, 98456000), 
          ("Cristiano Ronaldo", "cristianoronaldo07@gmail.com", 'M', "5-02-1985", 8565488932, 5098737.32),
          ("Neymar", "neymarjr@gmail.com", 'M', "05-02-1992",776933156, 6783933773),
          ("Paul Pogba", "paulpogba@yahoo.com",'M', "15-033-1993", 6697553216, 98342100),
          ("MS Dhoni", "thalathefinisher07@gmail.com", 'M', "07-07-1981",7769883215, 45091817109),
          ("Nita Ambani", "nitaambani@gmail.com", 'F', "01-11-1963",7860274874, 9837462836787363772.00), 
          ("Virat Kohli", "chasingking18@gmail.com", 'M', "05-11-1998",03928475934, 90989748653634),
          ("AB de Villiers", "mr360@gmail.com", 'M', "17-02-1984",39329834134, 674581700),
          ("Sania Mirza", "saniamirza@yahoo.com", 'F', "15-11-1986",23094798375, 99372643.99),
          ("Serena Williams", "serenawilliams@gmail.com", 'F', "26-09-1981",2136383243, 125009876.5);  
        ''');

        print("Done..!!");
      },
    );

    MyHomePage.list = await database.rawQuery('SELECT * FROM Users');
  }

  @override
  void initState() {
    dbase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              widget.title,
              style: TextStyle(
                fontSize: 30,
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              'The one stop for all your banking..',
              style: TextStyle(
                fontSize: 17,
                color: Colors.black54,
                fontWeight: FontWeight.normal,
              ),
            ),
            Expanded(
              child: Image.asset("images/bank.png"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 5,
                shadowColor: Colors.white70,
                padding: EdgeInsets.all(15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AllCustomers(),
                  ),
                );
              },
              child: Container(
                width: MediaQuery.of(context).size.width * .8,
                child: Center(
                  child: Text('All Customers'),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 5,
                shadowColor: Colors.black,
                padding: EdgeInsets.all(15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AllTransactions(),
                  ),
                );
              },
              child:Container(
                width: MediaQuery.of(context).size.width * .8,
                child: Center(
                  child: Text('Transaction History'),
                ),
              ),
            ),
            SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }
}
