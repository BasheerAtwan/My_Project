import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class FormPage extends StatefulWidget {
  final String category;

  const FormPage({Key? key, required this.category}) : super(key: key);

  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  late DateTime currentDate;
  List<String> site = [
    'فرع البيادر',
    'تلاع العلي',
    'فرع الياسمين',
    'فرع وادي صقرة',
    'فرع الجبيهة',
    'فرع الوحدات',
    'فرع طبربور',
    'فرع الزرقاء',
    'فرع اربد',
    'مكتب شارع الحصن',
    'فرع العقبة',
    'مكتب مطار الملك الحسين',
    'فرع دابوق',
    'فرع الزرقاء الجديدة',
    ' شارع المطار',
    'مرج الحمام',
    'العبدلي مول',
    'مادبا',
    'السلط',
    'مطار الملكة علياء',
    'باب المدينة',
    'المفرق',
    'دوار الداخلية',
    'عبدون',
    'شارع مكة',
    'الكرك',
    'ستي مول',
    'تاج مول',
    'مكتب الفصول الاربعة',
    'زهران',
    'سحاب',
    'بيادر وادي السير',
    'شميساني'
  ];
  List<String> categories = [' صيانة', 'عمل غير امن', 'تطوير', 'تنظيف'];

  String? selectedSite;
  String? selectedCategory;
  String? selectedSubSite;

  List<Uint8List> _selectedImageBytesList = [];
  List<File> _selectedImageFileList = [];

  final TextEditingController titleController = TextEditingController();
  final TextEditingController ReporterController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  Map<String, List<String>> subSites = {
    'شارع مكة': ['الطابق الاول', 'الطابق الثاني','الطابق الثالث','الطابق الارضي','طابق B1','طابق B2','طابق B3'],
    'شميساني': ['الطابق الاول', 'الطابق الثاني','الطابق الثالث','الطابق الرابع','طابق B1','طابق B2'],
    'زهران': ['طابق P1', 'طابق P2','طابق P3','طابق P4','طابق P5','طابق P6','الطابق الارضي','الطابق الاول', 'الطابق الثاني','الطابق الثالث','الطابق الرابع', 'الطابق الخامس','الطابق السادس','الطابق السابع', 'الطابق الثامن','الطابق التاسع','الطابق العاشر', 'الطابق الحادي عشر','الطابق الثاني عشر','الطابق الثالث عشر','الطابق الرابع عشر',],
    'مطار الملكة علياء': ['المغادرة', 'الجوازات','الترانزيت','البوابة 1','مركز الطاقم','الجوازات 2','البوابة 2'],


  };

  @override
  void initState() {
    super.initState();
    currentDate = DateTime.now();
    selectedCategory = categories.first;
  }

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
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'التاريخ',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    DateFormat.yMMMMd('ar').format(currentDate),
                  ),

                  const SizedBox(height: 16),
                  buildDropdownBox(
                    labelText: 'التصنيف',
                    items: categories,
                    value: selectedCategory,
                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  buildDropdownBox(
                    labelText: 'الموقع الرئيسي',
                    items: site,
                    value: selectedSite,
                    onChanged: (value) {
                      setState(() {
                        selectedSite = value;
                        selectedSubSite = null; // Reset sub-site selection
                      });
                    },
                  ),

                  SizedBox(height: 16.0),
                  // Display sub-site dropdown only if a main site is selected
                  if (selectedSite != null && subSites.containsKey(selectedSite!))
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildDropdownBox(
                          labelText: 'الموقع الفرعي:',
                          items: subSites[selectedSite!]!,
                          value: selectedSubSite,
                          onChanged: (value) {
                            setState(() {
                              selectedSubSite = value;
                            });
                          },
                        ),

                      ],
                    ),
                  const SizedBox(height: 16),
                  buildTextBox(
                    child: TextFormField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: 'وصف الملاحظة',
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'أضف صورة او فيديو',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  buildPhotoArea(),
                  const SizedBox(height: 16),
                  buildTextBox(
                    child: TextFormField(
                      controller: ReporterController,
                      decoration: const InputDecoration(
                        labelText: 'من يكتب التقرير ؟',
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  buildTextBox(
                    child: TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: 'البريد الإلكتروني للتواصل',
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Color.fromARGB(255, 13, 19, 140))),
                    onPressed: isFormValid() ? _saveFormDataToFirebase : null,
                    child: const Text(
                      'ارسال',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextBox({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: child,
    );
  }

  Widget buildDropdownBox({
    required String labelText,
    required List<String> items,
    required String? value,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        items: items.map((item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: labelText,
        ),
      ),
    );
  }

  Widget buildPhotoArea() {
    return Column(
      children: [
        buildMediaGrid(_selectedImageBytesList),
        const SizedBox(height: 16),
        ElevatedButton(
          style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(
              Color.fromARGB(255, 13, 19, 140))),
          onPressed: () async {
            FilePickerResult? result = await FilePicker.platform.pickFiles(
              type: FileType.image,
              allowMultiple: true,
            );

            if (result != null && result.files.isNotEmpty) {
              setState(() {
                _selectedImageBytesList.addAll(
                    result.files.map((file) => file.bytes!));
              });
            }
          },
          child: Text(
            "تحميل الصور",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildMediaGrid(List<Uint8List> mediaList) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(mediaList.length, (index) {
        return Stack(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.memory(
                    mediaList[index],
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  bool isFormValid() {
    return selectedCategory!.isNotEmpty &&
        selectedSite != null &&
        titleController.text.isNotEmpty &&
        ReporterController.text.isNotEmpty &&
        _selectedImageBytesList.isNotEmpty;
  }

  Future<void> _saveFormDataToFirebase() async {
    try {
      List<String> imageUrls = await _uploadImagesToFirebase();

      Map<String, dynamic> data = {
        'selectedSite': selectedSite,
        'selectedCategory': selectedCategory,
        'selectedSubSite': selectedSubSite,
        'title': titleController.text,
        'reporter': ReporterController.text,
        'email': emailController.text,
        'date': Timestamp.fromDate(currentDate),
        'imageUrls': imageUrls,
      };

      await FirebaseFirestore.instance.collection('form_data').add(data);

      print('Form data saved to Firebase!');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم حفظ البيانات بنجاح'),
          duration: Duration(seconds: 2),
        ),
      );

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('شكراً لتقديم البيانات'),
            content: Text('هل ترغب في تقديم بيانات جديدة؟'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('لا'),
              ),
              TextButton(
                onPressed: () {
                  titleController.clear();
                  ReporterController.clear();
                  setState(() {
                    selectedCategory = categories.first;
                    selectedSite = null;
                    selectedSubSite = null;
                    _selectedImageBytesList.clear();
                  });
                  Navigator.of(context).pop();
                },
                child: Text('نعم'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      print('Error saving form data: $e');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('حدث خطأ أثناء حفظ البيانات'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<List<String>> _uploadImagesToFirebase() async {
    List<String> imageUrls = [];

    for (int i = 0; i < _selectedImageBytesList.length; i++) {
      String uniqueFileName = Uuid().v4();
      Reference referenceDirImages = FirebaseStorage.instance.ref().child('images');
      Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);

      try {
        String contentType = 'image/jpeg';
        await referenceImageToUpload.putData(
          _selectedImageBytesList[i],
          SettableMetadata(contentType: contentType),
        );

        String imageUrl = await referenceImageToUpload.getDownloadURL();
        imageUrls.add(imageUrl);
      } catch (error) {
        print('Error uploading image: $error');
      }
    }

    return imageUrls;
  }
}
