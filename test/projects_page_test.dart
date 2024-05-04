import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:setaplogin/project_format.dart';
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

      when(mockFirestore.collection('Projects')).thenReturn(mockCollection);
      when(mockCollection.doc(any)).thenReturn(mockDocument);
      when(mockDocument.collection('Tasks')).thenReturn(mockCollection);

      // Add a stub for the `add` method to prevent the MissingStubError
      when(mockCollection.add(any))
          .thenAnswer((_) async => MockDocumentReference());
    });

    // Tests

    test(
        'Test for adding a new project to Firebase (1.1)/Store Project Attributes (1.5)',
        () async {
      final projectName = 'Test Project';
      final projectLeader = 'John Doe';
      final deadline = '2024-05-05'; // Provide a valid deadline format

      // Call the function to add a new project
      await addProjectToFirestore(
          mockFirestore, projectName, projectLeader, deadline);

      // Verify that Firestore collection is updated with the new project
      verify(mockFirestore.collection('Projects')).called(1);
      verify(mockCollection.doc(captureAny)).called(1);
      verify(mockDocument.set({
        'Title': projectName,
        'Deadline': deadline,
        'Project Leader': projectLeader,
      })).called(1);
    });

    test('User can view multiple projects', () async {});

    test('Delete a Project (1.4)', () async {
      final projectId = 'test_project_id';

      // Call the function to delete the project
      await deleteProjectFromFirestore(mockFirestore, projectId);

      // Verify that the Firestore collection and document deletion methods are called
      verify(mockFirestore.collection('Projects')).called(1);
      verify(mockCollection.doc(projectId)).called(1);
      verify(mockDocument.delete()).called(1);
    });

    test('Users will be able to edit the name, deadline, and assignees (1.3)',
        () async {
      final projectId = 'test_project_id';
      final newName = 'New Project Name';
      final newDeadline = '2024-05-10';
      final newAssignees = ['user1', 'user2'];

      // Call the function to edit project details
      await editProjectDetails(
          mockFirestore, projectId, newName, newDeadline, newAssignees);

      // Verify that the Firestore document is updated with the new project details
      verify(mockFirestore.collection('Projects')).called(1);
      verify(mockCollection.doc(projectId)).called(1);
      verify(mockDocument.update({
        'Title': newName,
        'Deadline': newDeadline,
        'Assignees': newAssignees,
      })).called(1);
    });
  });
}

// Functions for Tets

Future<void> addProjectToFirestore(MockFirebaseFirestore firestore,
    String projectName, String projectLeader, String deadline) async {
  final projID = firestore.collection('Projects').doc();
  await projID.set({
    'Title': projectName,
    'Deadline': deadline,
    'Project Leader': projectLeader,
  });
}

Future<void> deleteProjectFromFirestore(
    MockFirebaseFirestore firestore, String projectId) async {
  // Get the reference to the project document
  final projectRef = firestore.collection('Projects').doc(projectId);
  // Delete the project document
  await projectRef.delete();
}

Future<void> editProjectDetails(
    MockFirebaseFirestore firestore,
    String projectId,
    String newName,
    String newDeadline,
    List<String> newAssignees) async {
  final projectRef = firestore.collection('Projects').doc(projectId);
  await projectRef.update({
    'Title': newName,
    'Deadline': newDeadline,
    'Assignees': newAssignees,
  });
}
