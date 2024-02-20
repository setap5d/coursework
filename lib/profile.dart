import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String name = '';
  String email = '';
  int phoneNumber = 0;
  String skills = '';

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
                Container(
                  height: 64,
                  width: MediaQuery.of(context).size.width * 0.6 * 0.9,
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(
                        RegExp(
                            r"^[\w'\-,.][^0-9_!¡?÷?¿/\\+=@#$%ˆ&*(){}|~<>;:[\]]{70,}$"),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        name = value;
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
                      labelText: 'E-Mail Address',
                      border: OutlineInputBorder(),
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(
                        RegExp(
                            r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?"),
                        // NOT WORKING FIX THIS
                      ),
                    ],
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
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r"^([0-9\(\)\/\+ \-]*)$"),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        phoneNumber = int.parse(value);
                        // Exception here when trying to type a non number or too many numbers
                      });
                    },
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  height: 128,
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
                ElevatedButton(
                  child: Text('Save Changes'),
                  onPressed: () {
                    setState(() {
                      name = 'John Doe';
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}



/*

NAME VALIDATION: https://stackoverflow.com/questions/2385701/regular-expression-for-first-and-last-name

EMAIL VALIDATION: https://stackoverflow.com/questions/16800540/how-should-i-check-if-the-input-is-an-email-address-in-flutter


*/