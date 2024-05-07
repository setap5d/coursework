import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

/// Creates [_ProfilePageState]
///
/// Has attributes [email], [profDetails]
///
class ProfilePage extends StatefulWidget {
  const ProfilePage(
      {required this.email, required this.profDetails, super.key});
  final String email;
  final List<dynamic> profDetails;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

/// Builds widgets to allow user to edit account information stored in Firebase
///
/// Defines methods: [uploadImage], [selectImage], [checkInputs], [isValidName], [isValidEmail], [isValidPhoneNumber], [isValidSkills], [initState]
class _ProfilePageState extends State<ProfilePage> {
  String fName = '';
  String lName = '';
  String email = '';
  String phoneNumber = '';
  String skills = '';
  String errMessage = '';
  PlatformFile? selectedImage;
  UploadTask? uploadTask;
  late String urlDownload = "";
  bool newImage = false;

  Future uploadImage() async {
    final path = 'files/${selectedImage!.name}';
    final file = File(selectedImage!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);
    setState(() {
      uploadTask = ref.putFile(file);
    });

    final snapshot = await uploadTask!.whenComplete(() {});

    urlDownload = await snapshot.ref.getDownloadURL();

    setState(() {
      uploadTask = null;
      newImage = true;
    });
  }

  Future selectImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    if (result == null) return;

    setState(() {
      selectedImage = result.files.first;
    });
  }

  void checkInputs(String fName, String lName, String email, String phoneNumber,
      String skills) {
    FirebaseFirestore db = FirebaseFirestore.instance;
    setState(() {
      errMessage = '';
      if (isValidName(fName, lName) == true &&
          isValidEmail(email) == true &&
          isValidPhoneNumber(phoneNumber) == true &&
          isValidSkills(skills) == true) {
        DocumentReference profileRef =
            db.collection('Profiles').doc(email.toLowerCase());
        profileRef.update({
          "First Name": fName,
          "Last Name": lName,
          "Phone Number": phoneNumber,
          "Skills": skills
        });
        if (newImage == true) {
          DocumentReference pfpRef = db
              .collection('Profiles')
              .doc(
                  email) 
              .collection('User')
              .doc('ProfilePic');
          pfpRef.update({"Download URL": urlDownload});
        }
      } else {}
    });
  }

  bool isValidName(String fName, String lName) {
    if (fName.isEmpty || lName.isEmpty) {
      errMessage = 'Error: First and last name required';
      return false;
    }

    if (!RegExp(r'^[a-zA-Z]+$').hasMatch(fName) ||
        !RegExp(r'^[a-zA-Z]+$').hasMatch(lName)) {
      errMessage = 'Error: First and last name may only contain letters (A-Z)';
      return false;
    }

    if (!(fName.length >= 2 && fName.length <= 20) ||
        !(lName.length >= 2 && lName.length <= 20)) {
      errMessage =
          'Error: First or last name must be between 2 and 20 characters';
      return false;
    }

    return true;
  }

  bool isValidEmail(String email) {
    if (email.isEmpty) {
      errMessage = 'Error: Email required';
      return false;
    }

    // Check for the presence of '@' and '.'
    if (!email.contains('@') || !email.contains('.')) {
      errMessage = 'Error: Email must contain @ and .';
      return false;
    }

    // Check that '@' comes before '.'
    if (email.indexOf('@') > email.lastIndexOf('.')) {
      errMessage = 'Error: Email is invalid';
      return false;
    }

    // Check that there's at least one character before and after '@'
    if (email.indexOf('@') == 0 || email.indexOf('@') == email.length - 1) {
      errMessage = 'Error: Email is invalid';
      return false;
    }

    return true;
  }

  bool isValidPhoneNumber(String phoneNumber) {
    // Check if the numeric phone number has at least 10 digits (adjust as needed)
    if (phoneNumber.isNotEmpty) {
      if (!phoneNumber.contains(RegExp(r'^[0-9]+$'))) {
        errMessage = 'Error: Phone number may only contain numbers';
        return false;
      }
      if (phoneNumber.length < 10) {
        errMessage = 'Error: Phone number must be at least 10 digits';
        return false;
      }
    }
    return true;
  }

  bool isValidSkills(String skills) {
    if (!(skills.length >= 10 && skills.length <= 100)) {
      errMessage = 'Error: Skills are not between 10 and 100 characters';
      return false;
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    fName = widget.profDetails[0];
    lName = widget.profDetails[1];
    email = widget.profDetails[2];
    phoneNumber = widget.profDetails[3];
    skills = widget.profDetails[4];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        automaticallyImplyLeading: false,
        title: const Text('Profile'),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: MediaQuery.of(context).size.width * 0.1 * 0.9),
          SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    'Manage your profile settings here',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: SizedBox(
                    // 16:9 resolution
                    width: MediaQuery.of(context).size.width * 0.075 * 0.9,
                    height: MediaQuery.of(context).size.height * 0.075 * 1.6,
                    child: Expanded(
                      child: Container(
                        color: Colors.blue[50],
                        child: Center(
                          child: selectedImage != null
                              ? Image.file(File(selectedImage!.path!))
                              : const Icon(Icons.person, size: 48),
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0, right: 8.0),
                      child: ElevatedButton(
                        onPressed: selectImage,
                        child: const Text('Select Image'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: ElevatedButton(
                        onPressed: uploadImage,
                        child: const Text('Upload Image'),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      height: 48,
                      width: MediaQuery.of(context).size.width * 0.30,
                      padding: const EdgeInsets.only(right: 16),
                      child: TextFormField(
                        initialValue: fName,
                        decoration: const InputDecoration(
                          labelText: 'First Name',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          setState(() {
                            fName = value;
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      height: 48,
                      width: MediaQuery.of(context).size.width * 0.30,
                      child: TextFormField(
                        initialValue: lName,
                        decoration: const InputDecoration(
                          labelText: 'Last Name',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          setState(() {
                            lName = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 48,
                  width: MediaQuery.of(context).size.width * 0.60,
                  child: TextFormField(
                    initialValue: email,
                    decoration: const InputDecoration(
                      labelText: 'E-Mail Address',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        email = value;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 48,
                  width: MediaQuery.of(context).size.width * 0.60,
                  child: TextFormField(
                    initialValue: phoneNumber,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number (Optional)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        phoneNumber = value;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 96,
                  width: MediaQuery.of(context).size.width * 0.60,
                  child: TextFormField(
                    initialValue: skills,
                    minLines: 1,
                    maxLines: 6,
                    decoration: const InputDecoration(
                      labelText: 'Skills',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        skills = value;
                      });
                    },
                  ),
                ),
                Text(
                  errMessage,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  child: const Text('Save Changes'),
                  onPressed: () {
                    checkInputs(fName, lName, email, phoneNumber, skills);
                  },
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
