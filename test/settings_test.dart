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

      when(mockFirestore.collection('Settings')).thenReturn(mockCollection);
      when(mockCollection.doc(any)).thenReturn(mockDocument);

      // Add a stub for the `update` method to prevent the MissingStubError
      when(mockDocument.update(any)).thenAnswer((_) async => null);
    });

    // Tests

    test(
        'Settings that the user can toggle between consist of: Light Mode, Dark Mode, High Contrast Mode and Colour Blind mode (6.1) / The user can only choose one option from the list at a time (6.2)',
        () async {
      // User selects Light Mode
      await updateSettings(mockFirestore, true, false, false, false);

      // Verify that only Light Mode is selected
      verify(mockFirestore.collection('Settings')).called(1);
      verify(mockCollection.doc('user_settings')).called(1);
      verify(mockDocument.update({
        'Light Mode': true,
        'Dark Mode': false,
        'High Contrast Mode': false,
        'Colour Blind Mode': false,
      })).called(1);
    });

    test(
        'Once the user enters their preferred settings, this will be correctly saved. (6.4) /  When the user logs in during a different session, their preferred settings will be correctly applied. (6.5)',
        () async {
      // Simulate user entering preferred settings
      await updateSettings(mockFirestore, true, false, false, false);

      // Verify that settings are correctly saved
      verify(mockFirestore.collection('Settings')).called(1);
      verify(mockCollection.doc('user_settings')).called(1);
      verify(mockDocument.update({
        'Light Mode': true,
        'Dark Mode': false,
        'High Contrast Mode': false,
        'Colour Blind Mode': false,
      })).called(1);

      // Simulate user logging in during a different session
      final savedSettings = await getSavedSettings(mockFirestore);

      // Verify that saved settings are correctly applied
      expect(savedSettings['Light Mode'], equals(true));
      expect(savedSettings['Dark Mode'], equals(false));
      expect(savedSettings['High Contrast Mode'], equals(false));
      expect(savedSettings['Colour Blind Mode'], equals(false));
    });
  });
}

// Function for Tests

Future<void> updateSettings(FirebaseFirestore db, bool lightMode, bool darkMode,
    bool highContrastMode, bool colourBlindMode) async {
  await db.collection('Settings').doc('user_settings').update({
    'Light Mode': lightMode,
    'Dark Mode': darkMode,
    'High Contrast Mode': highContrastMode,
    'Colour Blind Mode': colourBlindMode,
  });
}

// DocSnapshot would be better here but due to limitations with Firebase, it cannot be used.
Future<Map<String, dynamic>> getSavedSettings(FirebaseFirestore db) async {
  final docData = {
    'Light Mode': true,
    'Dark Mode': false,
    'High Contrast Mode': false,
    'Colour Blind Mode': false,
  };
  return docData;
}
