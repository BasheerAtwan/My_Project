import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ReviewPage extends StatelessWidget {
  final String documentId;

  ReviewPage({required this.documentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Review Page'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'تفاصيل المشروع',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.0),
            // Display data using StreamBuilder
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance.collection('form_data').doc(documentId).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.data() == null) {
                  return Center(child: Text('No data available'));
                }

                var data = snapshot.data!.data() as Map<String, dynamic>;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildDataCard(title: 'Reporter', value: data['reporter']),
                    buildDataCard(title: 'Priority', value: data['selectedStatus']),
                    buildDataCard(title: 'Location', value: data['selectedSite']),
                    buildDataCard(title: 'Date', value: data['date']),
                    buildDataCard(title: 'Description', value: data['title']),
                    buildDataCard(title: 'Category', value: data['selectedCategory']),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDataCard({required String title, required dynamic value}) {
    String displayValue = '';

    if (value is Timestamp) {
      // Convert Timestamp to DateTime and then to a formatted string
      DateTime dateTime = value.toDate();
      displayValue = DateFormat.yMd().format(dateTime);
    } else {
      // If it's not a Timestamp, treat it as a regular value
      displayValue = value ?? 'N/A';
    }

    return Card(
      elevation: 4.0,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
            ),
            SizedBox(height: 8.0),
            Text(
              displayValue,
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}
