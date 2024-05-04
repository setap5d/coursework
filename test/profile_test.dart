import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'mock_firestore.mocks.dart';

void main() {
  group('Testing for Projects Requirements', () {
    late MockFirebaseFirestore mockFirestore;
    late MockCollectionReference<Map<String, dynamic>> mockCollection;
    late MockDocumentReference<Map<String, dynamic>> mockDocument;

    // Mock Firebase Setup
    setUp(() {
      mockFirestore = MockFirebaseFirestore();
      mockCollection = MockCollectionReference<Map<String, dynamic>>();
      mockDocument = MockDocumentReference<Map<String, dynamic>>();

      when(mockFirestore.collection('Profiles')).thenReturn(mockCollection);
      when(mockCollection.doc(any)).thenReturn(mockDocument);

      // Add a stub for the `update` method to prevent the MissingStubError
      when(mockDocument.update(any)).thenAnswer((_) async => null);
    });

    // Test

    test(
        'Users will be able to change profile data related to their account in app (5.4)',
        () async {
      final email = 'test@example.com';

      // Call the function to check inputs
      checkInputs(
          mockFirestore, 'NewFirstName', 'NewLastName', email, '', 'NewSkills');

      // Verify that Firestore is updated with the new profile data
      verify(mockFirestore.collection('Profiles')).called(1);
      verify(mockCollection.doc(email.toLowerCase())).called(1);
      verify(mockDocument.update({
        'First Name': 'NewFirstName',
        'Last Name': 'NewLastName',
        'Phone Number': '',
        'Skills': 'NewSkills',
      })).called(1);
    });
  });
}

// Function for Tests

void checkInputs(FirebaseFirestore db, String fName, String lName, String email,
    String phoneNumber, String skills) {
  db.collection('Profiles').doc(email.toLowerCase()).update({
    "First Name": fName,
    "Last Name": lName,
    "Phone Number": phoneNumber,
    "Skills": skills
  });
}
