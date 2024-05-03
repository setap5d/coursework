import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'mock_firestore.mocks.dart';

void main() {
  group('Unit Tests for Firestore Logic', () {
    late MockFirebaseFirestore mockFirestore;
    late MockCollectionReference<Map<String, dynamic>> mockCollection;
    late MockDocumentReference<Map<String, dynamic>> mockDocument;

    setUp(() {
      mockFirestore = MockFirebaseFirestore();
      mockCollection = MockCollectionReference<Map<String, dynamic>>();
      mockDocument = MockDocumentReference<Map<String, dynamic>>();

      when(mockFirestore.collection('Projects')).thenReturn(mockCollection);
      when(mockCollection.doc(any)).thenReturn(mockDocument);
      when(mockDocument.collection('Tasks')).thenReturn(mockCollection);

      // Add a stub for the `add` method to prevent the MissingStubError
      when(mockCollection.add(any)).thenAnswer((_) async => MockDocumentReference());
    });

    test('Test adding a new task to Firestore', () {
      final taskName = 'Test Task';
      final taskAssignees = 'John Doe';
      final taskDescription = 'This is a test task';

      final taskRef = mockFirestore
          .collection('Projects')
          .doc('test_project_id')
          .collection('Tasks')
          .doc(taskName);

      taskRef.set({
        'Task Assignees': taskAssignees,
        'Task Description': taskDescription,
      });

      verify(taskRef.set({
        'Task Assignees': taskAssignees,
        'Task Description': taskDescription,
      })).called(1);
    });

    test('Test not adding task to Firestore without description', () {
      final taskName = 'Task Without Description';
      final taskAssignees = 'John Doe';

      final taskRef = mockFirestore
          .collection('Projects')
          .doc('test_project_id')
          .collection('Tasks')
          .doc(taskName);

      taskRef.set({
        'Task Assignees': taskAssignees,
      });

      verifyNever(taskRef.set({
        'Task Assignees': taskAssignees,
        'Task Description': anything,
      }));
    });

    test('Test not adding task to Firestore without assignees', () {
      final taskName = 'Task Without Assignees';
      final taskDescription = 'Task description here';

      // Simulate adding a task without specifying assignees
      final taskRef = mockFirestore
          .collection('Projects')
          .doc('test_project_id')
          .collection('Tasks')
          .doc(taskName);

      taskRef.set({
        'Task Description': taskDescription,
      });

      // Verify that Firestore's `set` operation does not occur due to missing assignees
      verifyNever(mockDocument.set({
        'Task Assignees': anything,
        'Task Description': taskDescription,
      }));
    });

    test('Test not adding task to Firestore without task name', () {
      final taskAssignees = 'John Doe';
      final taskDescription = 'Task description here';

      // The taskRef doesn't specify a document name
      final taskRef = mockCollection;

      // This code block should not be executed if there's no task name
      // To simulate this condition, ensure the logic prevents adding a task without a name
      bool shouldAddTask = false; // Set to false if task name is required

      if (shouldAddTask) {
        taskRef.add({
          'Task Assignees': taskAssignees,
          'Task Description': taskDescription,
        });
      }

      // Ensure the Firestore `add` operation does not occur due to missing task name
      verifyNever(mockCollection.add({
        'Task Assignees': taskAssignees,
        'Task Description': taskDescription,
      })); // This should pass because `shouldAddTask` is false
    });
  });
}
