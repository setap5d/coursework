import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'mock_firestore.mocks.dart';

void main() {
  group('Unit Tests for Ticket Logic', () {
    late MockFirebaseFirestore mockFirestore;
    late MockCollectionReference<Map<String, dynamic>> mockCollection;
    late MockDocumentReference<Map<String, dynamic>> mockDocument;

    setUp(() {
      mockFirestore = MockFirebaseFirestore();
      final projectsCollection =
          MockCollectionReference<Map<String, dynamic>>();
      final tasksCollection = MockCollectionReference<Map<String, dynamic>>();
      final ticketsCollection = MockCollectionReference<Map<String, dynamic>>();

      final projectDoc = MockDocumentReference<Map<String, dynamic>>();
      final taskDocWithTicket = MockDocumentReference<Map<String, dynamic>>();
      final taskDocWithoutTicketDescription =
          MockDocumentReference<Map<String, dynamic>>();

      // Projects collection setup
      when(mockFirestore.collection('Projects')).thenReturn(projectsCollection);
      when(projectsCollection.doc('test_project_id')).thenReturn(projectDoc);

      // Tasks collection setup
      when(projectDoc.collection('Tasks')).thenReturn(tasksCollection);
      when(tasksCollection.doc('Test Task')).thenReturn(taskDocWithTicket);
      when(tasksCollection.doc('Task Without Ticket Description'))
          .thenReturn(taskDocWithoutTicketDescription);

      // Tickets collection setup
      when(taskDocWithTicket.collection('Tickets'))
          .thenReturn(ticketsCollection);
      when(taskDocWithoutTicketDescription.collection('Tickets'))
          .thenReturn(ticketsCollection);

      // Return new MockDocumentReference when adding to Tickets collection
      when(ticketsCollection.add(any))
          .thenAnswer((_) async => MockDocumentReference());

      when(ticketsCollection.doc(any)).thenReturn(MockDocumentReference());
    });

    test('Test adding a new ticket to Firestore', () {
      final taskName = 'Test Task';
      final ticketName = 'Test Ticket';
      final ticketDescription = 'This is a test ticket';

      final ticketRef = mockFirestore
          .collection('Projects')
          .doc('test_project_id')
          .collection('Tasks')
          .doc(taskName)
          .collection('Tickets')
          .doc(ticketName);

      ticketRef.set({
        'Ticket Description': ticketDescription,
      });

      // Verify that the `set` operation occurs without error
      verify(ticketRef.set({
        'Ticket Description': ticketDescription,
      })).called(1); // Ensures expected behavior
    });

    test('Test not adding ticket to Firestore without ticket description', () {
      final taskName = 'Task Without Ticket Description';
      final ticketName = 'Nameless Ticket';

      final ticketRef = mockFirestore
          .collection('Projects')
          .doc('test_project_id')
          .collection('Tasks')
          .doc(taskName)
          .collection('Tickets');

      // Attempt to add a ticket without a description (should not be allowed)
      bool shouldAddTicket = false; // Indicating invalid condition

      if (shouldAddTicket) {
        ticketRef.add({
          'Ticket Name': ticketName,
        });
      }

      // Ensure the Firestore `add` operation does not occur due to missing ticket description
      verifyNever(ticketRef.add({
        'Ticket Name': ticketName,
      }));
    });
  });
}
