import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'ReviewPage.dart';

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  TextEditingController _searchController = TextEditingController();
  Map<String, String> statusMap = {
    'normal': 'عادي',
    'medium': 'متوسط',
    'high': 'عالي',
  };
  Map<String, String> selectedStatus = {};
  late String downloadURL; // Variable to store the download URL
  Future<void> downloadURLExample() async {
    downloadURL = await FirebaseStorage.instance
        .ref()
        .child("images") // Specify the path to your image in Firebase Storage
        .getDownloadURL();
    debugPrint(downloadURL.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('form_data').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          var filteredData = snapshot.data!.docs.where((document) {
            final Map<String, dynamic> data = document.data() as Map<String, dynamic>;
            return data['reporter'].toString().contains(_searchController.text);
          }).toList();

          return Column(
            children: [
              SizedBox(height: 50,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 300.0, vertical: 4.0),
                child: Container(
                  height: 40.0,
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {}); // Rebuild the UI when the text changes
                    },
                    decoration: InputDecoration(
                      hintText: 'ابحث هنا...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 50),
              Text(
                'الملاحظات',
                style: TextStyle(
                  color: Color.fromARGB(255, 0, 5, 5),
                  fontSize: 30,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.grey,
                  decorationThickness: 2,
                ),
              ),
              SizedBox(height: 20,),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columnSpacing: 55.0,
                    headingRowColor: MaterialStateColor.resolveWith((states) => Colors.grey[200]!),
                    dataRowColor: MaterialStateColor.resolveWith((states) => Colors.white),
                    columns: [
                      DataColumn(label: Text('حذف', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('الصور', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('كاتب التقرير', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('الأولوية', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('الموقع', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('التاريخ', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('وصف الملاحظة', style: TextStyle(fontWeight: FontWeight.bold))), // New column
                      DataColumn(label: Text(' التصنيف', style: TextStyle(fontWeight: FontWeight.bold))),

                    ],
                    rows: filteredData.map<DataRow>((document) {
                      final Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                      List<String> imageUrls = List<String>.from(data['imageUrls']);

                      return DataRow(
                        cells: [
                          DataCell(
                            Checkbox(
                              value: false,
                              onChanged: (bool? value) {
                                if (value!) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("تأكيد الحذف"),
                                        content: Text("هل أنت متأكد أنك تريد حذف هذا العنصر؟"),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text("لا"),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              FirebaseFirestore.instance.collection('form_data').doc(document.id).delete();
                                              Navigator.of(context).pop();
                                            },
                                            child: Text("نعم"),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              },
                            ),
                          ),
                          DataCell(
                            IconButton(
                              icon: Icon(Icons.image),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ImagePage(imageUrls: imageUrls),
                                  ),
                                );
                              },
                            ),
                          ),
                          DataCell(
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ReviewPage(documentId: document.id),
                                  ),
                                );
                              },
                              child: Text(data['reporter']),
                            ),
                          ),
                          DataCell(
                            DropdownButton<String>(
                              items: statusMap.keys.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(statusMap[value]!),
                                );
                              }).toList(),
                              value: selectedStatus[data['reporter']] ?? 'normal',
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedStatus[data['reporter']] = newValue!;
                                });
                              },
                            ),
                          ),
                          DataCell(Text(data['selectedSite'])),
                          DataCell(Text(DateFormat.yMd('ar').format(data['date'].toDate()))),
                          DataCell(Text(data['title'] ?? 'لا يوجد ملاحظة')),
                          DataCell(Text(data['selectedCategory'])),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          );
        },
      ),

      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 50.0,
          child: Center(
            child: Text(
              '© 2024 alhandasiya. All rights reserved.',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12.0,
              ),
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight),
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20.0),
        ),
        child: AppBar(
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'image/logo.png', // Replace 'assets/logo.png' with your logo asset path
                fit: BoxFit.contain,
                height: 32, // Adjust the height as needed
              ),
              SizedBox(width: 8), // Add spacing between logo and title if needed
              Text(
                'بنك الاستثمار العربي الاردني',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          backgroundColor: Colors.black38.withOpacity(0.5),
          elevation: 0,
        ),
      ),
    );
  }
}

class ImagePage extends StatelessWidget {
  final List<String> imageUrls;

  ImagePage({required this.imageUrls});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Images'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: imageUrls.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              // Handle image tap if needed
              _previewImage(context, imageUrls[index]);
            },
            child: CachedNetworkImage(
              imageUrl: imageUrls[index],
              fit: BoxFit.cover,
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          );
        },
      ),
    );
  }
  void _previewImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: SizedBox(
            width: 300,
            height: 300,
            child: FutureBuilder(
              future: loadImage(imageUrl),
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  print('Error loading image: ${snapshot.error}');
                  return Container(
                    color: Colors.grey[300],
                    child: Center(
                      child: Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 48.0,
                      ),
                    ),
                  );
                } else {
                  return Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }

  Future<bool> loadImage(String imageUrl) async {
    try {
      await NetworkImage(imageUrl).resolve(ImageConfiguration());
      return true;
    } catch (e) {
      // Handle the error, you can log it or return false
      print('Error loading image: $e');
      return false;
    }
  }
}
