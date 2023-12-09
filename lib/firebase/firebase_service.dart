import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

FirebaseFirestore db = FirebaseFirestore.instance;
User? user = FirebaseAuth.instance.currentUser;
Future<List<Map<String, dynamic>>> getEvento() async {
  List<Map<String, dynamic>> eventos = [];
  QuerySnapshot queryEvento =
      await db.collection('events').where('user', isEqualTo: user?.uid).get();

  queryEvento.docs.forEach((documento) {
    Map<String, dynamic> eventoData =
        (documento.data() as Map<String, dynamic>);

    eventoData['id'] = documento.id; // Agrega el campo 'id' al mapa de datos
    eventos.add(eventoData);
  });

  return eventos;
}

Future<List<Map<String, dynamic>>> getInvitations(String eventId) async {
  List<Map<String, dynamic>> invitations = [];

  QuerySnapshot queryInvitations = await db
      .collection('invitations')
      .where('event', isEqualTo: eventId)
      .get();

  for (QueryDocumentSnapshot documento in queryInvitations.docs) {
    Map<String, dynamic> invitationData =
        documento.data() as Map<String, dynamic>;

    DocumentSnapshot userDocument =
        await db.collection('users').doc(invitationData['user']).get();

    if (userDocument.exists) {
      Map<String, dynamic> userData =
          userDocument.data() as Map<String, dynamic>;
      if (userData['name'] != null) {
        invitationData['nombre'] =
            userData['name'] + ' ' + userData['lastName'];
      }
    }

    invitationData['id'] = documento.id;
    invitations.add(invitationData);
  }

  return invitations;
}

Future<List<Map<String, dynamic>>> getMyInvitation() async {
  List<Map<String, dynamic>> invitations = [];

  QuerySnapshot queryInvitations = await db
      .collection('invitations')
      .where('user', isEqualTo: user?.uid)
      .get();

  for (QueryDocumentSnapshot documento in queryInvitations.docs) {
    Map<String, dynamic> invitationData =
        documento.data() as Map<String, dynamic>;

    DocumentSnapshot userDocument =
        await db.collection('events').doc(invitationData['event']).get();

    if (userDocument.exists) {
      Map<String, dynamic> userData =
          userDocument.data() as Map<String, dynamic>;
      invitationData['nameevent'] = userData['name'];
      invitationData['idevent'] = userDocument.id;
    }

    invitationData['id'] = documento.id;
    invitations.add(invitationData);
  }

  return invitations;
}
