import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String fName = '';
  String lName = '';
  String email = '';
  String phoneNumber = '';
  String skills = '';
  String errMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              // 16:9 resolution
              width: MediaQuery.of(context).size.width * 0.075 * 0.9,
              height: MediaQuery.of(context).size.height * 0.075 * 1.6,
              child: Icon(Icons.person, size: 75, color: Colors.grey),
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.1 * 0.9),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      height: 64,
                      width: MediaQuery.of(context).size.width * 0.3 * 0.9,
                      padding: EdgeInsets.only(right: 16),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'First Name',
                          border: OutlineInputBorder(),
                        ),
                        // inputFormatters: [
                        //   FilteringTextInputFormatter.deny(
                        //     RegExp(
                        //         r"^[\w'\-,.][^0-9_!¡?÷?¿/\\+=@#$%ˆ&*(){}|~<>;:[\]]{70,}$"),
                        //   ),
                        // ],
                        onChanged: (value) {
                          setState(() {
                            fName = value;
                          });
                        },
                      ),
                    ),
                    Container(
                      height: 64,
                      width: MediaQuery.of(context).size.width * 0.3 * 0.9,
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Last Name',
                          border: OutlineInputBorder(),
                        ),
                        // inputFormatters: [
                        //   FilteringTextInputFormatter.deny(
                        //     RegExp(
                        //         r"^[\w'\-,.][^0-9_!¡?÷?¿/\\+=@#$%ˆ&*(){}|~<>;:[\]]{70,}$"),
                        //   ),
                        // ],
                        onChanged: (value) {
                          setState(() {
                            lName = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Container(
                  height: 64,
                  width: MediaQuery.of(context).size.width * 0.6 * 0.9,
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'E-Mail Address',
                      border: OutlineInputBorder(),
                    ),
                    // inputFormatters: [
                    //   FilteringTextInputFormatter.deny(
                    //     RegExp(
                    //         r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?"),
                    //     // NOT WORKING FIX THIS
                    //   ),
                    // ],
                    onChanged: (value) {
                      setState(() {
                        email = value;
                      });
                    },
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  height: 64,
                  width: MediaQuery.of(context).size.width * 0.6 * 0.9,
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    // inputFormatters: [
                    //   FilteringTextInputFormatter.allow(
                    //     RegExp(r"^([0-9\(\)\/\+ \-]*)$"),
                    //   ),
                    // ],
                    onChanged: (value) {
                      setState(() {
                        phoneNumber = value;
                        // Exception here when trying to type a non number or too many numbers
                      });
                    },
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  height: 100,
                  width: MediaQuery.of(context).size.width * 0.6 * 0.9,
                  child: TextFormField(
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
                SizedBox(height: 16),
                Text(
                  errMessage,
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  child: Text('Save Changes'),
                  onPressed: () {
                    checkInputs(fName, lName, email, phoneNumber, skills);
                  },
                ),
                SizedBox(height: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void checkInputs(String fName, String lName, String email, String phoneNumber,
      String skills) {
    print('#' * 40);
    errMessage = '';
    checkName(fName, lName);
    checkEmail(email);
    checkPhoneNumber(phoneNumber);
    checkSkills(skills);

    // query db here if all checks pass. otherwise show user error message
  }

  void checkName(String fName, String lName) {
    if ((fName.length >= 2 && fName.length <= 20) &&
        (lName.length >= 2 && lName.length <= 20)) {
      print("Success! First and last name is between 2 and 20 characters.");
    } else {
      errMessage =
          'Error! First or last name is not between 2 and 20 characters.';
    }
  }

  void checkEmail(String email) {
    if (email.contains('@') && email.contains('.')) {
      print('Success! Email contains @ and .');
    } else {
      errMessage = 'Error! Email does not contain @ and .';
    }
  }

  void checkPhoneNumber(String phoneNumber) {
    if (phoneNumber.length == 10) {
      print('Success! Phone number is 10 digits long.');
    } else {
      errMessage = 'Error! Phone number is not 10 digits long.';
    }
  }

  void checkSkills(String skills) {
    if (skills.length >= 10 && skills.length <= 100) {
      print('Success! Skills are between 10 and 100 characters.');
    } else {
      errMessage = 'Error! Skills are not between 10 and 100 characters.';
    }
  }
}

/*

NAME VALIDATION: https://stackoverflow.com/questions/2385701/regular-expression-for-first-and-last-name

EMAIL VALIDATION: https://stackoverflow.com/questions/16800540/how-should-i-check-if-the-input-is-an-email-address-in-flutter


TO ASK: RegExp or function check?

Look at regular expressions comments, can be removed if checking is done in 
in backend or checkInput functions

*/