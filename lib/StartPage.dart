import 'package:flutter/material.dart';
import 'FormPage.dart';

class StartPage extends StatelessWidget {
  final List<Map<String, String>> categories = [
    {'name': 'صيانة', 'image': 'image/maintenance.png'},
    {'name': 'تنظيف', 'image': 'image/cleaning.png'},
    {'name': 'عمل غير امن', 'image': 'image/unsafe_Work.png'},
    {'name': 'ملاحظة تحسينية', 'image': 'image/idea.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'image/logo.png',
              width: 70,
              height: 100,
            ),
            const Expanded(
              child: Center(
                child: Text(
                  'البنك الاستثماري الاردني',
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        children: List.generate(categories.length, (index) {
          return InkWell(
            onTap: () {
              // Navigate to FormPage with a constant category
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FormPage(category: '',),
                ),
              );
            },
            child: Card(
              elevation: 10,
              margin: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    categories[index]['image']!,
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 10),
                  Text(
                    categories[index]['name']!,
                    style: TextStyle(
                      fontSize: 18, // Set font size to 18
                      fontWeight: FontWeight.bold, // Make text bold
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
